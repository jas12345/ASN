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
    
    public partial class CatCargaRapidaSel_Result
    {
        public int CargaRapidaId { get; set; }
        public int CCMSID { get; set; }
        public int ConceptoId { get; set; }
        public decimal Parametro { get; set; }
        public int Motivo { get; set; }
        public Nullable<int> ConceptoMotivo { get; set; }
        public Nullable<int> ResponsableIncidenteCCMSID { get; set; }
        public string PeriodoOriginalDePago { get; set; }
        public string PeriodoNominaActual { get; set; }
        public int Estatus { get; set; }
        public int FolioSolicitudId { get; set; }
        public string Justificacion { get; set; }
    }
}
