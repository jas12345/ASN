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
    
    public partial class AvisoSolicitantesAutorizantes_Result
    {
        public int FolioSolicitud { get; set; }
        public int Ident_Solicitante { get; set; }
        public string Nombre { get; set; }
        public string eMailSol { get; set; }
        public string EstatusSolicitudId { get; set; }
        public Nullable<int> Autorizador_Ident { get; set; }
        public string Nombre1 { get; set; }
        public string eMailAut { get; set; }
        public Nullable<bool> Autorizado { get; set; }
        public Nullable<bool> Rechazado { get; set; }
        public Nullable<bool> Cancelado { get; set; }
    }
}
