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
    
    public partial class CatUserInfoSel_Result
    {
        public Nullable<int> Ident { get; set; }
        public string First_Name { get; set; }
        public string Middle_Name { get; set; }
        public string Last_Name { get; set; }
        public Nullable<int> Manager_Ident { get; set; }
        public string Manager_First_Name { get; set; }
        public string Manager_Middle_Name { get; set; }
        public string Manager_Last_Name { get; set; }
        public Nullable<System.DateTime> Hire_Date { get; set; }
        public string Position_Code_Title { get; set; }
        public Nullable<int> Location_Ident { get; set; }
        public string Location_Name { get; set; }
        public Nullable<int> Contract_Type_Ident { get; set; }
        public string Contract_Type { get; set; }
        public string Account_ID { get; set; }
        public Nullable<int> Country_ident { get; set; }
        public string FullName { get; set; }
    }
}
