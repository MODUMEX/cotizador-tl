-- =====================================================================
-- Cotizador Thin Laminates — 32 · Familia HERRAJES
-- Correr en el SQL Editor (una vez).
--
-- Hasta ahora los herrajes vivian dentro de LOCKERS marcados como "extra":
-- solo se podian colgar de un locker, nunca cotizar sueltos. Con esto pasan a
-- su propia familia y se pueden cotizar como la COT. 2597 (puros herrajes),
-- sin perder el INCLUYE del locker: la app los sigue buscando por la marca
-- es_extra, no por la familia.
-- =====================================================================

-- ---------- 1 · La familia ----------
insert into public.familia (codigo, nombre, aplica_descuento, orden) values
  ('HERRAJES','Herrajes y extras',true,35)
on conflict (codigo) do update
  set nombre = excluded.nombre,
      aplica_descuento = excluded.aplica_descuento,
      orden = excluded.orden;

-- ---------- 2 · Los extras de locker se mudan ----------
-- Siguen con es_extra = true, asi que no se caen del INCLUYE del locker.
update public.producto
   set familia_codigo = 'HERRAJES'
 where familia_codigo = 'LOCKERS'
   and es_extra = true;

-- ---------- 3 · El KJL81 duplicado ----------
-- Se dio de alta una segunda vez desde la pagina vieja y quedo sin precio.
-- El bueno (el del catalogo, $25) se queda.
delete from public.producto p
 where p.codigo_sap = 'KJL81'
   and not exists (select 1 from public.producto_precio pp
                    where pp.producto_id = p.producto_id);

-- ---------- 4 · Los tres que faltaban ----------
-- Quedaron creados sin precio (mismo bug): se completan en vez de rehacerlos.
update public.producto
   set familia_codigo = 'HERRAJES',
       es_extra       = true,
       descripcion    = case codigo_sap
                          when '140.426' then 'LLAVE MAESTRA PARA CERRADURA RIVEN DE FITNESS'
                          when 'T72-C'   then 'TORNILLO PARA JALADERA'
                          when 'TL41'    then 'TORNILLO ALLEN PARA CILINDRO, INOX M4-0.7 X 8 MM'
                          else descripcion
                        end
 where codigo_sap in ('140.426','T72-C','TL41');

-- Precios publicos de la COT. 2597.
insert into public.producto_precio (producto_id, grupo, precio)
select p.producto_id, 'UNICO',
       case p.codigo_sap when '140.426' then 50.0000
                         when 'T72-C'   then  6.0000
                         when 'TL41'    then  6.0000 end
  from public.producto p
 where p.codigo_sap in ('140.426','T72-C','TL41')
on conflict (producto_id, grupo) do nothing;

-- ---------- 5 · Precio de la cerradura RIVEN ----------
-- El catalogo la traia en 235 y la COT. 2597 la cobra en 294. Dayanna
-- confirmo que el bueno es 294 (2-oct-2026). El cambio queda en precio_log.
update public.producto_precio pp
   set precio = 294.0000
  from public.producto p
 where p.producto_id = pp.producto_id
   and p.codigo_sap = 'C-RIVEN'
   and pp.grupo = 'UNICO';

-- ---------- 6 · Revisar ----------
-- Debe salir la familia Herrajes con todos sus renglones y su precio.
select p.producto_id, p.codigo_sap, p.nombre, p.familia_codigo, pp.grupo, pp.precio
  from public.producto p
  left join public.producto_precio pp on pp.producto_id = p.producto_id
 where p.familia_codigo = 'HERRAJES'
 order by p.orden, p.codigo_sap;
