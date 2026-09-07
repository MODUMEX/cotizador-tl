using System.Globalization;
using System.Text.RegularExpressions;

namespace CotizadorTL.Core;

/// <summary>Peso estimado del pedido y las tarimas que ocupa, para poder cotizar el envío.</summary>
public sealed record PesoEnvio(
    decimal Kg,
    int Tarimas,
    /// <summary>Renglones de producto a los que no se les pudo estimar peso.</summary>
    int RenglonesSinPeso);

/// <summary>
/// Peso de lo que se cotiza, con las tablas de producción de Thin Laminates.
///
/// Los muebles de línea tienen peso propio (un locker SMART L-200 pesa 77 kg
/// completo, y una torre PRO Quad 48 kg). Lo que se fabrica a la medida se pesa
/// por su superficie: el laminado compacto pesa 1,5 kg por milímetro de espesor
/// en cada metro cuadrado, que es de donde salen los 18 kg del 12 mm y los
/// 13,5 kg del 9 mm de la tabla.
///
/// Es una ESTIMACIÓN para cotizar el flete: no lleva empaque, tarima ni herraje
/// suelto, así que el peso real de la carga sale un poco por encima.
/// </summary>
public static class Pesos
{
    /// <summary>Lo que se carga en una tarima y su medida, para calcular cuántas van.</summary>
    public const decimal TarimaKg = 850m;
    public const decimal TarimaMaxKg = 900m;
    public const decimal TarimaLargoM = 2.15m;
    public const decimal TarimaAnchoM = 1.60m;

    /// <summary>Kilos por metro cuadrado y por milímetro de espesor del laminado compacto.</summary>
    public const decimal KgPorMmM2 = 1.5m;

    /// <summary>El espesor de cubiertas y bancas de catálogo: 12,7 mm.</summary>
    private const decimal EspesorCubiertaMm = 12m;

    /// <summary>Locker SMART: el peso es del mueble completo, sin importar el diseño.</summary>
    private static readonly (string Prefijo, decimal Kg)[] SmartPorMueble =
    {
        ("L-100", 42m),   // 1 torre
        ("L-200", 77m),   // 2 torres
        ("L-300", 106m),  // 3 torres
    };

    /// <summary>Locker PRO: el peso es por torre y sí depende del diseño.</summary>
    private static readonly Dictionary<string, decimal> ProPorTorre = new(StringComparer.OrdinalIgnoreCase)
    {
        ["LODOBLEST"] = 44m,
        ["LOTRIPLEST"] = 46m,
        ["LOQUADST"] = 48m,
        ["LOEJECST"] = 52m,
    };

    /// <summary>Bancas rectangulares de catálogo, por longitud.</summary>
    private static readonly Dictionary<string, decimal> BancasPorPieza = new(StringComparer.OrdinalIgnoreCase)
    {
        ["BAR-76"] = 10.2m,
        ["BAR-90"] = 11m,
        ["BAR-114"] = 12.3m,
        ["BAR-152"] = 21.39m,
    };

    private static readonly Regex RectanguloEnNombre =
        new(@"(\d+(?:[.,]\d+)?)\s*[xX×]\s*(\d+(?:[.,]\d+)?)", RegexOptions.Compiled);

    private static readonly Regex DiametroEnNombre =
        new(@"(\d+(?:[.,]\d+)?)\s*cm", RegexOptions.Compiled);

    private static decimal Num(string s) =>
        decimal.Parse(s.Replace(',', '.'), CultureInfo.InvariantCulture);

    /// <summary>El espesor en mm que dice el grupo de precio ("9mm", "12mm"), si lo dice.</summary>
    private static decimal? EspesorDelGrupo(string? grupo)
    {
        if (string.IsNullOrWhiteSpace(grupo)) return null;
        var m = Regex.Match(grupo, @"^(\d+(?:[.,]\d+)?)\s*mm$", RegexOptions.IgnoreCase);
        return m.Success ? Num(m.Groups[1].Value) : null;
    }

    /// <summary>
    /// Superficie de una pieza, en m². Las que se hacen a la medida la sacan de lo
    /// que capturó el vendedor; las de catálogo, de su propio nombre ("60x120",
    /// "90 cm Ø"). Una cubierta redonda pesa por su círculo, no por el cuadrado
    /// del que se corta.
    /// </summary>
    public static decimal? AreaM2(Producto p, decimal? largoCm, decimal? anchoCm)
    {
        bool redonda = p.Nombre.Contains("redonda", StringComparison.OrdinalIgnoreCase);

        if (p.RequiereMedidas)
        {
            decimal a = largoCm ?? 0m;
            if (a <= 0) return null;
            if (redonda || p.MedidaUnica)
            {
                // la medida única de una redonda es el diámetro; la de una cuadrada, el lado
                return redonda
                    ? (decimal)(Math.PI * Math.Pow((double)a / 200.0, 2))
                    : a / 100m * a / 100m;
            }
            decimal b = anchoCm ?? 0m;
            return b > 0 ? a / 100m * b / 100m : null;
        }

        if (redonda)
        {
            var d = DiametroEnNombre.Match(p.Nombre);
            if (!d.Success) return null;
            return (decimal)(Math.PI * Math.Pow((double)Num(d.Groups[1].Value) / 200.0, 2));
        }

        var r = RectanguloEnNombre.Match(p.Nombre);
        if (!r.Success) return null;
        return Num(r.Groups[1].Value) / 100m * Num(r.Groups[2].Value) / 100m;
    }

    /// <summary>
    /// Peso de UNA pieza del producto, en kg, o null si no hay con qué estimarlo
    /// (accesorios sueltos, servicios, un especial sin medidas).
    /// </summary>
    public static decimal? KgDePieza(Producto p, decimal? largoCm = null, decimal? anchoCm = null, string? grupo = null)
    {
        if (p.FamiliaCodigo == "SERVICIOS" || p.EsExtra) return null;

        foreach (var (prefijo, kg) in SmartPorMueble)
            if (p.CodigoSap.StartsWith(prefijo, StringComparison.OrdinalIgnoreCase)) return kg;

        if (ProPorTorre.TryGetValue(p.CodigoSap, out var kgTorre)) return kgTorre;
        if (BancasPorPieza.TryGetValue(p.CodigoSap, out var kgBanca)) return kgBanca;

        var area = AreaM2(p, largoCm, anchoCm);
        if (area is null or <= 0) return null;

        decimal espesor = EspesorDelGrupo(grupo) ?? EspesorCubiertaMm;
        return area.Value * espesor * KgPorMmM2;
    }

    /// <summary>Cuántas tarimas ocupa un peso, a <see cref="TarimaKg"/> por tarima.</summary>
    public static int TarimasDe(decimal kg) =>
        kg <= 0 ? 0 : (int)Math.Ceiling(kg / TarimaKg);

    /// <summary>Junta el peso de todos los renglones y dice cuántas tarimas salen.</summary>
    public static PesoEnvio Total(IEnumerable<(Producto Producto, decimal Cantidad, decimal? LargoCm, decimal? AnchoCm, string? Grupo)> renglones)
    {
        decimal kg = 0m;
        int sinPeso = 0;
        foreach (var (p, cant, largo, ancho, grupo) in renglones)
        {
            var unidad = KgDePieza(p, largo, ancho, grupo);
            if (unidad is null)
            {
                if (p.FamiliaCodigo != "SERVICIOS" && !p.EsExtra) sinPeso++;
                continue;
            }
            kg += unidad.Value * cant;
        }
        return new PesoEnvio(Math.Round(kg, 1, MidpointRounding.AwayFromZero), TarimasDe(kg), sinPeso);
    }
}
