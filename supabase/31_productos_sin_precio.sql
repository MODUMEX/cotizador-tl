-- =====================================================================
-- Cotizador Thin Laminates — 31 · Productos que quedaron sin precio
-- Correr en el SQL Editor.
--
-- Cuando se da de alta un producto desde la versión vieja de la página
-- (modumexcr.github.io, v81) el producto se crea pero su precio falla con
-- "null value in column producto_id". El producto queda huérfano: aparece en
-- el catálogo y no se puede cotizar.
-- =====================================================================

-- PASO 1 · Ver cuáles quedaron sin ningún precio.
select p.producto_id, p.codigo_sap, p.familia_codigo, p.nombre, p.activo
  from public.producto p
 where not exists (select 1 from public.producto_precio pp
                    where pp.producto_id = p.producto_id)
 order by p.producto_id;

-- PASO 2 · Si son productos que SÍ se quieren, ponerles el precio a mano
-- (cambiar el id, el grupo y el monto) y repetir por cada grupo:
-- insert into public.producto_precio (producto_id, grupo, precio)
-- values (000, 'G1', 0.0000);

-- PASO 2-bis · Si fueron intentos fallidos y no sirven, borrarlos:
-- delete from public.producto p
--  where not exists (select 1 from public.producto_precio pp
--                     where pp.producto_id = p.producto_id);
