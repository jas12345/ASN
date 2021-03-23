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
    public class ReportePendientesAutorizarYRechazadosController : Controller
    {
        [Authorize(Roles = "Responsable,Consultante")]

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

        public ActionResult GetReporte([DataSourceRequest]DataSourceRequest request, int? periodoNomina, int? empresa, string periodoSelected, string empresaSelected)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int.TryParse(User.Identity.Name, out int userCCMSID);

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstReporte = context.ReportePendientesAutorizarYRechazados(periodoNomina, empresa).ToList();
                    DataSourceResult ok = lstReporte.ToDataSourceResult(request);
                    return Json(ok, JsonRequestBehavior.AllowGet);
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

        /// <summary>
        /// Método que devuelve periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPeriodoNominaCMB(int? active)
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(active,usuario.UserInfo.Ident.Value).ToList();
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

        public JsonResult GetEmpresaCMB()
        {
            try
            {
                var listEmpresa = new List<CatEmpresaByResponsableCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listEmpresa = context.CatEmpresaByResponsableCMB(usuario.UserInfo.Ident.Value).ToList();
                }
                return Json(listEmpresa, JsonRequestBehavior.AllowGet);

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