using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class EmpleadosSolicitudesViewModel
    {
        public int FolioSolicitud { get; set; }
        public int Empleado_Ident { get; set; }
        public string Empleado_First_Name { get; set; }
        public string Empleado_Middle_Name { get; set; }
        public string Empleado_Last_Name { get; set; }
        public int Empleado_Position_Code_Ident { get; set; }
        public string Empleado_Position_Code_Title { get; set; }
        public int Empleado_Contract_Type_Ident { get; set; }
        public string Empleado_Contract_Type { get; set; }
        public int Manager_Ident { get; set; }
        public string Manager_First_Name { get; set; }
        public string Manager_Middle_Name { get; set; }
        public string Manager_Last_Name { get; set; }
        public int Manager_Position_Code_Ident { get; set; }
        public string Manager_Position_Code_Title { get; set; }
        public int Manager_Contract_Type_Ident { get; set; }
        public string Manager_Contract_Type { get; set; }
        public string CatConceptoMotivoId { get; set; }
        public List<selectModelConceptoMotivo> LstConceptoMotivo { get; set; }
        public Nullable<decimal> ParametroConceptoMonto { get; set; }
        public string Detalle { get; set; }
        public string PeriodoNomina { get; set; }
        public bool Active { get; set; }
    }

    public class selectModelConceptoMotivo
    {
        public int Ident { get; set; }
        public string Valor { get; set; }
    }
}