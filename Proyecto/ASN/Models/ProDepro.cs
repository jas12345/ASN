using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class ProDepro
    {
        public int CatProDeproId { get; set; }
        public string FullName { get; set; }
        public int CCMSID { get; set; }
        public bool ActionId { get; set; }
        public bool SubActionId { get; set; }
        public string FechaIni { get; set; }
        public string FechaFin { get; set; }
        public string UPLOAD { get; set; }
        public string NombreFile { get; set; }
        public string Foto { get; set; }
    }
}