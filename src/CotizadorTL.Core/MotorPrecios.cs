namespace CotizadorTL.Core;

/// <summary>
/// Motor de cálculo de cotizaciones. Lógica pura y determinista (sin dependencias),
/// para poder auditarla con pruebas unitarias.
///
/// Regla de redondeo (validada contra los PDFs reales de Thin Laminates):
///   se trabaja en PRECISIÓN COMPLETA y se redondea SOLO para mostrar; el GRAN TOTAL
///   sale del subtotal-con-descuento sin redondear, por eso casa al centavo con los PDFs.
///
/// Interacción de descuentos. El descuento del distribuidor se PARTE en dos:
/// lo que le pasa a su cliente y lo que se queda él. Los dos van en cascada.
///
///   público → (1−al cliente) → (1−adicional) = lo que se factura
///   público → (1−al cliente)                 = lo que paga el cliente
///
/// Ejemplo real: al 11 % del distribuidor se lo nombra 6 % que le pasa al
/// cliente + 5 % que se queda, pero se aplican EN CASCADA: 10,7 % efectivo,
/// no 11 %. Sobre 1 295 446,90 factura 1 156 834,08 y le cobra al cliente
/// 1 217 720,09; la diferencia, 60 886, es su margen.
///
/// Si NO se parte (descuento al cliente en 0), manda el preestablecido del
/// renglón y todo se comporta como antes.
///
///   · Líneas con AplicaDescuento=false (Servicios/Flete) NO reciben ningún descuento.
///   · A las demás se les aplica el descuento de renglón y luego el global, de forma
///     multiplicativa:  neto = bruto * (1 - renglon%) * (1 - global%).
/// </summary>
public static class MotorPrecios
{
    public static decimal R(decimal v) => Math.Round(v, 2, MidpointRounding.AwayFromZero);

    /// <summary>Precio unitario del producto para un grupo, en MXN.
    /// Para productos "m2" multiplica por el área (largo*ancho en m²).</summary>
    public static decimal PrecioUnitario(Producto p, string grupo, decimal tipoCambio,
                                         decimal? largoCm = null, decimal? anchoCm = null)
    {
        if (!p.Precios.TryGetValue(grupo, out var precio))
        {
            // fallback: si solo hay un precio, úsalo (UNICO)
            if (p.Precios.Count == 1) precio = p.Precios.Values.First();
            else throw new ArgumentException($"El producto {p.CodigoSap} no tiene precio para el grupo '{grupo}'.");
        }

        if (p.TipoPrecio == "m2")
        {
            decimal m2 = (largoCm ?? 0) / 100m * (anchoCm ?? 0) / 100m;
            precio *= m2;
        }

        if (p.Moneda == "USD") precio *= tipoCambio;   // convertir a MXN
        return precio;
    }


    /// <summary>Subtotal bruto de un renglón (cantidad * precio unitario), sin descuento.</summary>
    public static decimal SubtotalLinea(LineaCotizacion l) => l.Cantidad * l.PrecioUnitario;

    /// <summary>Neto de un renglón aplicando descuento de renglón + global (si corresponde).</summary>
    public static decimal NetoLinea(LineaCotizacion l, decimal descuentoGlobalPct)
        => NetoLinea(l, descuentoGlobalPct, 0m);

    /// <summary>
    /// El primer descuento de la cascada. Si se puso uno al cliente, ese manda y
    /// REEMPLAZA al preestablecido del renglón: los dos son la misma plata,
    /// partida en la porción que se le pasa al cliente y la que se queda el
    /// distribuidor. Aplicarlos juntos la contaría dos veces.
    /// </summary>
    public static decimal PrimerDescuento(LineaCotizacion l, decimal descuentoClientePct)
        => descuentoClientePct > 0m ? descuentoClientePct : l.DescuentoPct;

    /// <summary>
    /// Neto de un renglón con la cascada completa: descuento del distribuidor
    /// (el del renglón), después el del cliente y por último el adicional.
    ///
    /// El ORDEN no cambia el total —multiplicar factores es conmutativo— pero sí
    /// cambia los subtotales intermedios que se muestran en el desglose.
    /// </summary>
    public static decimal NetoLinea(LineaCotizacion l, decimal descuentoGlobalPct, decimal descuentoClientePct)
    {
        decimal bruto = SubtotalLinea(l);
        if (!l.AplicaDescuento) return bruto;
        decimal factor = (1 - PrimerDescuento(l, descuentoClientePct) / 100m)
                       * (1 - descuentoGlobalPct / 100m);
        return bruto * factor;
    }

    /// <summary>Calcula todos los totales de la cotización (en precisión completa, redondeando para mostrar).</summary>
    public static Totales Calcular(Cotizacion c)
    {
        decimal subtotal = 0m;     // público (antes de descuento)
        decimal subtotalDist = 0m; // con el preestablecido del distribuidor
        decimal subtotalDesc = 0m; // + el adicional: el neto de verdad
        foreach (var l in c.Lineas)
        {
            subtotal     += SubtotalLinea(l);
            subtotalDist += NetoLinea(l, 0m, c.DescuentoClientePct);
            subtotalDesc += NetoLinea(l, c.DescuentoPct, c.DescuentoClientePct);
        }
        decimal descuentoMonto = subtotal - subtotalDesc;
        // Gastos indirectos y de envío se suman ANTES del IVA (no reciben descuento).
        decimal baseGravable = subtotalDesc + c.GastosIndirectos + c.GastosEnvio;
        decimal ivaMonto  = baseGravable * (c.IvaPct / 100m);
        decimal granTotal = baseGravable + ivaMonto;
        decimal anticipo  = granTotal * (c.AnticipoPct / 100m);
        decimal saldo     = granTotal - anticipo;

        return new Totales(
            Subtotal:       R(subtotal),
            DescuentoMonto: R(descuentoMonto),
            SubtotalDesc:   R(subtotalDesc),
            IvaMonto:       R(ivaMonto),
            GranTotal:      R(granTotal),
            Anticipo:       R(anticipo),
            Saldo:          R(saldo),
            GastosIndirectos: R(c.GastosIndirectos),
            GastosEnvio:      R(c.GastosEnvio),
            DescuentoDistribuidor: R(subtotal - subtotalDist),
            SubtotalDistribuidor:  R(subtotalDist),
            DescuentoExtra:        R(subtotalDist - subtotalDesc));
    }
}
