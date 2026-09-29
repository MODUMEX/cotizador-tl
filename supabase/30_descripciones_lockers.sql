-- =====================================================================
-- Cotizador TL — 30 · Arreglos en las descripciones de los lockers
--
--   1) "DIMESIÓN" → "DIMENSIÓN" (falta la N)
--   2) la descripción de un locker que cita el código de OTRO: el
--      L-300-T (Triple) dice "CÓDIGO: L-300-D", que es el Doble
--
-- Las descripciones son la plantilla que va al PDF, así que el error se
-- imprime tal cual en la cotización del cliente.
--
-- Correr los pasos EN ORDEN. El 1 y el 4 solo miran; el 2 y el 3 corrigen.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1) QUÉ SE VA A TOCAR (no cambia nada)
-- ---------------------------------------------------------------------
select
  codigo_sap,
  nombre,
  case when descripcion ilike '%DIMESI%' then 'falta la N en DIMENSIÓN' end as falta_n,
  -- el código que la descripción dice llevar
  (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1]             as codigo_que_dice,
  case
    when (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is null then null
    when (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] <> codigo_sap
      then '⚠ cita el código de otro producto'
  end                                                                       as codigo_cruzado
from public.producto
where familia_codigo = 'LOCKERS'
  and (descripcion ilike '%DIMESI%'
       or (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is distinct from codigo_sap)
order by codigo_sap;

-- ---------------------------------------------------------------------
-- 2) La N que falta en DIMENSIÓN, con y sin tilde
-- ---------------------------------------------------------------------
update public.producto
   set descripcion = replace(replace(descripcion, 'DIMESIÓN', 'DIMENSIÓN'), 'DIMESION', 'DIMENSIÓN')
 where descripcion ilike '%DIMESI%';

-- ---------------------------------------------------------------------
-- 3) Que cada descripción cite SU propio código
--
--    Solo toca las que hoy dicen uno distinto: la que ya está bien no se
--    reescribe. Deja el resto del texto intacto.
-- ---------------------------------------------------------------------
update public.producto
   set descripcion = regexp_replace(
         descripcion, '(C[ÓO]DIGO:?\s*)[A-Z0-9-]+', '\1' || codigo_sap)
 where familia_codigo = 'LOCKERS'
   and (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is not null
   and (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] <> codigo_sap;

-- ---------------------------------------------------------------------
-- 4) VERIFICAR: no debería devolver ninguna fila
-- ---------------------------------------------------------------------
select codigo_sap, nombre,
       (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] as codigo_que_dice
  from public.producto
 where familia_codigo = 'LOCKERS'
   and (descripcion ilike '%DIMESI%'
        or (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is distinct from codigo_sap)
 order by codigo_sap;

-- ---------------------------------------------------------------------
-- 5) De paso, la misma revisión en TODAS las familias, por si el error
--    se repite fuera de lockers (solo mira)
-- ---------------------------------------------------------------------
-- select familia_codigo, codigo_sap, nombre,
--        (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] as codigo_que_dice
--   from public.producto
--  where (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is distinct from codigo_sap
--     or descripcion ilike '%DIMESI%'
--  order by familia_codigo, codigo_sap;
