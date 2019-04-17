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
    public class EmpleadosSolicitudesController : Controller
    {
        // GET: EmpleadosSolicitudes
        public ActionResult Index()
        {
            return View();
        }

        public JsonResult GetEmpleadosSolicitudesSel([DataSourceRequest]DataSourceRequest request,string SolicitudId)
        {
            try
            {
                var listEmpleadosSolicitudes = new List<CatEmpleadosSolicitudesSel_Result>();

                    using (ASNContext context = new ASNContext())
                    {
                        int i = 0;
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        listEmpleadosSolicitudes = context.CatEmpleadosSolicitudesSel(((Int32.TryParse(SolicitudId, out i) ? i : (int?)null))).ToList();
                        DataSourceResult ok = listEmpleadosSolicitudes.ToDataSourceResult(request);

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