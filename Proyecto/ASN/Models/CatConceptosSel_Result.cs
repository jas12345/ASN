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
    
    public partial class CatConceptosSel_Result
    {
        public int ConceptoId { get; set; }
        public string Descripcion { get; set; }
        public int TipoConcepto { get; set; }
        public string PaisId { get; set; }
        public string Paises { get; set; }
        public int MercadoId { get; set; }
        public int ClienteId { get; set; }
        public int PeopleSoftId { get; set; }
        public string TipoPeriodoId { get; set; }
        public Nullable<int> NumeroNivelAutorizante { get; set; }
        public Nullable<bool> AutorizacionAutomatica { get; set; }
        public Nullable<bool> AutorizacionObligatoria { get; set; }
        public bool Active { get; set; }
    }
}
