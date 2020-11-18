using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class CargaMasivaBonoCViewModel
    {
        public int? CCMSId { get; set; }
        public int? Row { get; set; }
        public int? CreatedBy { get; set; }
        public string Message { get; set; }
        public string ValEmpleado { get; set; }
        public string ValContrato { get; set; }

    }
}