using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASN.Models
{
    public class PeriodoNominaViewModel
    {
        public int AnioId { get; set; }
        public int MesId { get; set; }
        public string PeriodicidadNominaId { get; set; }
        public string ConsecutivoId { get; set; }
        public string TipoPeriodo { get; set; }
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }
        public string FechaCaptura { get; set; }
        public string FechaCierre { get; set; }
        public List<selectModel> LstCountryIdents { get; set; }
        public string[] LtCountryIdents { get; set; }
        public string CountryIdents { get; set; }
        public string NombrePeriodo { get; set; }
        public bool Active { get; set; }
        public string EstatusPeriodo { get; set; }
    }

    public class selectModel
    {
        public int Id { get; set; }
        public string Value { get; set; }
    }
}