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
        public string Fecha_Solicitud { get; set; }
        public Nullable<int> Perfil_Ident { get; set; }
        public Nullable<int> Solicitante_Ident { get; set; }
        public string Solicintante_Nombre { get; set; }
        public Nullable<int> Puesto_solicitante_Ident { get; set; }
        public Nullable<int> PeriodoNominaAnio_Id { get; set; }
        public Nullable<int> PeriodoNominaMes_Id { get; set; }
        public string PeriodoNominaConsecutivoid { get; set; }
        public string PeriodoNominaPeriodicidadNomina_Id { get; set; }
        public string PeriodoNominaTipoPeriodo_Id { get; set; }
        public Nullable<int> ConceptoId { get; set; }
        public Nullable<int> MotivoId { get; set; }
        public string Justficacion { get; set; }
        public Nullable<int> Responsable_Id { get; set; }
        public Nullable<int> Detalle { get; set; }
        public Nullable<int> PeriodoOriginal_AnioId { get; set; }
        public Nullable<int> PeriodoOriginal_MesId { get; set; }
        public string PeriodoOriginal_ConsecutivoId { get; set; }
        public string PeriodoOriginal_PeriodicidadId { get; set; }
        public string PeriodoOriginal_TipoPeriodoId { get; set; }
        public string Autorizantes { get; set; }
        public string ListaEmpleados { get; set; }
        public bool Active { get; set; }
        public string NombrePerfilEmpleados { get; set; }
        public string NombreConcepto { get; set; }
        public string NombreMotivo { get; set; }
    }
}
