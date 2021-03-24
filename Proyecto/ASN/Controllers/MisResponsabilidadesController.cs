using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web.Mvc;

namespace ASN.Controllers
{
    [Authorize(Roles = "Responsable")]
    public class MisResponsabilidadesController : Controller
    {
        // GET: CapturasRapidas/MisResponsabilidades
        public ActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    ViewData["PeriodosNominaRes"] = context.CatPeriodosNominaCMB(0,usuario.UserInfo.Ident.Value,0).ToList();
                }

                return View();
            }
            else
            {
                return RedirectToAction("Login", "Home");
            }

        }

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

        public ActionResult GetResponsabilidades([DataSourceRequest] DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    //var lstResponsabilidades = context.CatMisResponsabilidadesSel(idAdmin).ToList();
                    var lstResponsabilidades = context.CatMisResponsabilidadesSel(idAdmin).ToList();
                    DataSourceResult ok = lstResponsabilidades.ToDataSourceResult(request);
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
        [HttpPost]
        public FileResult CierreMasivo()
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

            List<string> resultado = new List<string>();
            try
            { 
                using (ASNContext context = new ASNContext())
                {
                    //int.TryParse(User.Identity.Name, out int idAdmin);
                    var CCMSId = usuario.UserInfo.Ident.Value;

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    resultado = context.CatCierreSolicitudesMasivo(CCMSId).ToList();
                    
                }
                using (var memStream = new System.IO.MemoryStream())
                {
                    //var nombreArchivo = "Reporte de Folios Cerrados_" + DateTime.Now.ToString("YYYY-mm-dd 24HH:MM:ss") + ".TXT";
                    var streamWriter = new System.IO.StreamWriter(memStream);

                    //for (int i = 0; i < 6; i++)
                    //    streamWriter.WriteLine("TEST");
                    foreach (var item in resultado)
                    {
                        streamWriter.WriteLine(item);
                    }


                    streamWriter.Flush();
                    memStream.Seek(0, System.IO.SeekOrigin.Begin);
                    return File(memStream.ToArray(), "application/txt", "Reporte de Folios.txt");

                }
            }
            catch (Exception ex)
            {               
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return null;
            }

            return null;

            
        }
            
    }
}