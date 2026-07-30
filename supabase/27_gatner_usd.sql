-- Las cerraduras electrónicas Gatner se cotizan en USD (el resto del catálogo está en MXN).
-- Al marcarlas 'USD', la app las convierte a la moneda del distribuidor:
--   México → MXN (× tipo de cambio), Costa Rica → CRC, LATAM → se queda en USD.
update public.producto set moneda = 'USD' where codigo_sap in ('C-GL7P', 'G-921727');
