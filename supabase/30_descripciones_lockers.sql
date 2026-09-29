-- =====================================================================
-- Cotizador TL — 30 · Arreglos en las descripciones de los lockers
--
--   1) "DIMESIÓN" → "DIMENSIÓN" (falta la N)
--   2) la descripción de un locker que cita el código de OTRO: el
--      L-300-T (Triple) dice "CÓDIGO L-300-D", que es el Doble
--
-- Las descripciones son la plantilla que va al PDF, así que el error se
-- imprime tal cual en la cotización del cliente.
--
-- OJO: va en el proyecto de Supabase del COTIZADOR TL. Para asegurarte:
--   select to_regclass('public.producto') as tabla;   -- debe decir "producto"
--
-- Correr en orden. Los pasos 1, 4 y 5 solo miran; el 2 y el 3 corrigen.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1) QUÉ SE VA A TOCAR (no cambia nada)
--
-- Solo salen los que tienen algo mal: los productos cuya descripción no
-- cita ningún código —cerraduras, fillers, ganchos— no son un problema y
-- quedan fuera.
-- ---------------------------------------------------------------------
select
  codigo_sap,
  nombre,
  case when descripcion ilike '%DIMESI%' then 'falta la N en DIMENSIÓN' end as falta_n,
  (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1]              as codigo_que_dice,
  case
    when (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is null then null
    when (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] <> codigo_sap
      then '⚠ cita el código de otro producto'
  end                                                                        as codigo_cruzado
from public.producto
where familia_codigo = 'LOCKERS'
  and (
    descripcion ilike '%DIMESI%'
    or ((regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is not null
        and (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] <> codigo_sap)
  )
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
--    Solo toca las que hoy dicen uno distinto. Las que ya están bien, y
--    las que no citan ninguno, no se reescriben.
-- ---------------------------------------------------------------------
update public.producto
   set descripcion = regexp_replace(
         descripcion, '(C[ÓO]DIGO:?\s*)[A-Z0-9-]+', '\1' || codigo_sap)
 where familia_codigo = 'LOCKERS'
   and (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is not null
   and (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] <> codigo_sap;

-- ---------------------------------------------------------------------
-- 4) VERIFICAR: no debería devolver NINGUNA fila
-- ---------------------------------------------------------------------
select codigo_sap, nombre,
       (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] as codigo_que_dice
  from public.producto
 where familia_codigo = 'LOCKERS'
   and (
     descripcion ilike '%DIMESI%'
     or ((regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] is not null
         and (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] <> codigo_sap)
   )
 order by codigo_sap;

-- ---------------------------------------------------------------------
-- 5) Cómo quedaron TODOS los lockers: su código y el que dice el texto.
--    Las dos columnas tienen que coincidir, o la segunda venir vacía.
-- ---------------------------------------------------------------------
select codigo_sap,
       nombre,
       (regexp_match(descripcion, 'C[ÓO]DIGO:?\s*([A-Z0-9-]+)'))[1] as codigo_que_dice,
       descripcion ilike '%DIMENSIÓN%'                              as dice_dimension_bien
  from public.producto
 where familia_codigo = 'LOCKERS'
   and es_extra = false
 order by codigo_sap;

-- ---------------------------------------------------------------------
-- 6) Los L-100 salen con dice_dimension_bien = false. Esto muestra qué
--    dicen de verdad: puede ser la tilde, o que no mencionen la medida.
-- ---------------------------------------------------------------------
select codigo_sap,
       substring(descripcion from 'DIME[A-ZÁÉÍÓÚ]*[^.]*') as lo_que_dice_de_la_medida
  from public.producto
 where familia_codigo = 'LOCKERS' and es_extra = false
 order by codigo_sap;

-- ---------------------------------------------------------------------
-- 7) Si el paso 6 mostró "DIMENSION" sin tilde, esto se la pone.
--    Si mostró vacío, NO es esto: esas descripciones no traen la medida.
-- ---------------------------------------------------------------------
-- update public.producto
--    set descripcion = replace(descripcion, 'DIMENSION', 'DIMENSIÓN')
--  where descripcion like '%DIMENSION%';
