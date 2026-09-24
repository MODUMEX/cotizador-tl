namespace CotizadorTL.Core;

/// <summary>
/// Motor de cálculo de cotizaciones. Lógica pura y determinista (sin dependencias),
/// para poder auditarla con pruebas unitarias.
///
/// Regla de redondeo (validada contra los PDFs reales de Thin Laminates):
///   se trabaja en PRECISIÓN COMPLETA y se redondea SOLO para mostrar; el GRAN TOTAL
///   sale del subtotal-con-descuento sin redondear, por eso casa al centavo con los PDFs.
///
/// Interacción de descuentos. Son TRES, siempre en este orden y en cascada:
///
///   1) el preestablecido del distribuidor (el del renglón, por familia)
///   2) el que el distribuidor le da a su cliente
///   3) el extra
///
/// Cada uno se aplica sobre lo que dejó el anterior, nunca sobre el público:
///
///   distribuidor paga:  público × (1−dist) × (1−extra)
///   cliente paga:       público × (1−cliente)
///
/// El descuento del distribuidor es SU margen: no le llega al cliente, que
/// paga el público. Y lo que el distribuidor le regale a su cliente sale de
/// ese margen, no de lo que él le paga a Modumex.
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
    {
        decimal bruto = SubtotalLinea(l);
        if (!l.AplicaDescuento) return bruto;
        return bruto * (1 - l.DescuentoPct / 100m) * (1 - descuentoGlobalPct / 100m);
    }


    /// <summary>
    /// Lo que paga el CLIENTE: el precio público menos, si acaso, el descuento
    /// que su distribuidor decida darle. El del distribuidor no entra acá.
    /// </summary>
    public static decimal NetoCliente(LineaCotizacion l, decimal descuentoClientePct)
    {
        decimal bruto = SubtotalLinea(l);
        if (!l.AplicaDescuento) return bruto;
        return bruto * (1 - descuentoClientePct / 100m);
    }

    /// <summary>Calcula todos los totales de la cotización (en precisión completa, redondeando para mostrar).</summary>
    public static Totales Calcular(Cotizacion c)
    {
        decimal subtotal = 0m;     // público
        decimal subtotalDist = 0m; // tras el preestablecido del distribuidor
        decimal subtotalDesc = 0m; // tras el extra: lo que paga el DISTRIBUIDOR
        decimal subtotalCli = 0m;  // aparte: lo que paga el CLIENTE (sale del público)
        foreach (var l in c.Lineas)
        {
            subtotal     += SubtotalLinea(l);
            subtotalDist += NetoLinea(l, 0m);
            subtotalDesc += NetoLinea(l, c.DescuentoPct);
            subtotalCli  += NetoCliente(l, c.DescuentoClientePct);
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
            DescuentoCliente:      R(subtotal - subtotalCli),
            SubtotalCliente:       R(subtotalCli),
            DescuentoExtra:        R(subtotalDist - subtotalDesc));
    }
}
