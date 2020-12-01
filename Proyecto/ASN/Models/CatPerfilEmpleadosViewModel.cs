using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class CatPerfilEmpleadosViewModel 
    {
        public int Perfil_Ident { get; set; }
        public string NombrePerfilEmpleados { get; set; }
        public string Country_Ident { get; set; }
        public string Country_Full_Name { get; set; }
        public string City_Ident { get; set; }
        public string City_Name { get; set; }
        public string Company_Ident { get; set; }
        public string Company_Name { get; set; }
        public string Location_Ident { get; set; }
        public string Location_Name { get; set; }
        public string Client_Ident { get; set; }
        public string Client_Name { get; set; }
        public string Program_Ident { get; set; }
        public string Program_Name { get; set; }
        public string Contract_Type_Ident { get; set; }
        public string Contract_Type { get; set; }
        public string ConceptoId { get; set; }
        public string ConceptoNombre { get; set; }
        public int TipoAccesoId { get; set; }
        public string TipoAcceso { get; set; }
        public bool Active { get; set; }
    }
}