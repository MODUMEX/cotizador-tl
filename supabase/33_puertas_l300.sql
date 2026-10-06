-- =====================================================================
-- Cotizador Thin Laminates — 33 · Puertas de los lockers L-300
-- Correr en el SQL Editor (una vez).
--
-- El número entre paréntesis es el TOTAL de puertas del mueble: torres ×
-- puertas por torre. Toda la familia lo cumple menos dos, que quedaron
-- copiados de los L-200:
--
--   código     torres   modelo         debería   tenía
--   L-300-T      3      Triple (3)        9        6
--   L-300-Q      3      Quad   (4)       12        8
--
-- El L-300-T además arrastraba el código del hermano ("CÓDIGO L-300-D").
-- Se reemplaza solo ese pedazo del texto para no pisar el resto, que puede
-- haberse editado a mano desde Admin > Productos.
-- =====================================================================

update public.producto
   set descripcion = replace(
         replace(descripcion,
                 'CÓDIGO L-300-D (6 PUERTAS POR TORRE)',
                 'CÓDIGO L-300-T (9 PUERTAS POR TORRE)'),
         'CÓDIGO L-300-T (6 PUERTAS POR TORRE)',
         'CÓDIGO L-300-T (9 PUERTAS POR TORRE)')
 where codigo_sap = 'L-300-T';

update public.producto
   set descripcion = replace(descripcion,
         'CÓDIGO L-300-Q (8 PUERTAS POR TORRE)',
         'CÓDIGO L-300-Q (12 PUERTAS POR TORRE)')
 where codigo_sap = 'L-300-Q';

-- ---------- Revisar ----------
-- Los nueve tienen que quedar con torres × puertas: 2 3 4 | 4 6 8 | 6 9 12.
select codigo_sap,
       substring(descripcion from 'CÓDIGO L-[0-9]+-[DTQ] \([0-9]+ PUERTAS POR TORRE\)') as dice
  from public.producto
 where codigo_sap like 'L-_00-%'
 order by codigo_sap;
