using Supabase.Postgrest.Attributes;
using Supabase.Postgrest.Models;

namespace CotizadorTL.Web.Models;

/// <summary>Ficha del usuario (tabla public.profiles). El rol define lo que puede ver/hacer.</summary>
[Table("profiles")]
public class Profile : BaseModel
{
    [PrimaryKey("id", false)]
    public string Id { get; set; } = "";

    [Column("nombre")]          public string Nombre { get; set; } = "";
    [Column("email")]           public string? Email { get; set; }
    [Column("rol")]             public string Rol { get; set; } = "Distribuidor";
    [Column("distribuidor_id")] public long? DistribuidorId { get; set; }
    [Column("activo")]          public bool Activo { get; set; } = true;
    [Column("desactivado_el")]  public DateTime? DesactivadoEl { get; set; }
}
