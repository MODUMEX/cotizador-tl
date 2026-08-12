// Genera el PDF de la cotización replicando la plantilla de Thin Laminates.
// Usa jsPDF + autotable (embebidos en wwwroot/lib/jspdf, sin CDN).
(function () {
  const VERDE = [111, 157, 24];   // verde de marca TL (--tl-verde #6F9D18)
  const OSCURO = [43, 43, 43];
  const ROJO = [192, 57, 43];
  const GRIS = [120, 120, 120];

  const DIR = ["Calle La Válvula #15", "Parque Industrial Perisur, 45619",
               "San Pedro Tlaquepaque, Jalisco.", "Tel. 33 3003 3200"];
  // El texto "no incluye..." se arma según lo que SÍ se esté cobrando (instalación/flete).
  function bannerLineas(d) {
    const excl = [];
    if (!d.incluyeFlete) excl.push("FLETE");
    if (!d.incluyeInstalacion) excl.push("INSTALACIÓN");
    excl.push("VIÁTICOS");
    let lista = excl.length === 1 ? excl[0] : excl.slice(0, -1).join(", ") + " O " + excl[excl.length - 1];
    const entrega = (d.entrega && String(d.entrega).trim()) ? String(d.entrega).trim().toUpperCase() : "CONFIRMAR";
    return ["TIEMPO DE ENTREGA: " + entrega + ", SALVO CONFIRMACIÓN DE MATERIAL",
            "ESTA COTIZACIÓN NO INCLUYE COSTOS DE " + lista + ".",
            "DESCUENTO DISTRIBUIDOR APLICADO"];
  }
  const NOTA = "CARGOS POR ALMACENAJE $100 POR DÍA NATURAL, DESPUÉS DE 1 MES DE LA FECHA DE ENTREGA DEL PEDIDO. " +
               "CONDICIONES DE PAGO: 60% DE ANTICIPO, 40% DE SALDO EL CUAL DEBE SER LIQUIDADO ANTES DE LA ENTREGA DEL PRODUCTO.";
  const CONTACTO = "TEL: 33 3003 3200 EXT 201   CEL: 33 1044 0220 / 33 1446 2754 / 33 1942 1893";

  // Símbolo de moneda: Colones → ₡ (se dibuja gracias a la fuente Roboto embebida); Pesos/Dólares → $
  let SIMBOLO = "$";
  const money = (n) => SIMBOLO + Number(n || 0).toLocaleString("en-US", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  const txt = (v) => (v === null || v === undefined) ? "" : String(v);

  function construir(d) {
      SIMBOLO = (d.moneda === "CRC") ? "₡" : "$";
      const { jsPDF } = window.jspdf;
      const doc = new jsPDF({ unit: "pt", format: "letter" });
      // Fuente Roboto embebida (trae el símbolo ₡ y acentos que la fuente estándar no tiene)
      if (window.cotizadorFuentes) window.cotizadorFuentes.registrar(doc);
      const W = doc.internal.pageSize.getWidth();
      const M = 40;
      let y = 40;
      const L = window.cotizadorLogos || {};

      // ---------- Encabezado ----------
      // Logo THIN LAMINATES (izquierda)
      let tlH = 50, tlW = 118;
      if (L.tl) { tlH = tlW * L.tlH / L.tlW; doc.addImage(L.tl, "PNG", M, y, tlW, tlH); }

      // Logo del distribuidor (si tiene), a la par del de Thin Laminates
      if (d.logoDistribuidor) {
        try {
          const p = doc.getImageProperties(d.logoDistribuidor);
          const hMax = tlH, wMax = 120;
          let lw = p.width * hMax / p.height, lh = hMax;
          if (lw > wMax) { lw = wMax; lh = p.height * wMax / p.width; }
          const lx = M + tlW + 18, ly = y + (tlH - lh) / 2;
          doc.addImage(d.logoDistribuidor, p.fileType || "PNG", lx, ly, lw, lh);
        } catch (e) { }
      }
      // Logo GRUPO MODUMEX (derecha)
      let mxH = 44;
      if (L.modumex) { const w = 112; mxH = w * L.mxH / L.mxW; doc.addImage(L.modumex, "JPEG", W - M - w, y, w, mxH); }

      // ID COTIZACIÓN + folio grande verde (debajo del logo Modumex)
      const folioY = y + mxH + 16;
      doc.setFont("Roboto", "normal"); doc.setFontSize(7.5); doc.setTextColor(...GRIS);
      doc.text("ID COTIZACIÓN:", W - M, folioY, { align: "right" });
      doc.setFont("Roboto", "bold"); doc.setFontSize(24); doc.setTextColor(...VERDE);
      doc.text(txt(d.folio), W - M, folioY + 24, { align: "right" });

      // Dirección (izquierda, debajo del logo TL)
      doc.setFont("Roboto", "normal"); doc.setFontSize(7.5); doc.setTextColor(...GRIS);
      let yy = y + tlH + 12;
      DIR.forEach((l) => { doc.text(l, M, yy); yy += 10; });

      // Razón social / nombre comercial (centro)
      if (d.razonSocial) {
        doc.setFont("Roboto", "bold"); doc.setFontSize(10); doc.setTextColor(...OSCURO);
        doc.text(txt(d.razonSocial).toUpperCase(), W / 2, y + tlH + 4, { align: "center" });
      }

      // ---------- Datos (PROYECTO/CLIENTE...) ----------
      y = Math.max(yy, folioY + 30) + 6;
      const label = (k, v, x, yp) => {
        doc.setFont("Roboto", "bold"); doc.setFontSize(7.5); doc.setTextColor(...VERDE);
        doc.text(k, x, yp);
        doc.setFont("Roboto", "normal"); doc.setTextColor(...OSCURO);
        doc.text(txt(v), x + 58, yp);
      };
      label("PROYECTO:", d.proyecto, M, y);
      label("CLIENTE:", d.cliente, M, y + 12);
      label("ATENCIÓN A:", d.atencionA, M, y + 24);
      label("TELÉFONO:", d.telefono, M, y + 36);
      label("CIUDAD:", d.ciudad, M, y + 48);
      // derecha
      doc.setFont("Roboto", "bold"); doc.setFontSize(7.5); doc.setTextColor(...GRIS);
      doc.text("VIGENCIA DE COTIZACIÓN:", W - M, y, { align: "right" });
      doc.setFont("Roboto", "normal"); doc.setTextColor(...OSCURO);
      doc.text(txt(d.vigencia), W - M, y + 12, { align: "right" });
      doc.setFont("Roboto", "bold"); doc.setTextColor(...GRIS);
      doc.text("COTIZADO POR:", W - M, y + 28, { align: "right" });
      doc.setFont("Roboto", "normal"); doc.setTextColor(...OSCURO);
      doc.text(txt(d.cotizadoPor), W - M, y + 40, { align: "right" });

      // ---------- Barra de título ----------
      y = y + 64;
      doc.setFillColor(...OSCURO);
      doc.rect(M, y, W - 2 * M, 18, "F");
      doc.setFont("Roboto", "bold"); doc.setFontSize(9); doc.setTextColor(255, 255, 255);
      doc.text(txt(d.titulo || "COTIZACIÓN").toUpperCase(), W / 2, y + 12.5, { align: "center" });
      y += 24;

      // ---------- Tabla de renglones ----------
      const body = (d.lineas || []).map((l) => [
        txt(l.cantidad),
        txt(l.codigoSap),
        txt(l.descripcion),
        txt(l.color),
        money(l.precioUnitario),
        money(l.importe),
      ]);

      doc.autoTable({
        startY: y,
        margin: { left: M, right: M },
        head: [["CANTIDAD", "CÓDIGO SAP", "DESCRIPCIÓN", "COLOR", "PRECIO UNITARIO PÚBLICO", "PRECIO TOTAL PÚBLICO"]],
        body: body,
        styles: { font: "Roboto", fontSize: 7.5, cellPadding: 4, valign: "middle", textColor: OSCURO, lineColor: [210, 210, 210], lineWidth: 0.5 },
        headStyles: { fillColor: VERDE, textColor: [255, 255, 255], fontSize: 7.5, halign: "center" },
        columnStyles: {
          0: { halign: "center", cellWidth: 48 },
          1: { halign: "center", cellWidth: 60 },
          2: { cellWidth: "auto" },
          3: { halign: "center", cellWidth: 60 },
          4: { halign: "right", cellWidth: 78 },
          5: { halign: "right", cellWidth: 78 },
        },
      });

      const H = doc.internal.pageSize.getHeight();

      // Alto estimado del bloque que sigue a la tabla (totales + condiciones de pago).
      // Si no cabe en lo que resta de la página, saltamos a una nueva para no cortarlo.
      const _t = d.totales || {};
      let filasTot = 3; // subtotal + iva + gran total
      if (d.mostrarDescuento) filasTot += 2;
      if (Number(_t.gastosIndirectos) > 0) filasTot += 1;
      if (Number(_t.gastosEnvio) > 0) filasTot += 1;
      const altoBloque = Math.max(filasTot * 15 + 20, 90) + 20;

      let fy = doc.lastAutoTable.finalY + 14;
      if (fy + altoBloque > H - 40) { doc.addPage(); fy = 40; }
      const topBloque = fy;

      // Moneda (USD para LATAM)
      doc.setFont("Roboto", "bold"); doc.setFontSize(7.5); doc.setTextColor(...GRIS);
      doc.text("PRECIOS EN " + txt(d.moneda || "MXN") + (d.tipoPdf ? "  ·  " + d.tipoPdf : ""), M, fy - 2);

      // ---------- Totales (derecha) ----------
      const tot = d.totales || {};
      const ancho = 250, x0 = W - M - ancho;
      const rowT = (k, v, opts) => {
        opts = opts || {};
        doc.setFont("Roboto", opts.bold ? "bold" : "normal"); doc.setFontSize(8.5);
        doc.setTextColor(...(opts.color || OSCURO));
        doc.text(k, x0, fy);
        doc.text(money(v), W - M, fy, { align: "right" });
        fy += 15;
      };
      rowT("SUBTOTAL PÚBLICO", tot.subtotal);
      if (d.mostrarDescuento) {
        rowT("DESCUENTO DISTRIBUIDOR", tot.descuentoMonto, { color: ROJO });
        rowT("SUBTOTAL CON DESCUENTO", tot.subtotalDesc);
      }
      if (Number(tot.gastosIndirectos) > 0) rowT("GASTOS INDIRECTOS", tot.gastosIndirectos);
      if (Number(tot.gastosEnvio) > 0) rowT("GASTOS DE ENVÍO", tot.gastosEnvio);
      rowT("IVA " + txt(d.ivaPct) + "%", tot.ivaMonto, { color: ROJO });
      doc.setDrawColor(...OSCURO); doc.line(x0, fy - 10, W - M, fy - 10);
      rowT("GRAN TOTAL", tot.granTotal, { bold: true });

      // ---------- Condiciones de pago (izquierda) ----------
      const anticipoPct = Number(d.anticipoPct || 60);
      const cy0 = topBloque;
      doc.autoTable({
        startY: cy0,
        margin: { left: M },
        tableWidth: 200,
        head: [["CONDICIONES DE PAGO", ""]],
        body: [
          ["ANTICIPO " + anticipoPct + "%", money(tot.anticipo)],
          ["SALDO " + (100 - anticipoPct) + "%", money(tot.saldo)],
          ["GRAN TOTAL", money(tot.granTotal)],
        ],
        styles: { font: "Roboto", fontSize: 8, cellPadding: 3, lineColor: [200, 200, 200], lineWidth: 0.5 },
        headStyles: { fillColor: [235, 235, 235], textColor: OSCURO, halign: "center", fontStyle: "bold" },
        columnStyles: { 0: { fontStyle: "bold" }, 1: { halign: "right" } },
      });

      const cajaEstilo = { font: "Roboto", fontSize: 8, cellPadding: 3, lineColor: [200, 200, 200], lineWidth: 0.5 };
      const cajaHead = { fillColor: VERDE, textColor: [255, 255, 255], halign: "center", fontStyle: "bold" };

      // Las cajas (comentarios / datos bancarios) van a lo ancho DEBAJO de ambas columnas
      // (totales a la derecha y condiciones a la izquierda), para no traslaparse con el IVA / Gran total.
      let yCajas = Math.max(fy, doc.lastAutoTable.finalY) + 10;

      // ---------- Comentarios (izquierda) ----------
      if (d.comentarios && String(d.comentarios).trim()) {
        doc.autoTable({
          startY: yCajas,
          margin: { left: M },
          tableWidth: 320,
          head: [["COMENTARIOS O INSTRUCCIONES ESPECIALES"]],
          body: [[String(d.comentarios).trim()]],
          styles: cajaEstilo,
          headStyles: cajaHead,
        });
        yCajas = doc.lastAutoTable.finalY + 10;
      }

      // ---------- Datos bancarios (izquierda, con verde de marca) ----------
      if (d.datosBancarios && String(d.datosBancarios).trim()) {
        const filasBanco = String(d.datosBancarios).split(/\r?\n/).map((x) => x.trim()).filter((x) => x).map((x) => [x]);
        doc.autoTable({
          startY: yCajas,
          margin: { left: M },
          tableWidth: 320,
          head: [["DATOS BANCARIOS"]],
          body: filasBanco,
          styles: cajaEstilo,
          headStyles: cajaHead,
        });
        yCajas = doc.lastAutoTable.finalY + 10;
      }

      // ---------- Banner verde ----------
      const banner = bannerLineas(d);
      const bh = 12 * banner.length + 10;
      let by = Math.max(fy, doc.lastAutoTable.finalY) + 18;
      // El banner y el pie se dibujan con coordenadas manuales (no paginan solos):
      // si no caben en lo que resta de la hoja, saltamos a una página nueva.
      if (by + bh + 90 > H - 20) { doc.addPage(); by = 40; }
      doc.setFillColor(...VERDE);
      doc.rect(M, by, W - 2 * M, bh, "F");
      doc.setFont("Roboto", "bold"); doc.setFontSize(7.5); doc.setTextColor(255, 255, 255);
      let yb = by + 14;
      banner.forEach((l) => { doc.text(l, W / 2, yb, { align: "center" }); yb += 12; });
      by += bh + 16;

      // ---------- Pie ----------
      doc.setFont("Roboto", "normal"); doc.setFontSize(6.5); doc.setTextColor(...GRIS);
      doc.splitTextToSize(NOTA, W - 2 * M).forEach((l, i) => doc.text(l, W / 2, by + i * 9, { align: "center" }));
      by += 9 * 2 + 14;
      doc.setFont("Roboto", "bold"); doc.setFontSize(8); doc.setTextColor(...OSCURO);
      doc.text("THIN LAMINATES", W / 2, by, { align: "center" });
      doc.setFont("Roboto", "normal"); doc.setFontSize(7); doc.setTextColor(...GRIS);
      doc.text(CONTACTO, W / 2, by + 11, { align: "center" });
      doc.setTextColor(...VERDE); doc.setFont("Roboto", "bold");
      doc.text("WWW.MODUMEX.COM", W / 2, by + 22, { align: "center" });

      return doc;
  }

  window.cotizadorPdf = {
    construir: construir,
    generar: function (d) { construir(d).save("Cotizacion-" + txt(d.folio) + (d.tipoPdf ? "-" + d.tipoPdf : "") + ".pdf"); },
    // Solo para pruebas: renderiza el PDF dentro de un iframe.
    previa: function (d, iframeId) {
      document.getElementById(iframeId).src = construir(d).output("datauristring");
    },
  };
})();
