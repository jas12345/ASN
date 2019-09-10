using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class AutorizaViewModel
    {
        public int FolioSolicitud { get; set; }
        public int Empleado_Ident { get; set; }
        public int ConceptoId { get; set; }
        public int NivelAutorizacion { get; set; }
        public int Accion { get; set; }
    }
}