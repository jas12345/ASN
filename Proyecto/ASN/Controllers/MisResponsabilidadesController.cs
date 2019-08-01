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
    [Authorize(Roles = "Responable")]
    public class MisResponsabilidadesController : Controller
    {
        // GET: CapturasRapidas/MisResponsabilidades
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult getResponsabilidades([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
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