using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASN.Models;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using CsvHelper;

namespace ASN.Controllers
{
    public class DescargaArchivosController : Controller
    {
        // GET: DescargaArchivos
        public ActionResult Index()
        {
            return View();
        }    

        public FileContentResult DownloadCSV(FormCollection form)
        {
            try
            {
                var lstSol = new List<DescargaArchivoSolicitud_Result>();
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstSol = ctx.DescargaArchivoSolicitud(usuario.UserInfo.Ident.Value).ToList();
                }
                using (var memo = new System.IO.MemoryStream())
                using (var sw = new System.IO.StreamWriter(memo))
                {
                    Type itemType = typeof(DescargaArchivoSolicitud_Result);
                    var props = itemType.GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);

                    foreach (var item in lstSol)
                    {
                        sw.WriteLine(string.Join(",", props.Select(p => string.Format("\"{0}\"", p.GetValue(item, null)))));                        
                    }
                    sw.Flush();

                    return File(memo.ToArray(), "text/csv", "Report123.csv");                    
                }
                

                //string csv = "Charlie, Chaplin, Chuckles";
                //return File(new System.Text.UTF8Encoding().GetBytes(csv), "text/csv", "Report123.csv");
                
            }
            catch (Exception ex)
            {

                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return null;
            }            
        }

        /// <summary>
        /// Método que devuelve todos los periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPeriodoNominaCMB()
        {
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(1).ToList();
                }

                return Json(listPeriodoNomina, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }
    }
}