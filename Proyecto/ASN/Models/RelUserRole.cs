//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;

public partial class RelUserRole
{
    public int RelUserRoleId { get; set; }
    public int CatRoleId { get; set; }
    public int UserCCMSId { get; set; }
    public bool Active { get; set; }
    public int CreatedBy { get; set; }
    public System.DateTime CreatedDate { get; set; }
    public Nullable<System.DateTime> DeactivatedDate { get; set; }
    public Nullable<int> DeactivatedBy { get; set; }
    public int LastModifiedBy { get; set; }
    public System.DateTime LastModifiedDate { get; set; }
    public string LastModifiedFromPCName { get; set; }

    public virtual CatRole CatRole { get; set; }
}
