//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ASN.Models
{
    using System;
    
    public partial class CatSolicitudesSel_Result
    {
        public int FolioSolicitud { get; set; }
        public bool Active { get; set; }
        public int Ident { get; set; }
        public string Nombre { get; set; }
        public int ConceptoId { get; set; }
        public string ConceptoDesc { get; set; }
        public string Monto { get; set; }
        public Nullable<int> MotivosSolicitudId { get; set; }
        public string MotivosSolicitudDesc { get; set; }
        public int ConceptoMotivoId { get; set; }
        public string ConceptoMotivoDesc { get; set; }
        public int ResponsableId { get; set; }
        public int PeriodoOriginalId { get; set; }
        public string NombreResponsable { get; set; }
        public string EstatusId { get; set; }
        public string EstatusSolicitud { get; set; }
    }
}
