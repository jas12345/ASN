using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class CargaMasivaRegistroViewModel
    {
        public int estatus { get; set; }
        public string parametro { get; set; }
        public decimal detalle { get; set; }
        public int ?solicitudId { get; set; }
        public int userEmployeeId { get; set; }
        public int catEmployeeId { get; set; }
    }
}