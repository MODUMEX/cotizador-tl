-- =====================================================================
-- Cotizador TL — 28 · Borrado automático de cuentas desactivadas
-- Una cuenta de DISTRIBUIDOR que lleve más de 1 mes desactivada se elimina.
--
-- Qué se borra y qué NO:
--   · Se borra la cuenta (auth.users -> cascada a profiles).
--   · Las cotizaciones NO se borran: conservan su distribuidor (distribuidor_id)
--     y el nombre del vendedor (cotizado_por). Solo se suelta el vínculo
--     creado_por, que ninguna política de RLS usa (filtran por distribuidor_id).
--   · Queda constancia en public.cuenta_borrada.
--
-- OJO: en esta app "desactivada" y "pendiente de aprobación" son el mismo
-- estado (activo = false). Por eso el reloj lo arranca el TRIGGER, que solo
-- sella cuando una cuenta pasa de ACTIVA a INACTIVA. Un auto-registro nace
-- inactivo por INSERT: nunca se sella y nunca se borra solo.
--
-- Pegar completo en el SQL Editor de Supabase.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1) Cuándo se desactivó
-- ---------------------------------------------------------------------
alter table public.profiles add column if not exists desactivado_el timestamptz;

comment on column public.profiles.desactivado_el is
  'Momento en que la cuenta pasó de activa a inactiva. NULL = activa o nunca autorizada.';

-- El trigger manda: el cliente no puede falsear ni reiniciar la fecha.
create or replace function public.marcar_desactivacion() returns trigger
  language plpgsql as
$$
begin
  if new.activo then
    new.desactivado_el := null;                 -- reactivada: se borra el reloj
  elsif old.activo then
    new.desactivado_el := now();                -- activa -> inactiva: arranca el reloj
  else
    new.desactivado_el := old.desactivado_el;   -- seguía inactiva: no se reinicia
  end if;
  return new;
end $$;

drop trigger if exists trg_marcar_desactivacion on public.profiles;
create trigger trg_marcar_desactivacion
  before update on public.profiles
  for each row execute function public.marcar_desactivacion();

-- Arranque: las que HOY están desactivadas cuentan desde hoy.
-- Solo las que alguna vez se autorizaron (tienen empresa asignada);
-- las solicitudes nuevas sin empresa quedan fuera.
update public.profiles
   set desactivado_el = now()
 where activo = false
   and desactivado_el is null
   and rol = 'Distribuidor'
   and distribuidor_id is not null;

-- ---------------------------------------------------------------------
-- 2) Constancia de lo borrado
-- ---------------------------------------------------------------------
create table if not exists public.cuenta_borrada (
  cuenta_borrada_id bigint generated always as identity primary key,
  usuario_id        uuid not null,
  email             text,
  nombre            text,
  rol               text,
  distribuidor_id   bigint,
  distribuidor      text,
  desactivado_el    timestamptz,
  borrado_el        timestamptz not null default now()
);

alter table public.cuenta_borrada enable row level security;
drop policy if exists cuenta_borrada_select on public.cuenta_borrada;
create policy cuenta_borrada_select on public.cuenta_borrada for select
  using ( public.es_super() or public.es_admin() );

-- ---------------------------------------------------------------------
-- 3) La limpieza
-- ---------------------------------------------------------------------
create or replace function public.limpiar_cuentas_desactivadas(meses integer default 1)
  returns integer
  language plpgsql security definer set search_path = public, auth as
$$
declare
  corte timestamptz := now() - make_interval(months => greatest(meses, 1));
  p     record;
  n     integer := 0;
begin
  for p in
    select pr.id, pr.email, pr.nombre, pr.rol, pr.distribuidor_id,
           pr.desactivado_el, d.nombre as empresa
      from public.profiles pr
      left join public.distribuidor d on d.distribuidor_id = pr.distribuidor_id
     where pr.rol = 'Distribuidor'
       and pr.activo = false
       and pr.desactivado_el is not null
       and pr.desactivado_el < corte
  loop
    -- La cotización se queda con su distribuidor y su "cotizado_por".
    update public.cotizacion set creado_por = null where creado_por = p.id;

    insert into public.cuenta_borrada
      (usuario_id, email, nombre, rol, distribuidor_id, distribuidor, desactivado_el)
    values (p.id, p.email, p.nombre, p.rol, p.distribuidor_id, p.empresa, p.desactivado_el);

    delete from auth.users where id = p.id;     -- cascada: borra el profile
    n := n + 1;
  end loop;

  return n;
end $$;

revoke all on function public.limpiar_cuentas_desactivadas(integer) from public, anon, authenticated;
grant execute on function public.limpiar_cuentas_desactivadas(integer) to service_role;

-- ---------------------------------------------------------------------
-- 4) Que corra sola, todos los días a las 3:00 a.m. de Costa Rica (9:00 UTC)
--    Requiere la extensión pg_cron (Supabase > Database > Extensions).
-- ---------------------------------------------------------------------
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    if exists (select 1 from cron.job where jobname = 'limpiar_cuentas_desactivadas') then
      perform cron.unschedule('limpiar_cuentas_desactivadas');
    end if;
    perform cron.schedule('limpiar_cuentas_desactivadas', '0 9 * * *',
                          'select public.limpiar_cuentas_desactivadas(1)');
    raise notice 'Programado: todos los días 9:00 UTC (3:00 a.m. Costa Rica).';
  else
    raise notice 'pg_cron NO está activo. Actívalo en Database > Extensions y volvé a correr este bloque, o corré la limpieza a mano.';
  end if;
end $$;

-- =====================================================================
-- VERIFICAR (correr aparte, no borra nada)
-- =====================================================================
-- a) Quién está desactivado y cuándo le toca:
-- select p.email, p.nombre, d.nombre as empresa, p.desactivado_el,
--        p.desactivado_el + interval '1 month' as se_borra_el,
--        (p.desactivado_el + interval '1 month' < now()) as ya_vencio
--   from public.profiles p
--   left join public.distribuidor d on d.distribuidor_id = p.distribuidor_id
--  where p.activo = false and p.rol = 'Distribuidor'
--  order by p.desactivado_el;

-- b) Correr la limpieza a mano (devuelve cuántas borró):
-- select public.limpiar_cuentas_desactivadas(1);

-- c) Historial de cuentas borradas:
-- select * from public.cuenta_borrada order by borrado_el desc;

-- d) Ver el trabajo programado:
-- select jobname, schedule, active from cron.job where jobname = 'limpiar_cuentas_desactivadas';
