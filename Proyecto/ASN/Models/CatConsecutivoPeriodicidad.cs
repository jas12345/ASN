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
    using System.Collections.Generic;
    
    public partial class CatConsecutivoPeriodicidad
    {
        public int ConsecutivoId { get; set; }
        public string PeriodicidadNominaId { get; set; }
        public bool Active { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<System.DateTime> DeactivatedDate { get; set; }
        public Nullable<int> DeactivatedBy { get; set; }
        public int LastModifiedBy { get; set; }
        public System.DateTime LastModifiedDate { get; set; }
        public string LastModifiedFromPCName { get; set; }
    }
}
