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
    
    public partial class DescargaArchivoSolicitud_Result
    {
        public Nullable<int> EMPLEADO { get; set; }
        public string CONCEPTO { get; set; }
        public string ACCION { get; set; }
        public Nullable<decimal> UNIDAD { get; set; }
        public Nullable<decimal> IMPORTE { get; set; }
        public Nullable<decimal> PORCENTAJE { get; set; }
        public string FECHA { get; set; }
        public string INICIO { get; set; }
        public string FIN { get; set; }
        public string FOLIO { get; set; }
        public string CONSECUENCIA { get; set; }
        public string CONTROL { get; set; }
        public string SEMANA { get; set; }
        public int FolioSolicitud { get; set; }
        public Nullable<System.DateTime> Fecha_Solicitud { get; set; }
        public Nullable<int> Perfil_Ident { get; set; }
        public Nullable<int> Solicitante_Ident { get; set; }
        public Nullable<int> PeriodoNominaId { get; set; }
        public string EstatusSolicitudId { get; set; }
        public Nullable<int> Responsable_Ident { get; set; }
        public bool Active { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<System.DateTime> DeactivatedDate { get; set; }
        public Nullable<int> DeactivatedBy { get; set; }
        public int LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public string LastModifiedFromPCName { get; set; }
        public Nullable<int> country_ident { get; set; }
        public string country_full_name { get; set; }
        public int location_bios { get; set; }
        public string city { get; set; }
        public Nullable<int> Location_Ident { get; set; }
        public string Location_Name { get; set; }
        public Nullable<int> Client_Ident { get; set; }
        public string Client_Name { get; set; }
        public Nullable<int> Program_Ident { get; set; }
        public string Program_Name { get; set; }
        public Nullable<int> Contract_Type_Ident { get; set; }
        public string Contract_Type { get; set; }
        public Nullable<int> Country_Ident1 { get; set; }
        public Nullable<int> City_Ident { get; set; }
        public int location_ccms { get; set; }
    }
}
