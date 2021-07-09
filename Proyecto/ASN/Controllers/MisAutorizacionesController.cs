using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Text;

	

namespace ASN.Controllers
{
    [Authorize(Roles = "Autorizante")]
    public class MisAutorizacionesController : Controller
    {
        // GET: CapturasRapidas/MisSolicitudes
        public ActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    ViewData["PeriodosNomina"] = context.CatPeriodosNominaCMB(0,usuario.UserInfo.Ident.Value,0).ToList();
                }

                return View();
            }
            else
            {
                return RedirectToAction("Login", "Home");
            }
        }

        /// <summary>
        /// Método que devuelve todos los periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPeriodoNominaCMB()
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(1,usuario.UserInfo.Ident.Value,0).ToList();
                }

                return Json(listPeriodoNomina, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
               
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public ActionResult getAutorizaciones([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.CatMisAutorizacionesSel(idAdmin).ToList();
                    DataSourceResult ok = lstSolicitudes.ToDataSourceResult(request);
                    return Json(ok);
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public PartialViewResult DetalleAutorizacion(int? FolioSolicitud)
        {
            try
            {
                using ( ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.ConDetalleFolioAutorizacion(FolioSolicitud).ToList();
                    return PartialView("DetalleAutorizacion", lstSolicitudes);
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return PartialView("");
            }
        }

        public FileContentResult ReporteAutorizadorEstatus(string EstatusSolicitudId) //, KendoDropDownListSelectedViewModel kddListSelectedView )
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
               //List<ReporteAutorizadorEstatus_Result>  
               var ResultadoLst     = new List<ReporteAutorizadorEstatus_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    ResultadoLst = ctx.ReporteAutorizadorEstatus(usuario.UserInfo.Ident.Value, EstatusSolicitudId).ToList();
                   
                }


                using (var memoryStream = new MemoryStream())
                {
                   
                       // var file1 = archive.CreateEntry(string.Format("NominaManual_Activos_{0}.csv", kddslv.PeriodoNomina));
                        using (var streamWriter = new StreamWriter(memoryStream, Encoding.UTF8))
                        {
                            Type itemType = typeof(ReporteAutorizadorEstatus_Result);
                          
                            var props = itemType.GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);

                            IEnumerable<string> header = typeof(ReporteAutorizadorEstatus_Result).GetProperties().Select(prop => prop.Name);                          
                            streamWriter.WriteLine(string.Join(",", header).Replace("_"," "));
                       
                            foreach (var item in ResultadoLst)
                                {
                                    streamWriter.WriteLine(string.Join(",", props.Select(p => string.Format("\"{0}\"", p.GetValue(item, null)))));
                                }
                                streamWriter.Flush();
                            }                  

                    return File(memoryStream.ToArray(), "application/csv", string.Format("Reporte folios pendientes de autorizar_{0}_{1}.csv",DateTime.Now.ToString("yyyyMMdd"), DateTime.Now.ToString("HHmmss")));
                }

            }
            catch (Exception ex)
            {


                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return null;
            }
        }
    }
}