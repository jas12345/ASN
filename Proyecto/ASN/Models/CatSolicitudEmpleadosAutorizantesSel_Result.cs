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
    
    public partial class CatSolicitudEmpleadosAutorizantesSel_Result
    {
        public int FolioSolicitud { get; set; }
        public int Empleado_Ident { get; set; }
        public Nullable<int> Autorizador_Ident { get; set; }
        public string NombreEmpleado { get; set; }
        public string NombreAutorizador { get; set; }
        public Nullable<int> NivelAutorizacion { get; set; }
        public string EsObligatorio { get; set; }
        public Nullable<bool> Obligatorio { get; set; }
        public Nullable<decimal> MontoAutorizacionAutomatica { get; set; }
        public string Estatus { get; set; }
        public string Contrato { get; set; }
        public Nullable<bool> Autorizado { get; set; }
        public Nullable<bool> Rechazado { get; set; }
        public Nullable<bool> Cancelado { get; set; }
        public Nullable<bool> Active { get; set; }
        public string EmailManager { get; set; }
    }
}
