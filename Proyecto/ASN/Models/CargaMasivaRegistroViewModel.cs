using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class CargaMasivaRegistroViewModel
    {
        public string estatus { get; set; }
        public int parametro { get; set; }
        public string detalle { get; set; }
        public int solicitudId { get; set; }
        public int userEmployeeId { get; set; }
        public int catEmployeeId { get; set; }
    }
}