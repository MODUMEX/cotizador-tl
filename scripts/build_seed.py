# -*- coding: utf-8 -*-
"""
Construye supabase/03_seed.sql (catálogo REAL del configurador) a partir de:
  - catalogo/raw_dump.json       (lista de precios -> cubiertas de línea + precios)
  - catalogo/conceptos_dump.json (Catálogo de Conceptos -> descripciones SAP + colores)
Modelo: 3 familias (Cubiertas, Lockers, Bancas) + Servicios. Códigos SAP reales.
Toda la lista en MXN. Uso: python scripts/build_seed.py
"""
import json, os
from collections import Counter

HERE = os.path.dirname(__file__)
RAW  = json.load(open(os.path.join(HERE, "..", "catalogo", "raw_dump.json"), encoding="utf-8"))
CON  = json.load(open(os.path.join(HERE, "..", "catalogo", "conceptos_dump.json"), encoding="utf-8"))
OUT_SQL = os.path.join(HERE, "..", "supabase", "03_seed.sql")

def num(v):
    try: return round(float(v), 4)
    except (TypeError, ValueError): return None
def sqls(s):
    return "null" if s is None else "'" + str(s).replace("'", "''") + "'"

# Descripciones reales por código SAP (hoja "THIN LAMINATES" del Catálogo de Conceptos)
DESC = {}
for row in CON.get("THIN LAMINATES", []):
    if len(row) >= 4 and row[2]:
        DESC[row[2].strip()] = row[3].strip()

# ---------------------------------------------------------------------
FAMILIAS = [
    ("CUBIERTAS", "Cubiertas", True, 10),
    ("LOCKERS",   "Lockers",   True, 20),
    ("BANCAS",    "Bancas",    True, 30),
    ("SERVICIOS", "Servicios (instalación/flete)", False, 40),
]
PRODUCTOS = []
def add(codigo, familia, nombre, precios, descripcion="", tipo="fijo", unidad="pieza",
        espesor=None, medidas=False, desc_aplica=True, es_extra=False, orden=0, medida_unica=False):
    PRODUCTOS.append(dict(codigo_sap=codigo, familia=familia, nombre=nombre, descripcion=descripcion,
        tipo_precio=tipo, unidad=unidad, moneda="MXN", espesor=espesor, requiere_medidas=medidas,
        aplica_descuento=desc_aplica, es_extra=es_extra, orden=orden, medida_unica=medida_unica,
        precios={g: round(p,4) for g,p in precios.items() if p is not None}))

# ===================== CUBIERTAS =====================
cub = RAW["CUBIERTAS"]
R = {"G1":num(cub[4][2]),"G2":num(cub[7][2]),"G3":num(cub[8][2]),"G4":num(cub[9][2]),
     "ESP_INT":num(cub[6][2]),"ESP_EXT":num(cub[12][2])}
DESC_INT = "SUMINISTRO DE CUBIERTA {forma} DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: {medida} GARANTÍA 25 AÑOS EN LAMINADO COMPACTO (INTERIOR). CANTO __"
add("CR-ESP","CUBIERTAS","Cubierta redonda medida especial",R,DESC_INT.format(forma="REDONDA",medida="__ CM DIÁMETRO"),tipo="m2",unidad="m2",medidas=True,medida_unica=True,orden=1)
add("CC-ESP","CUBIERTAS","Cubierta cuadrada medida especial",R,DESC_INT.format(forma="CUADRADA",medida="__ CM"),tipo="m2",unidad="m2",medidas=True,medida_unica=True,orden=2)
add("CT-ESP","CUBIERTAS","Cubierta rectangular medida especial",R,DESC_INT.format(forma="RECTANGULAR",medida="__ CM X __ CM"),tipo="m2",unidad="m2",medidas=True,orden=2)
add("CU-ESP","CUBIERTAS","Cubierta forma irregular medida especial",R,DESC_INT.format(forma="FORMA IRREGULAR",medida="__ CM X __ CM"),tipo="m2",unidad="m2",medidas=True,orden=3)
# Cubiertas de línea (código fijo CR-/CC-/CT-, precio por grupo)
orden=10
for r in cub:
    if len(r)<11: continue
    codes=[str(r[0] or "").strip(), str(r[1] or "").strip()]
    forma=str(r[2] or ""); ancho,largo=num(r[3]),num(r[4])
    g1,g2,g3,g4=num(r[7]),num(r[8]),num(r[9]),num(r[10])
    cr=next((c for c in codes if c.startswith("CR-")),None)
    cc=next((c for c in codes if c.startswith("CC-")),None)
    ct=next((c for c in codes if c.startswith("CT-")),None)
    if not (cr or cc or ct) and "edonda y cuadrada" in forma and ancho==0.5 and g1: cr,cc="CR-50","CC-5050"
    if not (cr or cc or ct) or g1 is None or ancho is None or largo is None: continue
    pr={"G1":g1,"G2":g2,"G3":g3,"G4":g4}; aa,ll=int(round(ancho*100)),int(round(largo*100))
    if cr: add(cr,"CUBIERTAS",f"Cubierta redonda {aa} cm Ø",pr,DESC_INT.format(forma="REDONDA",medida=f"{aa} CM DIÁMETRO"),espesor="12 mm",orden=orden); orden+=1
    if cc: add(cc,"CUBIERTAS",f"Cubierta cuadrada {aa}x{ll}",pr,DESC_INT.format(forma="CUADRADA",medida=f"{aa} CM X {ll} CM"),espesor="12 mm",orden=orden); orden+=1
    if ct: add(ct,"CUBIERTAS",f"Cubierta rectangular {aa}x{ll}",pr,DESC_INT.format(forma="RECTANGULAR",medida=f"{aa} CM X {ll} CM"),espesor="12 mm",orden=orden); orden+=1

# ===================== LOCKERS =====================
# SMART de línea (precio por configuración 100/200/300; código real L-{100|200|300}-{D|T|Q|E})
SMART_PRECIO={"100":11776.7885,"200":22375.8982,"300":31796.1513}
modelos=[("D","Doble"),("T","Triple"),("Q","Quad"),("E","Ejecutivo")]
o=1
for cfg in ("100","200","300"):
    for ml,mn in modelos:
        code=f"L-{cfg}-{ml}"
        add(code,"LOCKERS",f"Locker SMART {mn} L-{cfg}",{"UNICO":SMART_PRECIO[cfg]},DESC.get(code,""),espesor="Aluminio/L.C.",orden=o); o+=1
# PRO de línea (precio por torre)
for code,mn in [("LODOBLEST","Doble"),("LOTRIPLEST","Triple"),("LOQUADST","Quad"),("LOEJECST","Ejecutivo")]:
    add(code,"LOCKERS",f"Locker PRO {mn} (por torre)",{"UNICO":13210.32},DESC.get(code,""),espesor="L.C.",orden=o); o+=1
# Vestidor / PRO especial
add("LOESPECIAL","LOCKERS","Vestidor / Locker PRO de línea",{"UNICO":18287.94},DESC.get("LOESPECIAL",""),espesor="L.C.",orden=o); o+=1
add("LO-PRO-ESP","LOCKERS","Locker PRO especial (por m²)",{"3mm":2796.7580,"12mm":4170.9866},"LOCKER PRO ESPECIAL FABRICADO EN LAMINADO COMPACTO. MEDIDA FINAL: __",tipo="m2",unidad="m2",medidas=True,orden=o); o+=1
add("LO-SMART-ESP","LOCKERS","Locker SMART especial (por m²)",{"3mm":2447.1633,"6mm":2885.0999,"9mm":3542.9793,"12mm":3892.9209},"LOCKER SMART ESPECIAL FABRICADO EN LAMINADO COMPACTO. MEDIDA FINAL: __",tipo="m2",unidad="m2",medidas=True,orden=o); o+=1
# Extras de locker (se SUMAN al precio del locker)
EXTRAS=[
 ("G-LOCKER","Grabado láser por puerta (máx 30x30cm)",120),
 ("RP-LOCKER","Ranura o perforación SMA por puerta",50),
 ("C-HEFELE","Cerradura Hafele 22mm (llave)",265.78),
 ("C-RIVEN","Cerradura horizontal Riven 4 dígitos",235),
 ("KPC","Kit portacandado",78.38),
 ("FE4161","Pata niveladora aluminio 10cm",60),
 ("GANCHO","Gancho para colgar",97.5),
 ("TO0021","Tubo para colgar",209),
 ("ZOCLO-127","Zoclo lateral 12.7mm",170),
 ("HERRAJES","Herrajes por puerta",150),
 ("KJL81","Kit jaladera aluminio",25),
 ("KEB","Kit escuadra + 2 tornillos T4",50),
 ("C-GL7P","Cerradura electrónica Gatner GL7P (teclado)",170.35),
 ("G-921727","Cerradura electrónica Gatner GAT ECO 7100",141.4),
]
for i,(c,n,p) in enumerate(EXTRAS, start=200):
    add(c,"LOCKERS",n,{"UNICO":p},DESC.get(c,n),es_extra=True,orden=i)
# Las cerraduras electrónicas Gatner se cotizan en USD (el resto del catálogo está en MXN).
for _pr in PRODUCTOS:
    if _pr["codigo_sap"] in ("C-GL7P","G-921727"): _pr["moneda"]="USD"
# Fillers (PRO / SMART por rango de ancho)
FILLERS=[("FILLER-08-10","Filler 8-10 cm",531.3840,464.9610),("FILLER-11-15","Filler 11-15 cm",797.0760,697.4415),
 ("FILLER-16-20","Filler 16-20 cm",1062.7680,929.9220),("FILLER-21-25","Filler 21-25 cm",1328.4601,1162.4026),
 ("FILLER-26-30","Filler 26-30 cm",1594.1521,1394.8831),("FILLER-31-37","Filler 31-37 cm",1966.1209,1720.3558)]
for i,(c,n,pro,sm) in enumerate(FILLERS, start=240):
    add(c,"LOCKERS",n,{"PRO":pro,"SMART":sm},es_extra=True,orden=i)

# ===================== BANCAS =====================
RATE_G1=R["G1"]
for c,med in [("BAR-76","76"),("BAR-90","90"),("BAR-114","114"),("BAR-152","152")]:
    pr=num(RAW["PALETAS DE PUPITRE Y BANCAS"][{"BAR-76":5,"BAR-90":6,"BAR-114":7,"BAR-152":8}[c]][4])
    add(c,"BANCAS",f"Banca rectangular {med} cm",{"G1":pr},DESC.get(c,""),espesor="12 mm",orden=int(med))
add("BAR-ESP","BANCAS","Banca especial (por m²)",{"G1":RATE_G1},"SUMINISTRO DE BANCA RECTANGULAR DE LAMINADO COMPACTO DE 12.7 MM DE ESPESOR MARCA THIN LAMINATES. MEDIDA FINAL: __. GARANTÍA 25 AÑOS EN LAMINADO COMPACTO",tipo="m2",unidad="m2",medidas=True,orden=200)

# ===================== SERVICIOS =====================
SERV=[("INST-CUB","Instalación por cubierta",250),("INST-FILLER","Instalación por filler",450),
 ("INST-L100","Instalación locker SMART L-100",450),("INST-L200","Instalación locker SMART L-200",800),
 ("INST-L300","Instalación locker SMART L-300",1100),("INST-BANCA","Instalación por banca",300),
 ("INST-TORRE-PRO","Instalación por torre PRO",450),("FLETE-LOCAL","Flete local menor a 60 km",1500)]
for i,(c,n,p) in enumerate(SERV, start=1):
    add(c,"SERVICIOS",n,{"UNICO":p},desc_aplica=False,orden=i)

# ===================== COLORES =====================
G1=["Negro","Gris Metalizado","Blanco","Alúmina","Grafito Nocturno","Walnut Heights","Skyline Walnut"]
COLORES=[]  # (nombre, grupo, ambito, region, tiempo_especial)  -- todos MXN; los LATAM se siembran aparte
for c in G1: COLORES.append((c,"G1","cubierta_int","MXN",False))
COLORES.append(("Calcutta Marble","G2","cubierta_int","MXN",False))
COLORES.append(("White Marble","G3","cubierta_int","MXN",False))
for c in ["Roble Lineal","Italian Walnut","Atenas","Tiziano","Industrial Concrete"]: COLORES.append((c,"G4","cubierta_ext","MXN",False))
for c in ["Dark Steel","Vanilla"]: COLORES.append((c,"G4","cubierta_ext","MXN",True))
for c in G1: COLORES.append((c,"G1","locker_frente","MXN",False))
# Interior lockers México: Alúmina estándar + Negro/Blanco como extra (+10%)
for c in ["Alúmina","Negro","Blanco"]: COLORES.append((c,"INT","locker_interior","MXN",False))
for c in G1: COLORES.append((c,"G1","banca","MXN",False))

# ---- Colores LATAM (aplican a regiones LATAM y Costa Rica) ----
LAT_INT = ["Blanco","Gris","Grafito Nocturno","Negro","Ámbar Wood","Nogal Grafito","Inox Satín"]  # G1
LAT_EXT = ["Roble Lineal","Italian Walnut","Atenas","Tiziano","Industrial Concrete"]               # G4
LAT_LOCKER = ["Negro","Inox Satín","Blanco","Gris","Grafito Nocturno","Ámbar Wood","Nogal Grafito"]  # nombres CR
for c in LAT_INT: COLORES.append((c,"G1","cubierta_int","LATAM",False))
for c in LAT_EXT: COLORES.append((c,"G4","cubierta_ext","LATAM",False))
for c in ["Dark Steel","Vanilla"]: COLORES.append((c,"G4","cubierta_ext","LATAM",True))
for c in LAT_LOCKER: COLORES.append((c,"G1","locker_frente","LATAM",False))
# Interior lockers Costa Rica/LATAM: Gris (estándar) + Negro + Blanco (sin recargo)
for c in ["Gris","Negro","Blanco"]: COLORES.append((c,"INT","locker_interior","LATAM",False))
for c in LAT_INT: COLORES.append((c,"G1","banca","LATAM",False))

# ===================== EMITIR SQL =====================
L=["-- =====================================================================",
   "-- Cotizador Thin Laminates — 03 · Seed del catálogo (configurador real)",
   "-- Generado por scripts/build_seed.py — NO editar a mano.",
   "-- Requiere 09_configurador.sql (columna es_extra + tabla color) ya aplicado.",
   "-- =====================================================================","",
   "truncate table public.producto_precio, public.producto restart identity cascade;",
   "delete from public.familia;",
   "delete from public.color;",""]
L.append("insert into public.familia (codigo,nombre,aplica_descuento,orden) values")
L.append(",\n".join(f"  ({sqls(c)},{sqls(n)},{str(a).lower()},{o})" for c,n,a,o in FAMILIAS)+
         "\non conflict (codigo) do update set nombre=excluded.nombre, aplica_descuento=excluded.aplica_descuento, orden=excluded.orden;")
L.append("")
L.append("do $$\ndeclare pid bigint;\nbegin")
for p in PRODUCTOS:
    L.append("  insert into public.producto (codigo_sap,familia_codigo,nombre,descripcion,tipo_precio,unidad,moneda,espesor,requiere_medidas,medida_unica,aplica_descuento,es_extra,orden) values "
        f"({sqls(p['codigo_sap'])},{sqls(p['familia'])},{sqls(p['nombre'])},{sqls(p['descripcion'])},{sqls(p['tipo_precio'])},{sqls(p['unidad'])},{sqls(p['moneda'])},{sqls(p['espesor'])},"
        f"{str(p['requiere_medidas']).lower()},{str(p['medida_unica']).lower()},{str(p['aplica_descuento']).lower()},{str(p['es_extra']).lower()},{p['orden']}) returning producto_id into pid;")
    for g,pr in p["precios"].items():
        L.append(f"  insert into public.producto_precio (producto_id,grupo,precio) values (pid,{sqls(g)},{pr});")
L.append("end $$;")
L.append("")
L.append("insert into public.color (nombre,grupo,ambito,region,tiempo_especial) values")
L.append(",\n".join(f"  ({sqls(n)},{sqls(g)},{sqls(a)},{sqls(reg)},{str(t).lower()})" for n,g,a,reg,t in COLORES)+";")
open(OUT_SQL,"w",encoding="utf-8").write("\n".join(L))

byf=Counter(p["familia"] for p in PRODUCTOS); extras=sum(1 for p in PRODUCTOS if p["es_extra"])
print("Tarifas m² cubiertas:",R)
for c,_,_,_ in FAMILIAS: print(f"  {c:10} {byf.get(c,0)}")
print("TOTAL productos:",len(PRODUCTOS),"| extras:",extras,"| colores:",len(COLORES),"| desc SAP:",len(DESC))
print("OK ->",os.path.abspath(OUT_SQL))
