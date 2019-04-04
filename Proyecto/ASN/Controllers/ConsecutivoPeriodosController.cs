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
    public class ConsecutivoPeriodosController : Controller
    {
        // GET: ConsecutivoPeriodos
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
                        ViewData["ConsecutivosPeriodo"] = context.CatConsecutivoPeriodicidadCMB("All").ToList();
                        ViewData["AniosCMB"] = context.CatAniosNominaCMB(null).ToList();
                        ViewData["MesCMB"] = context.CatMesesCMB(0).ToList();
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

        public JsonResult GetConsecutivosPeriodicidadCMB(string perid)
        {
            try
            {
                var lstCMB = new List<CatConsecutivoPeriodicidadCMB_Result>();
                //MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;

                //int locIdUser = usuario.UserInfo.Location_Ident.Value;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatConsecutivoPeriodicidadCMB(perid).ToList();
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

        public JsonResult GetTipoDePeriodicidadCMB()
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

        public JsonResult GetAniosCMB()
        {
            try
            {
                var lstCMB = new List<CatAniosNominaCMB_Result>();
                //MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;

                //int locIdUser = usuario.UserInfo.Location_Ident.Value;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatAniosNominaCMB(null).ToList();
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

        public JsonResult GetMesCMB(int anioId)
        {
            try
            {
                var lstCMB = new List<CatMesesCMB_Result>();
                //MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;

                //int locIdUser = usuario.UserInfo.Location_Ident.Value;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatMesesCMB(anioId).ToList();
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
        public ActionResult GetConsecutivoPeriodos([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var list2 = context.CatConsecutivoPeriodosSel().ToList();

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
        public ActionResult CreateConsecutivoPeriodos([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatConsecutivoPeriodosSel_Result> profiles, string fechainicio, string fechacierre)
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
                        if (!string.IsNullOrEmpty(fechainicio) && !string.IsNullOrEmpty(fechacierre))
                        {
                            context.CatConsecutivoPeriodosSi(obj.AnioId, obj.MesId, obj.ConsecutivoId, obj.PeriodicidadNominaId, fechainicio, fechacierre, ccmsidAdmin, resultado);
                        }
                    }

                    int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                    }

                    return Json(profiles.ToDataSourceResult(request, ModelState));
                }

                //return Json("");
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
        public ActionResult UpdateConsecutivoPeriodos([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatConsecutivoPeriodosSel_Result> profiles, string fechainicio, string fechacierre)
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
                        if (!string.IsNullOrEmpty(fechainicio) && !string.IsNullOrEmpty(fechacierre))
                        {
                            context.CatConsecutivoPeriodosSu(obj.AnioId, obj.MesId,obj.ConsecutivoId, obj.PeriodicidadNominaId, fechainicio, fechacierre, ccmsidAdmin, obj.Active, resultado);
                        }
                    }

                    int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe otro concepto con la misma descripción.");
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

        public JsonResult GetFechasMes(int mesId, int anioId)
        {
            try
            {
                var lstCMB = new List<CatMesesFechasCMB_Result>();

                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatMesesFechasCMB(mesId, anioId).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }
    }
}