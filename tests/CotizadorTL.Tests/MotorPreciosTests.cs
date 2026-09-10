using CotizadorTL.Core;
using Xunit;

namespace CotizadorTL.Tests;

/// <summary>
/// Auditoría de corrección del motor de cálculo: cada prueba reproduce, AL CENTAVO,
/// uno de los 3 PDFs reales de Thin Laminates que entregó Dayanna.
/// </summary>
public class MotorPreciosTests
{
    private static LineaCotizacion Linea(decimal cant, decimal precio, bool aplicaDesc = true, decimal descLinea = 0)
        => new() { Cantidad = cant, PrecioUnitario = precio, AplicaDescuento = aplicaDesc, DescuentoPct = descLinea };

    // ---- COT.2490 REQUIEZ : 1 línea $1,234.87, descuento 30% ----
    [Fact]
    public void Cot2490_Requiez()
    {
        var c = new Cotizacion { DescuentoPct = 30m, IvaPct = 16m, AnticipoPct = 60m };
        c.Lineas.Add(Linea(1, 1234.87m));

        var t = MotorPrecios.Calcular(c);

        Assert.Equal(1234.87m, t.Subtotal);
        Assert.Equal(370.46m,  t.DescuentoMonto);
        Assert.Equal(864.41m,  t.SubtotalDesc);
        Assert.Equal(138.31m,  t.IvaMonto);
        Assert.Equal(1002.71m, t.GranTotal);
        Assert.Equal(601.63m,  t.Anticipo);
        Assert.Equal(401.09m,  t.Saldo);
    }

    // ---- COT.2499-A RATTAN : 2 líneas, descuento 20% ----
    [Fact]
    public void Cot2499A_Rattan()
    {
        var c = new Cotizacion { DescuentoPct = 20m };
        c.Lineas.Add(Linea(1, 1380.16m));
        c.Lineas.Add(Linea(1, 3643.62m));

        var t = MotorPrecios.Calcular(c);

        Assert.Equal(5023.78m, t.Subtotal);
        Assert.Equal(1004.76m, t.DescuentoMonto);
        Assert.Equal(4019.02m, t.SubtotalDesc);
        Assert.Equal(643.04m,  t.IvaMonto);
        Assert.Equal(4662.07m, t.GranTotal);
        Assert.Equal(2797.24m, t.Anticipo);
        Assert.Equal(1864.83m, t.Saldo);
    }

    // ---- COT.2505 SOLARE : 3 líneas, descuento 50% ----
    [Fact]
    public void Cot2505_Solare()
    {
        var c = new Cotizacion { DescuentoPct = 50m };
        c.Lineas.Add(Linea(1, 4471.72m));
        c.Lineas.Add(Linea(1, 11041.28m));
        c.Lineas.Add(Linea(1, 11041.28m));

        var t = MotorPrecios.Calcular(c);

        Assert.Equal(26554.28m, t.Subtotal);
        Assert.Equal(13277.14m, t.DescuentoMonto);
        Assert.Equal(13277.14m, t.SubtotalDesc);
        Assert.Equal(2124.34m,  t.IvaMonto);
        Assert.Equal(15401.48m, t.GranTotal);
        Assert.Equal(9240.89m,  t.Anticipo);
        Assert.Equal(6160.59m,  t.Saldo);
    }

    // ---- Servicios/Flete NO reciben descuento aunque haya % global ----
    [Fact]
    public void Servicios_NoRecibenDescuento()
    {
        var c = new Cotizacion { DescuentoPct = 50m };
        c.Lineas.Add(Linea(1, 1000m, aplicaDesc: true));   // producto: sí descuenta
        c.Lineas.Add(Linea(1, 1500m, aplicaDesc: false));  // flete: no descuenta

        var t = MotorPrecios.Calcular(c);

        Assert.Equal(2500m, t.Subtotal);
        // 1000*0.5 = 500 de descuento; el flete queda intacto
        Assert.Equal(500m,  t.DescuentoMonto);
        Assert.Equal(2000m, t.SubtotalDesc);
    }

    // ---- Descuento por renglón + global, multiplicativos ----
    [Fact]
    public void Descuento_Renglon_Y_Global_SeCombinan()
    {
        var c = new Cotizacion { DescuentoPct = 10m, IvaPct = 16m };
        c.Lineas.Add(Linea(2, 1000m, descLinea: 20m)); // 2000 bruto, -20% renglón, -10% global

        var t = MotorPrecios.Calcular(c);

        // 2000 * 0.8 * 0.9 = 1440
        Assert.Equal(2000m, t.Subtotal);
        Assert.Equal(560m,  t.DescuentoMonto);
        Assert.Equal(1440m, t.SubtotalDesc);
    }

    // ---- Gastos indirectos y de envío se suman ANTES del IVA ----
    [Fact]
    public void Gastos_SeSumanAntesDelIva()
    {
        var c = new Cotizacion { IvaPct = 16m, GastosIndirectos = 100m, GastosEnvio = 50m };
        c.Lineas.Add(Linea(1, 1000m));   // subtotal con descuento = 1000

        var t = MotorPrecios.Calcular(c);

        // base gravable = 1000 + 100 + 50 = 1150 ; IVA 16% = 184 ; gran total = 1334
        Assert.Equal(1000m, t.SubtotalDesc);
        Assert.Equal(100m,  t.GastosIndirectos);
        Assert.Equal(50m,   t.GastosEnvio);
        Assert.Equal(184m,  t.IvaMonto);
        Assert.Equal(1334m, t.GranTotal);
    }

    // ---- Producto en USD se convierte a MXN con el tipo de cambio ----
    [Fact]
    public void Producto_USD_SeConvierteAMxn()
    {
        var p = new Producto { CodigoSap = "C-GL7P", Moneda = "USD", TipoPrecio = "fijo",
                               Precios = new() { ["UNICO"] = 170.35m } };
        decimal precioMxn = MotorPrecios.PrecioUnitario(p, "UNICO", tipoCambio: 18m);
        Assert.Equal(170.35m * 18m, precioMxn);
    }

    // ---- Producto por m² (cubierta especial G4) calcula por área ----
    [Fact]
    public void Producto_M2_CalculaPorArea()
    {
        // CU-ESP G4 (UV) = 5520.6402 $/m² ; medida 110 x 60 cm = 0.66 m²
        var p = new Producto { CodigoSap = "CU-ESP", TipoPrecio = "m2", Moneda = "MXN",
                               Precios = new() { ["G4"] = 5520.6402m } };
        decimal precio = MotorPrecios.PrecioUnitario(p, "G4", 1m, largoCm: 110m, anchoCm: 60m);
        Assert.Equal(5520.6402m * 0.66m, precio);
    }

    // ---- COT 2457 real: 11% del distribuidor = 6% al cliente + 5% que se queda ----
    [Fact]
    public void Cot2457_SeParteElDescuentoDelDistribuidor()
    {
        // 110 lockers L-100-Q a 11 776,79 = 1 295 446,90 de subtotal público
        LineaCotizacion Locker() => new() { Cantidad = 110m, PrecioUnitario = 11776.79m, DescuentoPct = 11m };

        // lo que se FACTURA: público - 6% (al cliente) - 5% (que se queda)
        var factura = new Cotizacion
        {
            IvaPct = 0m, DescuentoClientePct = 6m, DescuentoPct = 5m,
            Lineas = new() { Locker() },
        };
        var tf = MotorPrecios.Calcular(factura);
        Assert.Equal(1295446.90m, tf.Subtotal);
        Assert.Equal(1217720.09m, tf.SubtotalDistribuidor);   // tras el 6%
        Assert.Equal(1156834.08m, tf.SubtotalDesc);           // tras el 5%

        // lo que paga el CLIENTE: solo el 6%
        var cliente = new Cotizacion
        {
            IvaPct = 0m,
            Lineas = new() { new LineaCotizacion { Cantidad = 110m, PrecioUnitario = 11776.79m, DescuentoPct = 6m } },
        };
        Assert.Equal(1217720.09m, MotorPrecios.Calcular(cliente).SubtotalDesc);

        // el margen del distribuidor es el 5% que no le pasó
        Assert.Equal(60886.01m, MotorPrecios.Calcular(cliente).SubtotalDesc - tf.SubtotalDesc);
    }

    // ---- El descuento al cliente REEMPLAZA al preestablecido, no se suma ----
    [Fact]
    public void DescuentoAlCliente_ReemplazaAlPreestablecido()
    {
        // el renglón trae 11% establecido; al poner 6% al cliente, manda el 6%
        var c = new Cotizacion
        {
            IvaPct = 0m, DescuentoClientePct = 6m,
            Lineas = new() { new LineaCotizacion { Cantidad = 1, PrecioUnitario = 100m, DescuentoPct = 11m } },
        };
        Assert.Equal(94m, MotorPrecios.Calcular(c).SubtotalDesc);
    }

    // ---- Sin partir (cliente en 0) todo se comporta como antes ----
    [Fact]
    public void SinPartir_MandaElPreestablecido()
    {
        var c = new Cotizacion
        {
            IvaPct = 0m, DescuentoPct = 5m,
            Lineas = new() { new LineaCotizacion { Cantidad = 1, PrecioUnitario = 100m, DescuentoPct = 20m } },
        };
        Assert.Equal(76m, MotorPrecios.Calcular(c).SubtotalDesc);   // 100 x 0.80 x 0.95
    }

    // ---- Servicios y flete no reciben descuento en ninguna cadena ----
    [Fact]
    public void SinDescuento_NoRecibeNada()
    {
        var c = new Cotizacion
        {
            IvaPct = 0m, DescuentoPct = 5m,
            Lineas = new() { new LineaCotizacion { Cantidad = 1, PrecioUnitario = 500m, DescuentoPct = 20m, AplicaDescuento = false } },
        };
        Assert.Equal(500m, MotorPrecios.Calcular(c).SubtotalDesc);
    }
}
