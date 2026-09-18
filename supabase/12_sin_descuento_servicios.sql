-- =====================================================================
-- 12 · Instalación y flete NUNCA llevan descuento
--
-- El motor ya respeta la regla: un renglón con aplica_descuento = false no
-- recibe NINGUNO de los tres descuentos (distribuidor, cliente ni adicional).
-- Lo que puede estar mal es el dato: un producto de instalación o flete
-- cargado con el campo en true igual se descuenta.
--
-- Primero MIRAR, después corregir. Correr en el SQL Editor de Supabase.
-- =====================================================================

-- ---------- 1) ¿Qué hay hoy? (no cambia nada) ----------
select
  codigo_sap,
  familia_codigo,
  nombre,
  aplica_descuento,
  case
    when not aplica_descuento then 'OK · sin descuento'
    when familia_codigo = 'SERVICIOS' then 'REVISAR · es Servicios pero SÍ se descuenta'
    else 'REVISAR · parece instalación o flete y SÍ se descuenta'
  end as estado
from public.producto
where familia_codigo = 'SERVICIOS'
   or codigo_sap  ilike 'INST%'
   or codigo_sap  ilike 'FLETE%'
   or nombre      ilike '%instalaci%'
   or nombre      ilike '%flete%'
order by aplica_descuento desc, familia_codigo, codigo_sap;

-- ---------- 2) La corrección ----------
-- Descomentá y corré SOLO si el paso 1 mostró renglones en REVISAR.
--
-- update public.producto
--    set aplica_descuento = false
--  where aplica_descuento
--    and (familia_codigo = 'SERVICIOS'
--         or codigo_sap ilike 'INST%'
--         or codigo_sap ilike 'FLETE%'
--         or nombre     ilike '%instalaci%'
--         or nombre     ilike '%flete%');

-- ---------- 3) Que no vuelva a pasar ----------
-- Todo lo de la familia Servicios va sin descuento, lo cargue quien lo cargue.
alter table public.producto drop constraint if exists producto_servicios_sin_descuento;
alter table public.producto
  add constraint producto_servicios_sin_descuento
  check (familia_codigo <> 'SERVICIOS' or not aplica_descuento);
