// Genera el Excel (.xlsx) para SAP con encabezado (logo TL + cliente/distribuidor/obra/fabricación)
// + tabla de columnas SAP, con celdas separadas y los colores de la marca Thin Laminates (usa ExcelJS).
(function () {
  const VERDE = "FF5A9E1F";       // verde TL (fondo de encabezados, texto blanco)
  const VERDEOSCURO = "FF3A6B14"; // verde oscuro (título)
  const VERDECLARO = "FFEAF6E0";  // verde muy claro (bandas de info)
  const GRIS = "FFBFBFBF";        // bordes
  const TXT = "FF222222";
  const bd = { style: "thin", color: { argb: GRIS } };
  const BORDER = { top: bd, bottom: bd, left: bd, right: bd };
  const solid = (argb) => ({ type: "pattern", pattern: "solid", fgColor: { argb } });

  const ENCAB = ["Clase de artículo/servicio", "Número de artículo", "Descripción del artículo", "Texto libre",
                 "Cantidad", "Precio por unidad", "Descuento 1", "Descuento 2", "Descuento 3", "Descuento 4"];

  window.cotizadorExcel = {
    generar: async function (info, lineas) {
      const ExcelJS = window.ExcelJS;
      if (!ExcelJS) throw new Error("ExcelJS no cargó.");
      info = info || {}; lineas = lineas || [];

      const wb = new ExcelJS.Workbook();
      const ws = wb.addWorksheet("Cotización", { views: [{ showGridLines: false }] });
      ws.columns = [{ width: 20 }, { width: 16 }, { width: 46 }, { width: 14 }, { width: 9 },
                    { width: 13 }, { width: 11 }, { width: 11 }, { width: 11 }, { width: 11 }];

      // ---- Helpers (capturan ws) ----
      const banda = (r, c1, c2, txt) => {
        ws.mergeCells(r, c1, r, c2);
        for (let c = c1; c <= c2; c++) { const x = ws.getCell(r, c); x.fill = solid(VERDE); x.border = BORDER; }
        const m = ws.getCell(r, c1);
        m.value = txt; m.font = { bold: true, size: 10, color: { argb: "FFFFFFFF" } };
        m.alignment = { horizontal: "left", vertical: "middle" };
      };
      const infoCell = (r, c1, c2, v) => {
        ws.mergeCells(r, c1, r, c2);
        for (let c = c1; c <= c2; c++) { const x = ws.getCell(r, c); x.fill = solid(VERDECLARO); x.border = BORDER; }
        const m = ws.getCell(r, c1);
        m.value = v; m.font = { size: 10, color: { argb: TXT } };
        m.alignment = { horizontal: "left", vertical: "middle" };
      };
      const th = (cell) => { cell.fill = solid(VERDE); cell.font = { bold: true, size: 10, color: { argb: "FFFFFFFF" } }; cell.alignment = { horizontal: "center", vertical: "middle", wrapText: true }; cell.border = BORDER; };
      const td = (cell, v) => { cell.value = v; cell.font = { size: 9, color: { argb: TXT } }; cell.alignment = { vertical: "middle", wrapText: true }; cell.border = BORDER; };
      const tdCen = (cell, v) => { cell.value = v; cell.font = { size: 9, color: { argb: TXT } }; cell.alignment = { horizontal: "center", vertical: "middle" }; cell.border = BORDER; };
      const tdNum = (cell, v) => { cell.value = v; cell.font = { size: 9, color: { argb: TXT } }; cell.alignment = { horizontal: "right", vertical: "middle" }; cell.border = BORDER; if (v !== "" && v != null) cell.numFmt = "#,##0.00"; };
      const totalCell = (cell, v) => { cell.fill = solid(VERDE); cell.font = { bold: true, size: 10, color: { argb: "FFFFFFFF" } }; cell.alignment = { horizontal: "right", vertical: "middle" }; cell.border = BORDER; if (v !== undefined) cell.value = v; };

      // ---- Logo TL (imagen real) ----
      ws.getRow(1).height = 24; ws.getRow(2).height = 26;
      try {
        const dataUrl = (window.cotizadorLogos && window.cotizadorLogos.tl) || "";
        if (dataUrl) {
          const raw = dataUrl.includes(",") ? dataUrl.split(",")[1] : dataUrl;
          const id = wb.addImage({ base64: raw, extension: "png" });
          ws.addImage(id, { tl: { col: 0, row: 0 }, ext: { width: 126, height: 56 } });
        }
      } catch (e) { /* si no hay logo, sigue sin imagen */ }

      // ---- Dirección de la empresa (derecha) ----
      const addr = (r, v) => {
        ws.mergeCells(r, 6, r, 10);
        const m = ws.getCell(r, 6);
        m.value = v; m.font = { size: 9, color: { argb: "FF444444" } };
        m.alignment = { horizontal: "right", vertical: "middle", wrapText: true };
      };
      addr(1, "Calle La Válvula #15, Parque Industrial Perisur, 45619");
      addr(2, "San Pedro Tlaquepaque, Jalisco · Tel. 33 3003 3200");

      // ---- Título ----
      ws.mergeCells(4, 1, 4, 10);
      const t = ws.getCell(4, 1);
      t.value = "COTIZACIÓN"; t.font = { bold: true, size: 16, color: { argb: VERDEOSCURO } };
      t.alignment = { horizontal: "center", vertical: "middle" }; ws.getRow(4).height = 24;

      // ---- Bloques Cliente / Distribuidor ----
      banda(6, 1, 5, "CLIENTE"); banda(6, 6, 10, "DISTRIBUIDOR");
      let r = 7;
      const fila2 = (la, va, lb, vb) => {
        infoCell(r, 1, 5, (la ? la + ": " : "") + (va || ""));
        infoCell(r, 6, 10, (lb ? lb + ": " : "") + (vb || ""));
        r++;
      };
      fila2("", info.cliente, "", info.distribuidor);
      fila2("Ciudad", info.ciudad, "Atención", info.atencion);
      fila2("Obra/Proyecto", info.proyecto, "Fabricación", info.fabricacion);
      fila2("Expediente", info.folio, "Fecha", info.fecha);
      fila2("Moneda", info.moneda, "", "");
      r++; // espaciador

      // ---- Encabezado de la tabla ----
      const head = r;
      ENCAB.forEach((h, i) => { const c = ws.getCell(head, i + 1); c.value = h; th(c); });
      ws.getRow(head).height = 28; r++;

      // ---- Filas ----
      let totalCant = 0;
      lineas.forEach((l) => {
        td(ws.getCell(r, 1), "Artículo");
        td(ws.getCell(r, 2), l.codigoSap || "");
        td(ws.getCell(r, 3), l.descripcion || "");
        td(ws.getCell(r, 4), l.textoLibre || "");
        tdCen(ws.getCell(r, 5), Number(l.cantidad || 0));
        tdNum(ws.getCell(r, 6), Number(l.precioUnitario || 0));
        tdNum(ws.getCell(r, 7), l.desc1 ? Number(l.desc1) : "");
        tdNum(ws.getCell(r, 8), l.desc2 ? Number(l.desc2) : "");
        td(ws.getCell(r, 9), "");
        td(ws.getCell(r, 10), "");
        totalCant += Number(l.cantidad || 0);
        r++;
      });

      // ---- Totales (cantidad) ----
      ws.mergeCells(r, 1, r, 4);
      const tot = ws.getCell(r, 1); tot.value = "TOTALES"; totalCell(tot);
      for (let c = 2; c <= 4; c++) totalCell(ws.getCell(r, c));
      const tc = ws.getCell(r, 5); totalCell(tc, totalCant); tc.numFmt = "#,##0.00";
      for (let c = 6; c <= 10; c++) totalCell(ws.getCell(r, c));
      r += 2;

      // ---- Resumen de importes (incluye el MONTO del descuento) ----
      const simbolo = info.moneda === "CRC" ? "₡" : "$";
      const fmt = '"' + simbolo + '"#,##0.00';
      const resumen = (label, valor, opts) => {
        opts = opts || {};
        ws.mergeCells(r, 6, r, 8);
        const lc = ws.getCell(r, 6);
        lc.value = label; lc.alignment = { horizontal: "right", vertical: "middle" };
        lc.font = { bold: !!opts.bold, size: 10, color: { argb: opts.fill ? "FFFFFFFF" : TXT } };
        ws.mergeCells(r, 9, r, 10);
        const vc = ws.getCell(r, 9);
        vc.value = Number(valor || 0); vc.numFmt = fmt;
        vc.alignment = { horizontal: "right", vertical: "middle" };
        vc.font = { bold: !!opts.bold, size: 10, color: { argb: opts.fill ? "FFFFFFFF" : (opts.rojo ? "FFB03030" : TXT) } };
        if (opts.fill) for (let c = 6; c <= 10; c++) ws.getCell(r, c).fill = solid(VERDE);
        for (let c = 6; c <= 10; c++) ws.getCell(r, c).border = BORDER;
        r++;
      };
      resumen("Subtotal público", info.subtotal);
      resumen("Descuento", info.descuentoMonto, { rojo: true });
      resumen("Subtotal con descuento", info.subtotalDesc);
      if (Number(info.gastosIndirectos) > 0) resumen("Gastos indirectos", info.gastosIndirectos);
      if (Number(info.gastosEnvio) > 0) resumen("Gastos de envío", info.gastosEnvio);
      resumen("IVA " + (info.ivaPct != null ? info.ivaPct : 0) + "%", info.ivaMonto);
      resumen("GRAN TOTAL", info.granTotal, { bold: true, fill: true });

      // ---- Descargar ----
      const buf = await wb.xlsx.writeBuffer();
      const blob = new Blob([buf], { type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" });
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url; a.download = "Cotizacion-" + (info.folio || "TL") + ".xlsx";
      document.body.appendChild(a); a.click(); a.remove();
      URL.revokeObjectURL(url);
    },

    // Exporta la LISTA de cotizaciones (Mis Proyectos) a una tabla de Excel.
    generarLista: async function () {
      const ExcelJS = window.ExcelJS;
      if (!ExcelJS) throw new Error("ExcelJS no cargó.");
      // Tolerante al interop: puede llegar como un solo arreglo o como filas sueltas.
      let filas = Array.from(arguments);
      if (filas.length === 1 && Array.isArray(filas[0])) filas = filas[0];

      const wb = new ExcelJS.Workbook();
      const ws = wb.addWorksheet("Cotizaciones", { views: [{ showGridLines: false }] });
      ws.columns = [{ width: 12 }, { width: 12 }, { width: 26 }, { width: 26 }, { width: 26 }, { width: 16 }, { width: 12 }, { width: 14 }];

      const th = (cell) => { cell.fill = solid(VERDE); cell.font = { bold: true, size: 10, color: { argb: "FFFFFFFF" } }; cell.alignment = { horizontal: "center", vertical: "middle", wrapText: true }; cell.border = BORDER; };
      const td = (cell, v, al) => { cell.value = v; cell.font = { size: 9, color: { argb: TXT } }; cell.alignment = { horizontal: al || "left", vertical: "middle", wrapText: true }; cell.border = BORDER; };

      ws.getRow(1).height = 24; ws.getRow(2).height = 26;
      try {
        const dataUrl = (window.cotizadorLogos && window.cotizadorLogos.tl) || "";
        if (dataUrl) {
          const raw = dataUrl.includes(",") ? dataUrl.split(",")[1] : dataUrl;
          const id = wb.addImage({ base64: raw, extension: "png" });
          ws.addImage(id, { tl: { col: 0, row: 0 }, ext: { width: 126, height: 56 } });
        }
      } catch (e) { /* sin logo */ }

      ws.mergeCells(4, 1, 4, 8);
      const t = ws.getCell(4, 1);
      t.value = "LISTADO DE COTIZACIONES"; t.font = { bold: true, size: 14, color: { argb: VERDEOSCURO } };
      t.alignment = { horizontal: "center", vertical: "middle" }; ws.getRow(4).height = 22;

      const H = ["Expediente", "Fecha", "Distribuidor", "Cliente", "Proyecto", "Gran total", "Estado", "Fabricación"];
      const head = 6;
      H.forEach((h, i) => { const c = ws.getCell(head, i + 1); c.value = h; th(c); });
      ws.getRow(head).height = 22;

      let r = head + 1;
      filas.forEach((f) => {
        td(ws.getCell(r, 1), f.folio || "");
        td(ws.getCell(r, 2), f.fecha || "", "center");
        td(ws.getCell(r, 3), f.distribuidor || "");
        td(ws.getCell(r, 4), f.cliente || "");
        td(ws.getCell(r, 5), f.proyecto || "");
        const g = ws.getCell(r, 6); td(g, Number(f.granTotal || 0), "right"); g.numFmt = '"$"#,##0.00';
        td(ws.getCell(r, 7), f.estado || "", "center");
        td(ws.getCell(r, 8), f.fabricacion || "", "center");
        r++;
      });

      const buf = await wb.xlsx.writeBuffer();
      const blob = new Blob([buf], { type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" });
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url; a.download = "Cotizaciones.xlsx";
      document.body.appendChild(a); a.click(); a.remove();
      URL.revokeObjectURL(url);
    },
  };
})();
