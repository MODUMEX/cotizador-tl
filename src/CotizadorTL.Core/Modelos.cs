namespace CotizadorTL.Core;

/// <summary>Rol del usuario. Define visibilidad y permisos (coincide con Supabase/RLS).</summary>
public enum Rol { Distribuidor, Administrador, SuperAdmin }

/// <summary>Familia de producto del catálogo Thin Laminates.</summary>
public sealed class Familia
{
    public string Codigo { get; set; } = "";
    public string Nombre { get; set; } = "";
    /// <summary>false = Servicios/Flete: nunca se les aplica descuento.</summary>
    public bool AplicaDescuento { get; set; } = true;
    public int Orden { get; set; }
}

/// <summary>Producto vendible (incluye accesorios/extras: cada renglón del PDF es un producto).</summary>
public sealed class Producto
{
    public long ProductoId { get; set; }
    public string CodigoSap { get; set; } = "";
    public string FamiliaCodigo { get; set; } = "";
    public string Nombre { get; set; } = "";
    public string Descripcion { get; set; } = "";
    /// <summary>"fijo" = precio por pieza; "m2" = precio por m² (requiere medidas).</summary>
    public string TipoPrecio { get; set; } = "fijo";
    public string Unidad { get; set; } = "pieza";
    public string Moneda { get; set; } = "MXN";
    public string? Espesor { get; set; }
    public bool RequiereMedidas { get; set; }
    public bool MedidaUnica { get; set; }
    public bool AplicaDescuento { get; set; } = true;
    public bool EsExtra { get; set; }
    public bool Activo { get; set; } = true;
    public int Orden { get; set; }
    /// <summary>Precio por grupo/tier (G1..G4, PRO, SMART, MT/SM/BR, UNICO, etc.).</summary>
    public Dictionary<string, decimal> Precios { get; set; } = new();
}

/// <summary>Renglón de una cotización (faithful al layout SAP del Excel y a la tabla del PDF).</summary>
public sealed class LineaCotizacion
{
    public int Orden { get; set; }
    public long? ProductoId { get; set; }
    public decimal Cantidad { get; set; } = 1;
    public string CodigoSap { get; set; } = "";
    public string Descripcion { get; set; } = "";
    public string? Color { get; set; }
    public string? TextoLibre { get; set; }
    public decimal? LargoCm { get; set; }
    public decimal? AnchoCm { get; set; }
    /// <summary>Precio unitario YA en MXN (convertido si el producto estaba en USD).</summary>
    public decimal PrecioUnitario { get; set; }
    /// <summary>Descuento por renglón (Descuento 1 del layout SAP). 0–100.</summary>
    public decimal DescuentoPct { get; set; }
    /// <summary>Si false (Servicios/Flete), no recibe descuento global ni de renglón.</summary>
    public bool AplicaDescuento { get; set; } = true;
}

/// <summary>Encabezado + parámetros de una cotización.</summary>
public sealed class Cotizacion
{
    public string Folio { get; set; } = "";
    public DateTime Fecha { get; set; }
    public DateTime? Vigencia { get; set; }
    public string? RazonSocial { get; set; }
    public string? Proyecto { get; set; }
    public string? Titulo { get; set; }
    public string? Cliente { get; set; }
    public string? AtencionA { get; set; }
    public string? Telefono { get; set; }
    public string? Ciudad { get; set; }
    public string? CotizadoPor { get; set; }
    public string? Comentarios { get; set; }
    public long? DistribuidorId { get; set; }
    public string Moneda { get; set; } = "MXN";
    /// <summary>MXN por 1 USD (para convertir productos en USD a MXN).</summary>
    public decimal TipoCambio { get; set; } = 1m;
    /// <summary>DESCUENTO DISTRIBUIDOR % (global).</summary>
    public decimal DescuentoPct { get; set; }
    /// <summary>Gastos indirectos: monto que se suma ANTES del IVA (no recibe descuento).</summary>
    public decimal GastosIndirectos { get; set; }
    /// <summary>Gastos de envío: monto que se suma ANTES del IVA (no recibe descuento).</summary>
    public decimal GastosEnvio { get; set; }
    public decimal IvaPct { get; set; } = 16m;
    /// <summary>IVA % que se le cobra al CLIENTE. Solo se usa en el PDF de cliente;
    /// el del distribuidor sigue con <see cref="IvaPct"/>, que sale de la zona.</summary>
    public decimal IvaClientePct { get; set; } = 16m;
    public decimal AnticipoPct { get; set; } = 60m;
    /// <summary>Datos bancarios del distribuidor (texto libre, se muestra en el PDF).</summary>
    public string? DatosBancarios { get; set; }
    /// <summary>Condiciones que se le muestran al CLIENTE (editables por quien cotiza).
    /// El PDF del distribuidor lleva las condiciones fijas de siempre.</summary>
    public string? CondicionesCliente { get; set; }
    public List<LineaCotizacion> Lineas { get; set; } = new();
}

/// <summary>Totales calculados (lo que muestra el PDF y se persiste en BD).</summary>
public sealed record Totales(
    decimal Subtotal,          // SUBTOTAL PÚBLICO (antes de descuento)
    decimal DescuentoMonto,    // DESCUENTO DISTRIBUIDOR
    decimal SubtotalDesc,      // SUBTOTAL DESCUENTO
    decimal IvaMonto,          // IVA
    decimal GranTotal,         // GRAN TOTAL
    decimal Anticipo,          // ANTICIPO %
    decimal Saldo,             // SALDO
    decimal GastosIndirectos = 0m,  // se suman antes del IVA
    decimal GastosEnvio = 0m);
