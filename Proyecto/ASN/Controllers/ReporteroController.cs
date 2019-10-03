using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASN.Controllers
{
    [Authorize(Roles = "Consultante,Administrador,Responsable")]
    public class ReporteroController : Controller
    {
        // GET: Reportero
        public ActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                return View();
            }
            else
            {
                return RedirectToAction("Login", "Home");
            }
        }

        public ActionResult gridNames()
        {
            List<string> lstEsquemas = new List<string>();
            lstEsquemas.Add("General");
            lstEsquemas.Add("NominaManual Activos");
            lstEsquemas.Add("NominaManual Inactivos");

            var results = from obj in lstEsquemas select new { GridNameVal = obj, GridNameID = obj };

            return Json(results, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult MyGrid(string selectedID)
        {
            try
            {
                switch (selectedID.ToString())
                {
                    case "General":
                        var partialGeneral = new ReporteConceptoGeneralSel_Result();
                        return PartialView("General", partialGeneral);
                    case "NominaManual Activos":
                        var partialActivos = new DescargaArchivoSolicitudSel_Result();
                        return PartialView("NominaActivos", partialActivos);
                    case "NominaManual Inactivos":
                        var partialInactivos = new DescargaArchivoSolicitudSel_Result();
                        return PartialView("NominaInactivos", partialInactivos);
                    default:
                        return View();
                }
                //var partialViewModel = new CatRolesSel_Result();
                // TODO: Populate the model (viewmodel) here using the id

                //return PartialView("Profiles", partialViewModel);
            }
            catch (Exception ex)
            {
                return View();
            }
        }

        public ActionResult GetConceptosGeneral([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.ReporteConceptoGeneralSel().ToList();
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


        public ActionResult GetNominaActivos([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.DescargaArchivoSolicitudSel(true).ToList();
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

        public ActionResult GetNominaInactivos([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.DescargaArchivoSolicitudSel(false).ToList();
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
    }
}