using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class TraCommentSelViewModel
    {
        public int TraCommentId { get; set; }
        public string Comentario { get; set; }
        //public System.DateTime FechaComentario { get; set; }
        //public string Nombre { get; set; }
        //public int CCMSIDAutor { get; set; }
        public int FolioSolicitud { get; set; }
        public int Empleado_Ident { get; set; }
        public int ConceptoId { get; set; }
    }
}