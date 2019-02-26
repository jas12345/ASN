using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    interface IProDepro
    {
        [ScaffoldColumn(false)]
        [Key]
        int CatProDeproId { get; set; }
        int CCMSID { get; set; }
        int ActionId { get; set; }
        Nullable<int> SubActionId { get; set; }
        System.DateTime FechaIni { get; set; }
        Nullable<System.DateTime> FechaFin { get; set; }
        string FullName { get; set; }
        string Foto { get; set; }
        int UPLOAD { get; set; }
        string NombreFile { get; set; }
    }

    [MetadataType(typeof(IProDepro))]
    public partial class ProDepro : CatProDeproSel_Result
    {
        /* Id property has already existed in the mapped class */
        public string Foto { get; set; }
    }
}