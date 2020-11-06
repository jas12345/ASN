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
        [Authorize(Roles = "Responsable")]

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

        public ActionResult GetReporte([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int.TryParse(User.Identity.Name, out int userCCMSID);

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstReporte = context.ReportePendientesAutorizarYRechazados().ToList();
                    DataSourceResult ok = lstReporte.ToDataSourceResult(request);
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