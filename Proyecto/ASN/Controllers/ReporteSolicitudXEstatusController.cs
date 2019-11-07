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
    [Authorize(Roles = "Consultante,Administrador")]
    public class ReporteSolicitudXEstatusController : Controller
    {
        // GET: ReporteSolicitud
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

        public ActionResult GetSolicitudes([DataSourceRequest]DataSourceRequest request,string fechaIni, string fechaFin, string estatusConcepto, string estatusSolicitud)//, string estatus, int? site, int? solicitanteCCMSID, int? city)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.ReporteSolicitudXEstatusSel(fechaIni, fechaFin,estatusSolicitud,estatusConcepto).ToList();//, city,site,solicitanteCCMSID,estatus).ToList();
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

        //public JsonResult GetCiudadesCMB()
        //{
        //    try
        //    {
        //        var lstCMB = new List<CatCityCMB_Result>();

        //        using (ASNContext ctx = new ASNContext())
        //        {
        //            ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
        //            lstCMB = ctx.CatCityCMB().ToList();
        //        }

        //        return Json(lstCMB, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (Exception ex)
        //    {
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(ex, usuario.UserInfo.Ident.Value);
        //        return Json("");
        //    }
        //}

        //public JsonResult GetSitesCMB()
        //{
        //    try
        //    {
        //        var lstCMB = new List<CatSiteCMB_Result>();

        //        using (ASNContext ctx = new ASNContext())
        //        {
        //            ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
        //            lstCMB = ctx.CatSiteCMB().ToList();
        //        }

        //        return Json(lstCMB, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (Exception ex)
        //    {
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(ex, usuario.UserInfo.Ident.Value);
        //        return Json("");
        //    }
        //}

        //public JsonResult GetEmployeesCMB()
        //{
        //    try
        //    {
        //        var lstCMB = new List<CatEmpleadoSolicitanteCMB_Result>();

        //        using (ASNContext ctx = new ASNContext())
        //        {
        //            ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
        //            lstCMB = ctx.CatEmpleadoSolicitanteCMB().ToList();
        //        }

        //        return Json(lstCMB, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (Exception ex)
        //    {
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(ex, usuario.UserInfo.Ident.Value);
        //        return Json("");
        //    }
        //}

        public JsonResult GetEstatusCMB()
        {
            try
            {
                var lstCMB = new List<CatEstatusCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatEstatusCMB().ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
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