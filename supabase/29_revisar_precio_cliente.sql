-- =====================================================================
-- Cotizador TL — 29 · Diagnóstico: por qué un renglón sale con ese precio
--                     en el PDF del CLIENTE.  NO cambia nada.
--
-- El PDF del cliente muestra, por renglón:
--     unitario_cliente = precio_unitario × (1 − descuento_pct/100)   … si aplica_descuento
--     unitario_cliente = precio_unitario                             … si NO aplica
-- y el total le aplica encima el descuento que el distribuidor le da a su cliente.
--
-- Poné el folio en la primera línea y corré todo.
-- =====================================================================
with datos as (select '2490'::text as folio)   -- <<< CAMBIÁ EL FOLIO

-- ---------------------------------------------------------------------
-- 1) Renglón por renglón: lo que el cliente ve y de dónde sale
-- ---------------------------------------------------------------------
select
  l.orden,
  l.codigo_sap,
  pr.familia_codigo                      as familia,
  l.cantidad,
  l.precio_unitario                      as publico,
  l.descuento_pct                        as desc_distribuidor_pct,
  l.aplica_descuento,
  round(case when l.aplica_descuento
             then l.precio_unitario * (1 - l.descuento_pct/100)
             else l.precio_unitario end, 2)                       as unitario_en_pdf_cliente,
  round(l.cantidad * case when l.aplica_descuento
             then l.precio_unitario * (1 - l.descuento_pct/100)
             else l.precio_unitario end, 2)                       as importe_en_pdf_cliente,
  (c.app_json::jsonb -> 'Header' ->> 'DescuentoClientePct')::numeric as desc_que_le_da_al_cliente_pct,
  (c.app_json is null)                   as sin_estado_guardado,
  -- Lo que el renglón DEBERÍA traer según la ficha del distribuidor
  coalesce(dd.descuento_pct, d.descuento_pct, 0)                  as desc_esperado_pct,
  pr.aplica_descuento                    as producto_aplica_descuento,
  case
    when pr.producto_id is null                                   then 'texto libre (sin producto)'
    when not l.aplica_descuento and pr.aplica_descuento           then '⚠ el renglón quedó SIN descuento y el producto sí lo lleva'
    when not pr.aplica_descuento                                  then '⚠ el PRODUCTO está marcado sin descuento'
    when l.descuento_pct is distinct from coalesce(dd.descuento_pct, d.descuento_pct, 0)
                                                                  then '⚠ el % del renglón no es el de la ficha del distribuidor'
    else 'ok'
  end                                    as revisar
from public.cotizacion c
join public.cotizacion_linea l on l.cotizacion_id = c.cotizacion_id
left join public.producto pr   on pr.producto_id = l.producto_id
left join public.distribuidor d on d.distribuidor_id = c.distribuidor_id
left join public.distribuidor_descuento dd
       on dd.distribuidor_id = c.distribuidor_id
      and dd.familia_codigo  = pr.familia_codigo
where c.folio = (select folio from datos)
order by l.orden;

-- ---------------------------------------------------------------------
-- 2) Productos de LOCKERS marcados como "sin descuento"
--    (un locker así sale al PRECIO PÚBLICO en el PDF del cliente)
-- ---------------------------------------------------------------------
-- select codigo_sap, nombre, es_extra, aplica_descuento, activo
--   from public.producto
--  where familia_codigo = 'LOCKERS' and aplica_descuento = false
--  order by es_extra, codigo_sap;

-- ---------------------------------------------------------------------
-- 3) Descuentos por familia de ese distribuidor (0 aquí = sin descuento)
-- ---------------------------------------------------------------------
-- select d.nombre as distribuidor, d.descuento_pct as general,
--        dd.familia_codigo, dd.descuento_pct as por_familia
--   from public.distribuidor d
--   left join public.distribuidor_descuento dd on dd.distribuidor_id = d.distribuidor_id
--  where d.distribuidor_id = (select distribuidor_id from public.cotizacion
--                              where folio = (select folio from datos))
--  order by dd.familia_codigo;

-- ---------------------------------------------------------------------
-- 4) Extras del locker guardados en el estado de la cotización.
--    El precio del locker los lleva DENTRO del unitario (extras ÷ cantidad),
--    así que si acá no aparecen, el precio salió sin ellos.
-- ---------------------------------------------------------------------
select
  (ln.ord - 1)                                as renglon,
  ln.linea ->> 'FamiliaCodigo'                as familia,
  ln.linea ->> 'Cantidad'                     as cantidad,
  ln.linea -> 'ExtrasCant'                    as extras_guardados,
  ex.codigo_sap                               as extra_codigo,
  ex.nombre                                   as extra_nombre,
  kv.value                                    as extra_cantidad
from public.cotizacion c
cross join lateral jsonb_array_elements(c.app_json::jsonb -> 'Lineas')
       with ordinality as ln(linea, ord)
left join lateral jsonb_each_text(coalesce(ln.linea -> 'ExtrasCant', '{}'::jsonb)) as kv(key, value) on true
left join public.producto ex on ex.producto_id = kv.key::bigint
where c.folio = '2490'                        -- <<< EL MISMO FOLIO
  and ln.linea ->> 'FamiliaCodigo' = 'LOCKERS'
order by ln.ord;
