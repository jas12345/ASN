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
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    ViewData["PeriodosNominaRes"] = context.CatPeriodosNominaCMB(0).ToList();
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
    }
}