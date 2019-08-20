using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ASN.Models
{
    interface ITraComment
    {
        [ScaffoldColumn(false)]
        [Key]
        int TraCommentId { get; set; }
        [MaxLength(150)]
        [MinLength(1)]
        [RegularExpression("^[0-9a-zA-Z áéíóúñ\n]+$", ErrorMessage = "Solo se aceptan letras y numeros.")]
        [DataType(DataType.MultilineText)]
        string Comentario { get; set; }
        int FolioId { get; set; }
        System.DateTime FechaComentario { get; set; }
        string Nombre { get; set; }
        int EmployeeId { get; set; }
        int ConceptoId { get; set; }
    }

    [MetadataType(typeof(ITraComment))]
    public partial class TraComment : TraCommentSel_Result
    {
        /* Id property has already existed in the mapped class */
    }
}
