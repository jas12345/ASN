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
    public class ConceptosController : Controller
    {
        // GET: Conceptos
        public ActionResult Index()
        {
            try
            {
                if (User.Identity.IsAuthenticated)
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        ViewData["TiposConceptos"] = context.CatTipoConceptosCMB().ToList();
                        ViewData["Paises"] = context.CatCountryCMB().ToList();
                        ViewData["Mercados"] = context.CatCompanyCMB().ToList();
                        ViewData["Clientes"] = context.CatClientCMB().ToList();
                        ViewData["PeopleSoft"] = context.CatConceptosMotivoCMB().ToList();
                        ViewData["TipoPeriodo"] = context.CatTiposPeriodoNominaCMB().ToList();
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

        #region Conjunto de metodos para cargas de combos
        public JsonResult GetConceptosCMB()
        {
            try
            {
                var lstCMB = new List<CatTipoConceptosCMB_Result>();
                //MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;

                //int locIdUser = usuario.UserInfo.Location_Ident.Value;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatTipoConceptosCMB().ToList();
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

        public JsonResult GetCountryCMB()
        {
            try
            {
                var lstCMB = new List<CatCountryCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatCountryCMB().ToList();
                }
                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetCompanyCMB()
        {
            try
            {
                var lstCMB = new List<CatCompanyCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatCompanyCMB().ToList();
                }
                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetClientCMB()
        {
            try
            {
                var lstCMB = new List<CatClientCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatClientCMB().ToList();
                }
                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetConceptosMotivoCMB()
        {
            try
            {
                var lstCMB = new List<CatConceptosMotivoCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatConceptosMotivoCMB().ToList();
                }
                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetTipoPeriodoCMB()
        {
            try
            {
                var lstCMB = new List<CatTiposPeriodoNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatTiposPeriodoNominaCMB().ToList();
                }
                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetPeriodoNominaCMB()
        {
            try
            {
                var lstCMB = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatPeriodosNominaCMB().ToList();
                }
                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetPeriodicidadCMB()
        {
            try
            {
                var lstCMB = new List<CatPeriodicidadNominaCMB_Result>();

                lstCMB.Add(new CatPeriodicidadNominaCMB_Result() { Ident= "Catorcenal", Valor= "Catorcenal" });
                lstCMB.Add(new CatPeriodicidadNominaCMB_Result() { Ident = "Quincenal", Valor = "Quincenal" });
                lstCMB.Add(new CatPeriodicidadNominaCMB_Result() { Ident = "Mensual", Valor = "Mensual" });

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetParametrosConceptosCMB()
        {
            try
            {
                var lstCMB = new List<CatParametroConceptosCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatParametroConceptosCMB().ToList();
                }
                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }
        #endregion

        /// <summary>
        /// Obtiene las registros actuales
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult GetConceptos([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var listado = context.CatConceptosSel().ToList();

                    DataSourceResult ok = listado.ToDataSourceResult(request);
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
        public ActionResult CreateConcepto([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatConceptosSel_Result> profiles)
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
                        if (!string.IsNullOrEmpty(obj.Descripcion))
                        {
                            context.CatConceptosSi(
                                obj.Descripcion,
                                obj.TipoConcepto,
                                obj.Paises,
                                obj.MercadoId,
                                obj.ClienteId,
                                obj.PeopleSoftId,
                                obj.NumeroNivelAutorizante,
                                obj.AutorizacionAutomatica,
                                obj.AutorizacionObligatoria,
                                obj.Vigencia,
                                obj.PagosFijos,
                                obj.Tope,
                                obj.PeriodicidadNominaId,
                                obj.FechaInicio,
                                obj.FechaFin,
                                obj.ParametroConceptoId,
                                ccmsidAdmin,
                                resultado);
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
        public ActionResult UpdateConcepto([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatConceptosSel_Result> profiles, string FechaInicio, string FechaFin)
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
                        if (!string.IsNullOrEmpty(obj.Descripcion))
                        {
                            context.CatConceptosSu(
                                obj.ConceptoId,
                                obj.Descripcion,
                                obj.TipoConcepto,
                                obj.Paises,
                                obj.MercadoId,
                                obj.ClienteId,
                                obj.PeopleSoftId,
                                obj.NumeroNivelAutorizante,
                                obj.AutorizacionAutomatica,
                                obj.AutorizacionObligatoria,
                                obj.Vigencia,
                                obj.PagosFijos,
                                obj.Tope,
                                obj.PeriodicidadNominaId,
                                FechaInicio,
                                FechaFin,
                                obj.ParametroConceptoId,
                                obj.Active,
                                ccmsidAdmin,
                                resultado);
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
    }
}