using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASN.Controllers
{
    public class PeriodicidadNominaController : Controller
    {
        // GET: PeriodicidadNomina
        public ActionResult Index()
        {
            try
            {
                if (User.Identity.IsAuthenticated)
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        ViewData["TipoPeriodicidad"] = context.CatPeriodicidadNominaCMB().ToList();
                    }

                    return View();
                }
                else
                {
                    return RedirectToAction("Login", "Home");
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return RedirectToAction("Login", "Home");
            }
        }

        public JsonResult GetPeriodicidadNominaCMB()
        {
            try
            {
                var lstCMB = new List<CatPeriodicidadNominaCMB_Result>();
                //MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;

                //int locIdUser = usuario.UserInfo.Location_Ident.Value;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatPeriodicidadNominaCMB().ToList();
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

        /// <summary>
        /// Obtiene las registros actuales
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult GetPeriodicidadNomina([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var list2 = context.CatPeriodicidadNominaSel().ToList();

                    DataSourceResult ok = list2.ToDataSourceResult(request);

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
        public ActionResult CreatePeriodicidadNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPeriodicidadNominaSel_Result> profiles)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    int ccmsidAdmin = 0;
                    int res = 0;
                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);

                    foreach (var obj in profiles)
                    {
                        if (!string.IsNullOrEmpty(obj.Descripcion) && !string.IsNullOrEmpty(obj.PeriodicidadNominaId))
                        {
                            context.CatPeriodicidadNominaSi(obj.PeriodicidadNominaId,obj.Descripcion, obj.Consecutivos, ccmsidAdmin, resultado);
                        }
                        else
                        {
                            ModelState.AddModelError("error", "La descripción y la periodicidadId no pueden estar vacios.");
                        }
                    }

                    int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe una periodicidad de nomina con la misma descripción.");
                    }
                    else if (res == -2)
                    {
                        ModelState.AddModelError("error", "Ya existe una periodicidad de nomina con la misma clave.");
                    }
                    else if (res == -3)
                    {
                        ModelState.AddModelError("error", "Ya existe un registro con la misma clave y / o descripción.");
                    }

                    return Json(profiles.ToDataSourceResult(request, ModelState));
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(profiles.ToDataSourceResult(request, ModelState));
            }
        }

        [HttpPost]
        public ActionResult UpdatePeriodicidadNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPeriodicidadNominaSel_Result> profiles)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    int ccmsidAdmin = 0;
                    int res = 0;
                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);

                    foreach (var obj in profiles)
                    {
                        if (!string.IsNullOrEmpty(obj.Descripcion) && !string.IsNullOrEmpty(obj.PeriodicidadNominaId))
                        {
                            context.CatPeriodicidadNominaSu(obj.PeriodicidadNominaId, obj.Descripcion, ccmsidAdmin, obj.Active, resultado);
                        }
                        else
                        {
                            ModelState.AddModelError("error", "La descripción y la periodicidadId no pueden estar vacios.");
                        }
                    }

                    int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe una periodicidad de nomina con la misma descripción.");
                    }

                    return Json(profiles.ToDataSourceResult(request, ModelState));
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(profiles.ToDataSourceResult(request, ModelState));
            }
        }
    }
}