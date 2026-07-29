-- Logo de cada empresa distribuidora (data URI base64: data:image/png;base64,...)
-- Se muestra en el PDF de la cotización, a la par del logo de Thin Laminates.
alter table distribuidor add column if not exists logo text;
