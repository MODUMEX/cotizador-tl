-- =====================================================================
-- Cotizador Thin Laminates — 03 · Seed del catálogo (configurador real)
-- Generado por scripts/build_seed.py — NO editar a mano.
-- Requiere 09_configurador.sql (columna es_extra + tabla color) ya aplicado.
-- =====================================================================

truncate table public.producto_precio, public.producto restart identity cascade;
delete from public.familia;
delete from public.color;

insert into public.familia (codigo,nombre,aplica_descuento,orden) values
  ('CUBIERTAS','Cubiertas',true,10),
  ('LOCKERS','Lockers',true,20),
  ('BANCAS','Bancas',true,30),
  ('SERVICIOS','Servicios (instalación/flete)',false,40)
on conflict (codigo) do update set nombre=excluded.nombre, aplica_descuento=excluded.aplica_descuento, orden=excluded.orden;

do $$
declare pid bigint;
begin
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-ESP','CUBIERTAS','Cubierta redonda medida especial','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: __ CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','m2','m2','MXN',null,true,true,true,false,1) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4170.9866);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4484.9319);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4823.6808);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5520.6402);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'ESP_INT',5005.184);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'ESP_EXT',6624.7683);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-ESP','CUBIERTAS','Cubierta cuadrada medida especial','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: __ CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','m2','m2','MXN',null,true,true,true,false,2) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4170.9866);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4484.9319);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4823.6808);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5520.6402);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'ESP_INT',5005.184);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'ESP_EXT',6624.7683);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-ESP','CUBIERTAS','Cubierta rectangular medida especial','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: __ CM X __ CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','m2','m2','MXN',null,true,false,true,false,2) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4170.9866);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4484.9319);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4823.6808);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5520.6402);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'ESP_INT',5005.184);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'ESP_EXT',6624.7683);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CU-ESP','CUBIERTAS','Cubierta forma irregular medida especial','SUMINISTRO DE CUBIERTA FORMA IRREGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: __ CM X __ CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','m2','m2','MXN',null,true,false,true,false,3) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4170.9866);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4484.9319);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4823.6808);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5520.6402);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'ESP_INT',5005.184);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'ESP_EXT',6624.7683);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-50','CUBIERTAS','Cubierta redonda 50 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 50 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,10) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',1042.7467);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',1121.233);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',1205.9202);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',1380.1601);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-5050','CUBIERTAS','Cubierta cuadrada 50x50','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 50 CM X 50 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,11) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',1042.7467);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',1121.233);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',1205.9202);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',1380.1601);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-60','CUBIERTAS','Cubierta redonda 60 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,12) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',1501.5552);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',1614.5755);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',1736.5251);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',1987.4305);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-6060','CUBIERTAS','Cubierta cuadrada 60x60','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM X 60 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,13) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',1501.5552);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',1614.5755);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',1736.5251);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',1987.4305);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-70','CUBIERTAS','Cubierta redonda 70 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 70 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,14) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2043.7835);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2197.6166);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2363.6036);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',2705.1137);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-7070','CUBIERTAS','Cubierta cuadrada 70x70','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 70 CM X 70 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,15) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2043.7835);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2197.6166);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2363.6036);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',2705.1137);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-75','CUBIERTAS','Cubierta redonda 75 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 75 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,16) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2346.18);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2522.7742);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2713.3205);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3105.3601);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-7575','CUBIERTAS','Cubierta cuadrada 75x75','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 75 CM X 75 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,17) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2346.18);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2522.7742);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2713.3205);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3105.3601);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-80','CUBIERTAS','Cubierta redonda 80 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 80 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,18) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2669.4314);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2870.3564);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3087.1557);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3533.2097);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-8080','CUBIERTAS','Cubierta cuadrada 80x80','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 80 CM X 80 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,19) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2669.4314);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2870.3564);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3087.1557);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3533.2097);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-90','CUBIERTAS','Cubierta redonda 90 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 90 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,20) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3378.4992);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',3632.7948);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3907.1815);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',4471.7186);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-9090','CUBIERTAS','Cubierta cuadrada 90x90','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 90 CM X 90 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,21) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3378.4992);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',3632.7948);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3907.1815);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',4471.7186);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-100','CUBIERTAS','Cubierta redonda 100 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 100 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,22) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4170.9866);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4484.9319);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4823.6808);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5520.6402);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-100100','CUBIERTAS','Cubierta cuadrada 100x100','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 100 CM X 100 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,23) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4170.9866);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4484.9319);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4823.6808);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5520.6402);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-120','CUBIERTAS','Cubierta redonda 120 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 120 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,24) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',6006.2208);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',6458.3019);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',6946.1004);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',7949.7219);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-120120','CUBIERTAS','Cubierta cuadrada 120x120','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 120 CM X 120 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,25) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',6006.2208);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',6458.3019);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',6946.1004);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',7949.7219);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CR-150','CUBIERTAS','Cubierta redonda 150 cm Ø','SUMINISTRO DE CUBIERTA REDONDA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 150 CM DIÁMETRO GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,26) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',9384.7199);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',10091.0967);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CC-150150','CUBIERTAS','Cubierta cuadrada 150x150','SUMINISTRO DE CUBIERTA CUADRADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 150 CM X 150 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,27) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',9384.7199);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',10091.0967);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-6070','CUBIERTAS','Cubierta rectangular 60x70','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM X 70 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,28) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',1751.8144);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',1883.6714);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2025.9459);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',2318.6689);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-6080','CUBIERTAS','Cubierta rectangular 60x80','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM X 80 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,29) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2002.0736);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2152.7673);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2315.3668);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',2649.9073);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-6090','CUBIERTAS','Cubierta rectangular 60x90','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM X 90 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,30) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2252.3328);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2421.8632);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2604.7876);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',2981.1457);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-60100','CUBIERTAS','Cubierta rectangular 60x100','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM X 100 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,31) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2502.592);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2690.9591);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2894.2085);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3312.3841);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-60120','CUBIERTAS','Cubierta rectangular 60x120','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM X 120 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,32) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3003.1104);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',3229.1509);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3473.0502);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3974.861);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-60150','CUBIERTAS','Cubierta rectangular 60x150','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM X 150 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,33) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3753.888);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4036.4387);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4341.3127);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',4968.5762);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-60180','CUBIERTAS','Cubierta rectangular 60x180','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 60 CM X 180 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,34) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4504.6656);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4843.7264);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',5209.5753);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5962.2914);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-7080','CUBIERTAS','Cubierta rectangular 70x80','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 70 CM X 80 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,35) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2335.7525);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2511.5618);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',2701.2613);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3091.5585);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-7090','CUBIERTAS','Cubierta rectangular 70x90','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 70 CM X 90 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,36) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2627.7216);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',2825.5071);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3038.9189);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3478.0033);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-70100','CUBIERTAS','Cubierta rectangular 70x100','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 70 CM X 100 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,37) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2919.6906);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',3139.4523);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3376.5766);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3864.4481);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-70120','CUBIERTAS','Cubierta rectangular 70x120','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 70 CM X 120 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,38) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3503.6288);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',3767.3428);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4051.8919);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',4637.3378);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-70150','CUBIERTAS','Cubierta rectangular 70x150','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 70 CM X 150 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,39) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4379.536);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4709.1785);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',5064.8649);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5796.6722);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-70180','CUBIERTAS','Cubierta rectangular 70x180','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 70 CM X 180 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,40) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',5255.4432);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',5651.0142);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',6077.8378);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',6956.0067);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-7590','CUBIERTAS','Cubierta rectangular 75x90','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 75 CM X 90 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,41) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2815.416);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',3027.329);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3255.9846);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3726.4321);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-8090','CUBIERTAS','Cubierta rectangular 80x90','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 80 CM X 90 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,42) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3003.1104);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',3229.1509);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3473.0502);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',3974.861);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-80100','CUBIERTAS','Cubierta rectangular 80x100','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 80 CM X 100 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,43) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3336.7893);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',3587.9455);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',3858.9447);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',4416.5122);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-80120','CUBIERTAS','Cubierta rectangular 80x120','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 80 CM X 120 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,44) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4004.1472);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4305.5346);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4630.7336);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5299.8146);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-80150','CUBIERTAS','Cubierta rectangular 80x150','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 80 CM X 150 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,45) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',5005.184);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',5381.9182);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',5788.417);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',6624.7683);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-80180','CUBIERTAS','Cubierta rectangular 80x180','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 80 CM X 180 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,46) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',6006.2208);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',6458.3019);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',6946.1004);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',7949.7219);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-90100','CUBIERTAS','Cubierta rectangular 90x100','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 90 CM X 100 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,47) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3753.888);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4036.4387);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',4341.3127);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',4968.5762);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-90120','CUBIERTAS','Cubierta rectangular 90x120','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 90 CM X 120 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,48) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4504.6656);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',4843.7264);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',5209.5753);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',5962.2914);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-90150','CUBIERTAS','Cubierta rectangular 90x150','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 90 CM X 150 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,49) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',5630.832);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',6054.658);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',6511.9691);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',7452.8643);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-90180','CUBIERTAS','Cubierta rectangular 90x180','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 90 CM X 180 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,50) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',6756.9984);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',7265.5896);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',7814.3629);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',8943.4371);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-100120','CUBIERTAS','Cubierta rectangular 100x120','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 100 CM X 120 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,51) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',5005.184);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',5381.9182);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',5788.417);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',6624.7683);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-100150','CUBIERTAS','Cubierta rectangular 100x150','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 100 CM X 150 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,52) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',6256.48);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',6727.3978);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',7235.5212);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',8280.9603);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-100180','CUBIERTAS','Cubierta rectangular 100x180','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 100 CM X 180 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,53) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',7507.776);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',8072.8774);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',8682.6255);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',9937.1524);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-120150','CUBIERTAS','Cubierta rectangular 120x150','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 120 CM X 150 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,54) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',7507.776);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',8072.8774);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',8682.6255);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',9937.1524);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('CT-120180','CUBIERTAS','Cubierta rectangular 120x180','SUMINISTRO DE CUBIERTA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 120 CM X 180 CM GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __','fijo','pieza','MXN','12 mm',false,false,true,false,55) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',9009.3311);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G2',9687.4528);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G3',10419.1506);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G4',11924.5829);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-100-D','LOCKERS','Locker SMART Doble L-100','SUMINISTRO DE LOCKER SMART MODELO DOBLE, CÓDIGO L-100-D (2 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMENSIONES POR MUEBLE: 38 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,1) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',11776.7885);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-100-T','LOCKERS','Locker SMART Triple L-100','SUMINISTRO DE LOCKER SMART MODELO TRIPLE, CÓDIGO L-100-T (3 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMENSIONES POR MUEBLE: 38 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,2) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',11776.7885);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-100-Q','LOCKERS','Locker SMART Quad L-100','SUMINISTRO DE LOCKER SMART MODELO QUAD, CÓDIGO L-100-Q (4 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMENSIONES POR MUEBLE: 38 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,3) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',11776.7885);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-100-E','LOCKERS','Locker SMART Ejecutivo L-100','SUMINISTRO DE LOCKER SMART MODELO EJECUTIVO, CÓDIGO L-100-E (2 PUERTAS FORMA IRREGULAR POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMENSIONES POR MUEBLE: 38 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,4) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',11776.7885);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-200-D','LOCKERS','Locker SMART Doble L-200','SUMINISTRO DE MUEBLE COMPUESTO POR 2 TORRES DE LOCKERS LÍNEA SMART MODELO DOBLE, CÓDIGO L-200-D (4 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMESIÓN POR MUEBLE: 76 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,5) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',22375.8982);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-200-T','LOCKERS','Locker SMART Triple L-200','SUMINISTRO DE MUEBLE COMPUESTO POR 2 TORRES DE LOCKERS LÍNEA SMART MODELO TRIPLE, CÓDIGO L-200-T (6 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMESIÓN POR MUEBLE: 76 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,6) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',22375.8982);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-200-Q','LOCKERS','Locker SMART Quad L-200','SUMINISTRO DE MUEBLE COMPUESTO POR 2 TORRES DE LOCKERS LÍNEA SMART MODELO QUAD, CÓDIGO L-200-Q (8 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMESIÓN POR MUEBLE: 76 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,7) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',22375.8982);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-200-E','LOCKERS','Locker SMART Ejecutivo L-200','SUMINISTRO DE MUEBLE COMPUESTO POR 2 TORRES DE LOCKERS LÍNEA SMART MODELO EJECUTIVO, CÓDIGO L-200-E (4 PUERTAS FORMA IRREGULAR POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMESIÓN POR MUEBLE: 76 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,8) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',22375.8982);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-300-D','LOCKERS','Locker SMART Doble L-300','SUMINISTRO DE MUEBLE COMPUESTO POR 3TORRES DE LOCKERS LÍNEA SMART MODELO DOBLE, CÓDIGO L-300-D (6 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
 DIMESIÓN POR MUEBLE: 114 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,9) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',31796.1513);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-300-T','LOCKERS','Locker SMART Triple L-300','SUMINISTRO DE MUEBLE COMPUESTO POR 3TORRES DE LOCKERS LÍNEA SMART MODELO TRIPLE, CÓDIGO L-300-D (6 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
 DIMESIÓN POR MUEBLE: 114 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,10) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',31796.1513);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-300-Q','LOCKERS','Locker SMART Quad L-300','SUMINISTRO DE MUEBLE COMPUESTO POR 3TORRES DE LOCKERS LÍNEA SMART MODELO QUAD, CÓDIGO L-300-Q (8 PUERTAS POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMESIÓN POR MUEBLE: 114 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,11) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',31796.1513);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('L-300-E','LOCKERS','Locker SMART Ejecutivo L-300','SUMINISTRO DE MUEBLE COMPUESTO POR 3TORRES DE LOCKERS LÍNEA SMART MODELO EJECUTIVO, CÓDIGO L-300-E (6 PUERTAS FORMA IRREGULAR POR TORRE), MARCA THIN LAMINATES. FABRICADO CON ESTRUCTURA INTERNA A CUATRO PUNTOS (EN CADA ESQUINA) EN PERFILERÍA DE ALUMINIO TEMPLE 6 Y LAMINADO COMPACTO. INTEGRA PANELERÍA EN 6 MM DE ESPESOR PARA FONDO, LATERALES Y ENTREPAÑOS, ASÍ COMO PUERTAS Y ZOCLO EN 12.7 MM DE ESPESOR.
DIMESIÓN POR MUEBLE: 114 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATAS NIVELADORAS SILENCIADORES, CERRADURA O PORTACANDADO,Y ZOCLO (OPCIONAL).
GARANTÍA DE 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN PRODUCTO TERMINADO.','fijo','pieza','MXN','Aluminio/L.C.',false,false,true,false,12) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',31796.1513);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('LODOBLEST','LOCKERS','Locker PRO Doble (por torre)','SUMINISTRO DE LOCKER PRO MODELO DOBLE CODIGO: LODOBLEST (DOS PUERTAS POR TORRE) MARCA GRUPO MODUMEX /THIN LAMINATES FABRICADO DE LAMINADO COMPACTO EN COMBINACIÓN DE ESPESORES: FONDO DE 3MM DE ESPESOR, LATERALES Y ENTREPAÑOS DE 9MM DE ESPESOR Y PUERTAS Y ZOCLOS EN 12.7 MM DE ESPESOR. DIMENSIÓN POR TORRE: 38 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATA NIVELADORA, CERRADURA O PORTACANDADO Y ZOCLO (OPCIONAL) GARANTIA 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS PRODUCTO TERMINADO','fijo','pieza','MXN','L.C.',false,false,true,false,13) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',13210.32);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('LOTRIPLEST','LOCKERS','Locker PRO Triple (por torre)','SUMINISTRO DE LOCKER PRO MODELO TRIPLE CODIGO: LOTRIPLEST (TRES PUERTAS POR TORRE) MARCA GRUPO MODUMEX /THIN LAMINATES FABRICADO DE LAMINADO COMPACTO EN COMBINACIÓN DE ESPESORES: FONDO DE 3MM DE ESPESOR, LATERALES Y ENTREPAÑOS DE 9MM DE ESPESOR Y PUERTAS Y ZOCLOS EN 12.7 MM DE ESPESOR. DIMENSIÓN POR TORRE: 38 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATA NIVELADORA, CERRADURA O PORTACANDADO Y ZOCLO (OPCIONAL) GARANTIA 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS PRODUCTO TERMINADO','fijo','pieza','MXN','L.C.',false,false,true,false,14) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',13210.32);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('LOQUADST','LOCKERS','Locker PRO Quad (por torre)','SUMINISTRO DE LOCKER PRO MODELO QUAD CODIGO: LOQUADST (CUATRO PUERTAS POR TORRE) MARCA GRUPO MODUMEX /THIN LAMINATES FABRICADO DE LAMINADO COMPACTO EN COMBINACIÓN DE ESPESORES: FONDO DE 3MM DE ESPESOR, LATERALES Y ENTREPAÑOS DE 9MM DE ESPESOR Y PUERTAS Y ZOCLOS EN 12.7 MM DE ESPESOR. DIMENSIÓN POR TORRE: 38 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATA NIVELADORA, CERRADURA O PORTACANDADO Y ZOCLO (OPCIONAL) GARANTIA 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS PRODUCTO TERMINADO','fijo','pieza','MXN','L.C.',false,false,true,false,15) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',13210.32);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('LOEJECST','LOCKERS','Locker PRO Ejecutivo (por torre)','SUMINISTRO DE LOCKER PRO MODELO EJECUTIVO CODIGO: LOEJECST (2 PUERTAS FORMA IRREGULAR POR TORRE) MARCA GRUPO MODUMEX /THIN LAMINATES FABRICADO DE LAMINADO COMPACTO EN COMBINACIÓN DE ESPESORES: FONDO DE 3MM DE ESPESOR, LATERALES Y ENTREPAÑOS DE 9MM DE ESPESOR Y PUERTAS Y ZOCLOS EN 12.7 MM DE ESPESOR. DIMENSIÓN POR TORRE: 38 CM DE FRENTE, 45 CM DE PROFUNDIDAD Y 190 CM DE ALTURA. INCLUYE: JALADERAS, PATA NIVELADORA, CERRADURA O PORTACANDADO Y ZOCLO (OPCIONAL) GARANTIA 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS PRODUCTO TERMINADO','fijo','pieza','MXN','L.C.',false,false,true,false,16) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',13210.32);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('LOESPECIAL','LOCKERS','Vestidor / Locker PRO de línea','SUMINISTRO DE LOCKER PRO MODELO ESPECIAL CODIGO: LOESPECIAL(XXX PUERTAS POR TORRE) MARCA THIN LAMINATES FABRICADO DE LAMINADO COMPACTO EN COMBINACIÓN DE ESPESORES: FONDO DE 3MM DE ESPESOR, LATERALES Y ENTREPAÑOS DE 9MM DE ESPESOR Y PUERTAS Y ZOCLOS EN 12.7 MM DE ESPESOR. DIMESIÓN POR TORRE: XX CM DE FRENTE, XX CM DE PROFUNDIDAD Y XXX CM DE ALTURA. INCLUYE: JALADERAS, PATA NIVELADORA, CERRADURA O PORTACANDADO Y ZOCLO (OPCIONAL) GARANTIA 25 AÑOS EN LAMINADO COMPACTO Y 10 AÑOS EN  PRODUCTO TERMINADO','fijo','pieza','MXN','L.C.',false,false,true,false,17) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',18287.94);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('LO-PRO-ESP','LOCKERS','Locker PRO especial (por m²)','LOCKER PRO ESPECIAL FABRICADO EN LAMINADO COMPACTO. MEDIDA FINAL: __','m2','m2','MXN',null,true,false,true,false,18) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'3mm',2796.758);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'12mm',4170.9866);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('LO-SMART-ESP','LOCKERS','Locker SMART especial (por m²)','LOCKER SMART ESPECIAL FABRICADO EN LAMINADO COMPACTO. MEDIDA FINAL: __','m2','m2','MXN',null,true,false,true,false,19) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'3mm',2447.1633);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'6mm',2885.0999);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'9mm',3542.9793);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'12mm',3892.9209);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('G-LOCKER','LOCKERS','Grabado láser por puerta (máx 30x30cm)','GRABADO LASER DE NUMERO O LOGO POR PUERTA EN LOCKER MAX 30CM X 30CM','fijo','pieza','MXN',null,false,false,true,true,200) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',120);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('RP-LOCKER','LOCKERS','Ranura o perforación SMA por puerta','RANURA O PERFORACIÓN SMA POR PUERTA EN LOCKER','fijo','pieza','MXN',null,false,false,true,true,201) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',50);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('C-HEFELE','LOCKERS','Cerradura Hafele 22mm (llave)','CERRADURA HAFELE 22MM PARA LOCKER - CERRADURA DE LLAVE','fijo','pieza','MXN',null,false,false,true,true,202) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',265.78);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('C-RIVEN','LOCKERS','Cerradura horizontal Riven 4 dígitos','CERRADURA HORIZONTAL RIVEN DE 4 DIGITOS','fijo','pieza','MXN',null,false,false,true,true,203) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',235);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('KPC','LOCKERS','Kit portacandado','Kit portacandado','fijo','pieza','MXN',null,false,false,true,true,204) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',78.38);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('FE4161','LOCKERS','Pata niveladora aluminio 10cm','Pata niveladora aluminio 10cm','fijo','pieza','MXN',null,false,false,true,true,205) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',60);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('GANCHO','LOCKERS','Gancho para colgar','Gancho para colgar','fijo','pieza','MXN',null,false,false,true,true,206) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',97.5);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('TO0021','LOCKERS','Tubo para colgar','Tubo para colgar','fijo','pieza','MXN',null,false,false,true,true,207) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',209);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('ZOCLO-127','LOCKERS','Zoclo lateral 12.7mm','Zoclo lateral 12.7mm','fijo','pieza','MXN',null,false,false,true,true,208) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',170);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('HERRAJES','LOCKERS','Herrajes por puerta','Herrajes por puerta','fijo','pieza','MXN',null,false,false,true,true,209) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',150);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('KJL81','LOCKERS','Kit jaladera aluminio','Kit jaladera aluminio','fijo','pieza','MXN',null,false,false,true,true,210) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',25);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('KEB','LOCKERS','Kit escuadra + 2 tornillos T4','Kit escuadra + 2 tornillos T4','fijo','pieza','MXN',null,false,false,true,true,211) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',50);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('C-GL7P','LOCKERS','Cerradura electrónica Gatner GL7P (teclado)','Cerradura electrónica Gatner GL7P (teclado)','fijo','pieza','USD',null,false,false,true,true,212) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',170.35);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('G-921727','LOCKERS','Cerradura electrónica Gatner GAT ECO 7100','Cerradura electrónica Gatner GAT ECO 7100','fijo','pieza','USD',null,false,false,true,true,213) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',141.4);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('FILLER-08-10','LOCKERS','Filler 8-10 cm','','fijo','pieza','MXN',null,false,false,true,true,240) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'PRO',531.384);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'SMART',464.961);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('FILLER-11-15','LOCKERS','Filler 11-15 cm','','fijo','pieza','MXN',null,false,false,true,true,241) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'PRO',797.076);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'SMART',697.4415);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('FILLER-16-20','LOCKERS','Filler 16-20 cm','','fijo','pieza','MXN',null,false,false,true,true,242) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'PRO',1062.768);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'SMART',929.922);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('FILLER-21-25','LOCKERS','Filler 21-25 cm','','fijo','pieza','MXN',null,false,false,true,true,243) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'PRO',1328.4601);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'SMART',1162.4026);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('FILLER-26-30','LOCKERS','Filler 26-30 cm','','fijo','pieza','MXN',null,false,false,true,true,244) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'PRO',1594.1521);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'SMART',1394.8831);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('FILLER-31-37','LOCKERS','Filler 31-37 cm','','fijo','pieza','MXN',null,false,false,true,true,245) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'PRO',1966.1209);
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'SMART',1720.3558);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('BAR-76','BANCAS','Banca rectangular 76 cm','SUMINISTRO DE BANCA RECTANGULAR CODIGO: BAR-76  FABRICADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 76 CM DE LARGO X 35 CM DE ANCHO X 45 CM DE ALTO. GARANTIA 25 AÑOS EN LAMINADO COMPACTO','fijo','pieza','MXN','12 mm',false,false,true,false,76) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2423.3432);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('BAR-90','BANCAS','Banca rectangular 90 cm','SUMINISTRO DE BANCA RECTANGULAR CODIGO: BAR-90  FABRICADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 90 CM DE LARGO X 35 CM DE ANCHO X 45 CM DE ALTO. GARANTIA 25 AÑOS EN LAMINADO COMPACTO','fijo','pieza','MXN','12 mm',false,false,true,false,90) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2627.7216);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('BAR-114','BANCAS','Banca rectangular 114 cm','SUMINISTRO DE BANCA RECTANGULAR CODIGO: BAR-114 FABRICADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 114 CM DE LARGO X 35 CM DE ANCHO X 45 CM DE ALTO. GARANTIA 25 AÑOS EN LAMINADO COMPACTO','fijo','pieza','MXN','12 mm',false,false,true,false,114) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',2978.0845);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('BAR-152','BANCAS','Banca rectangular 152 cm','SUMINISTRO DE BANCA RECTANGULAR CODIGO: BAR-152  FABRICADA DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: 152 CM DE LARGO X 35 CM DE ANCHO X 45 CM DE ALTO. GARANTIA 25 AÑOS EN LAMINADO COMPACTO','fijo','pieza','MXN','12 mm',false,false,true,false,152) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',3532.8257);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('BAR-ESP','BANCAS','Banca especial (por m²)','SUMINISTRO DE BANCA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: __. GARANTÍA 25 AÑOS EN LAMINADO COMPACTO','m2','m2','MXN',null,true,false,true,false,200) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'G1',4170.9866);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('INST-CUB','SERVICIOS','Instalación por cubierta','','fijo','pieza','MXN',null,false,false,false,false,1) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',250);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('INST-FILLER','SERVICIOS','Instalación por filler','','fijo','pieza','MXN',null,false,false,false,false,2) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',450);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('INST-L100','SERVICIOS','Instalación locker SMART L-100','','fijo','pieza','MXN',null,false,false,false,false,3) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',450);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('INST-L200','SERVICIOS','Instalación locker SMART L-200','','fijo','pieza','MXN',null,false,false,false,false,4) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',800);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('INST-L300','SERVICIOS','Instalación locker SMART L-300','','fijo','pieza','MXN',null,false,false,false,false,5) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',1100);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('INST-BANCA','SERVICIOS','Instalación por banca','','fijo','pieza','MXN',null,false,false,false,false,6) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',300);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('INST-TORRE-PRO','SERVICIOS','Instalación por torre PRO','','fijo','pieza','MXN',null,false,false,false,false,7) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',450);
  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values ('FLETE-LOCAL','SERVICIOS','Flete local menor a 60 km','','fijo','pieza','MXN',null,false,false,false,false,8) returning producto_id into pid;
  insert into public.producto_precio (producto_id,grupo,precio) values (pid,'UNICO',1500);
end $$;

insert into public.color (nombre,grupo,ambito,region,tiempo_especial) values
  ('Negro','G1','cubierta_int','MXN',false),
  ('Gris Metalizado','G1','cubierta_int','MXN',false),
  ('Blanco','G1','cubierta_int','MXN',false),
  ('Alúmina','G1','cubierta_int','MXN',false),
  ('Grafito Nocturno','G1','cubierta_int','MXN',false),
  ('Walnut Heights','G1','cubierta_int','MXN',false),
  ('Skyline Walnut','G1','cubierta_int','MXN',false),
  ('Calcutta Marble','G2','cubierta_int','MXN',false),
  ('White Marble','G3','cubierta_int','MXN',false),
  ('Roble Lineal','G4','cubierta_ext','MXN',false),
  ('Italian Walnut','G4','cubierta_ext','MXN',false),
  ('Atenas','G4','cubierta_ext','MXN',false),
  ('Tiziano','G4','cubierta_ext','MXN',false),
  ('Industrial Concrete','G4','cubierta_ext','MXN',false),
  ('Dark Steel','G4','cubierta_ext','MXN',true),
  ('Vanilla','G4','cubierta_ext','MXN',true),
  ('Negro','G1','locker_frente','MXN',false),
  ('Gris Metalizado','G1','locker_frente','MXN',false),
  ('Blanco','G1','locker_frente','MXN',false),
  ('Alúmina','G1','locker_frente','MXN',false),
  ('Grafito Nocturno','G1','locker_frente','MXN',false),
  ('Walnut Heights','G1','locker_frente','MXN',false),
  ('Skyline Walnut','G1','locker_frente','MXN',false),
  ('Alúmina','INT','locker_interior','MXN',false),
  ('Negro','INT','locker_interior','MXN',false),
  ('Blanco','INT','locker_interior','MXN',false),
  ('Negro','G1','banca','MXN',false),
  ('Gris Metalizado','G1','banca','MXN',false),
  ('Blanco','G1','banca','MXN',false),
  ('Alúmina','G1','banca','MXN',false),
  ('Grafito Nocturno','G1','banca','MXN',false),
  ('Walnut Heights','G1','banca','MXN',false),
  ('Skyline Walnut','G1','banca','MXN',false),
  ('Blanco','G1','cubierta_int','LATAM',false),
  ('Gris','G1','cubierta_int','LATAM',false),
  ('Grafito Nocturno','G1','cubierta_int','LATAM',false),
  ('Negro','G1','cubierta_int','LATAM',false),
  ('Ámbar Wood','G1','cubierta_int','LATAM',false),
  ('Nogal Grafito','G1','cubierta_int','LATAM',false),
  ('Inox Satín','G1','cubierta_int','LATAM',false),
  ('Roble Lineal','G4','cubierta_ext','LATAM',false),
  ('Italian Walnut','G4','cubierta_ext','LATAM',false),
  ('Atenas','G4','cubierta_ext','LATAM',false),
  ('Tiziano','G4','cubierta_ext','LATAM',false),
  ('Industrial Concrete','G4','cubierta_ext','LATAM',false),
  ('Dark Steel','G4','cubierta_ext','LATAM',true),
  ('Vanilla','G4','cubierta_ext','LATAM',true),
  ('Negro','G1','locker_frente','LATAM',false),
  ('Inox Satín','G1','locker_frente','LATAM',false),
  ('Blanco','G1','locker_frente','LATAM',false),
  ('Gris','G1','locker_frente','LATAM',false),
  ('Grafito Nocturno','G1','locker_frente','LATAM',false),
  ('Ámbar Wood','G1','locker_frente','LATAM',false),
  ('Nogal Grafito','G1','locker_frente','LATAM',false),
  ('Gris','INT','locker_interior','LATAM',false),
  ('Negro','INT','locker_interior','LATAM',false),
  ('Blanco','INT','locker_interior','LATAM',false),
  ('Blanco','G1','banca','LATAM',false),
  ('Gris','G1','banca','LATAM',false),
  ('Grafito Nocturno','G1','banca','LATAM',false),
  ('Negro','G1','banca','LATAM',false),
  ('Ámbar Wood','G1','banca','LATAM',false),
  ('Nogal Grafito','G1','banca','LATAM',false),
  ('Inox Satín','G1','banca','LATAM',false);