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
    
    public partial class ReporteGeneralDetalleSel_Result
    {
        public int FolioSolicitud { get; set; }
        public string country_full_name { get; set; }
        public Nullable<int> country_ident { get; set; }
        public string Location_Name { get; set; }
        public Nullable<int> Location_Ident { get; set; }
        public string Client_Name { get; set; }
        public Nullable<int> Client_Ident { get; set; }
        public string Program_Name { get; set; }
        public Nullable<int> Program_Ident { get; set; }
        public Nullable<int> JefeInmediatoCCMSID { get; set; }
        public string JefeInmediatoNombre { get; set; }
        public Nullable<int> EmpleadoCCMSID { get; set; }
        public string EmpleadoNombre { get; set; }
        public int ConceptoId { get; set; }
        public string ConceptoDesc { get; set; }
        public int MotivosSolicitudId { get; set; }
        public string MotivoSolicitudDesc { get; set; }
        public int ConceptoMotivoId { get; set; }
        public string ConceptoMotivoDesc { get; set; }
        public Nullable<int> ResponsableId { get; set; }
        public string NombreResponsable { get; set; }
        public string Monto { get; set; }
        public string EstatusSolicitudId { get; set; }
    }
}
