using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class CargaMasivaPerfilEmpleado
    {

        public string perfil { get; set; }
        public string pais { get; set; }
        public string ciudad { get; set; }
        public string cliente { get; set; }
        public string site { get; set; }
        public string programa { get; set; }
        public string contrato { get; set; }
        public string concepto { get; set; }
        public string tpoAcceso { get; set; }
        public int userEmployeeId { get; set; }
        public int catEmployeeId { get; set; }
    }

    public class CargaMasivaRetorno
    {
        public string NombrePerfil { get; set; }
        public string Campo  { get; set; }
        public string Texto { get; set; }
    }
}