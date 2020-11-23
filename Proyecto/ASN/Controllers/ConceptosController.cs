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
    [Authorize(Roles = "Administrador")]
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
                        ViewData["PeopleSoft"] = context.CatConceptosPeopleSoftCMB(0).ToList();
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
        public JsonResult GetNivelesDeAutorizacionCMB(string numeroDeNiveles)
        {
            try
            {
                var lstNiveles = new List<NivelesCMB>();
                var nivelInicial = 0;
                var numeroNiveles = 0;

                int.TryParse(numeroDeNiveles,out numeroNiveles);

                while (nivelInicial < numeroNiveles)
                {
                    var obj = new NivelesCMB();
                    nivelInicial = nivelInicial + 1;
                    obj.Ident = nivelInicial;
                    obj.Nivel = nivelInicial;

                    lstNiveles.Add(obj);
                }

                return Json(lstNiveles,JsonRequestBehavior.AllowGet);
            }
            catch(Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        [HttpPost]
        public ActionResult GetSugerido(string nivelId, string conceptoId)
        {
            try
            {
                int conceptId = 0;
                int level = 0;
                int.TryParse(conceptoId, out conceptId);
                int.TryParse(nivelId, out level);
                int? resultado = 0;
                using (ASNContext context = new ASNContext())
                {
                    resultado = context.AutorizadorxConceptoxNivelCMB(conceptId,level).SingleOrDefault();
                }

                if (resultado != null)
                {
                    return Json(resultado, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(0, JsonRequestBehavior.AllowGet);
                }
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

        [HttpPost]
        public ActionResult SaveAutorizante(string conceptoId, string nivelId, string ccmsid)
        {
            try
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                int conceptId, level, ident = 0;
                int.TryParse(conceptoId, out conceptId);
                int.TryParse(nivelId, out level);
                int.TryParse(ccmsid, out ident);
                ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                using (ASNContext context = new ASNContext())
                {
                    context.CatConceptosNivelAutorizadorSi(conceptId, level, ident, usuario.UserInfo.Ident.Value, resultado);
                }

                if (Convert.ToInt32(resultado.Value) != -1)
                {
                    return Json(resultado, JsonRequestBehavior.AllowGet);
                }
                else
                {
                    return Json(-1, JsonRequestBehavior.AllowGet);
                }
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


        public ActionResult GetAutorizantesCMB(string conceptoId)
        {
            try
            {
                int conceptId = 0;
                int.TryParse(conceptoId, out conceptId);
                var lstCMB = new List<AutorizadoresxConceptoCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.AutorizadoresxConceptoCMB(conceptId).ToList();
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

        public JsonResult GetConceptosPeoplesoftCMB()
        {
            try
            {
                var lstCMB = new List<CatConceptosPeopleSoftCMB_Result>();
                //MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;

                //int locIdUser = usuario.UserInfo.Location_Ident.Value;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatConceptosPeopleSoftCMB(0).ToList();
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
                var lstCMB = new List<CatClientTodosCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatClientTodosCMB().ToList();
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
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var lstCMB = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.CatPeriodosNominaCMB(1, usuario.UserInfo.Ident.Value).ToList();
                }
                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception excepcion)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                
                LogError log = new LogError();
                log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetPeriodicidadCMB(string pais)
        {
            try
            {
                var lstCMB = new List<RelPeriodicidadPaisCMB_Result>();

                using (ASNContext context = new ASNContext())
                {
                    lstCMB = context.RelPeriodicidadPaisCMB(pais).ToList();
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

        public JsonResult GetVigenciaCMB(string periodicidad)
        {
            try
            {
                var lstCMB = new List<RelPeriodicidadPaisCMB_Result>();

                
                lstCMB.Add(new RelPeriodicidadPaisCMB_Result() { Valor = "Inicio", Ident = "Inicio" });
                lstCMB.Add(new RelPeriodicidadPaisCMB_Result() { Valor = "Fin", Ident = "Fin" });
                if (string.IsNullOrEmpty(periodicidad) || periodicidad !="Q")
                {
                    lstCMB.Add(new RelPeriodicidadPaisCMB_Result() { Valor = "Periodo de nomina", Ident = "Periodo nomina" });
                    lstCMB.Add(new RelPeriodicidadPaisCMB_Result() { Valor = "Todos", Ident = "Todos" });
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
        public ActionResult CreateConcepto([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatConceptosSel_Result> profiles, string fechaInicio, string fechaFin)
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
                                obj.TipoConceptoId,
                                obj.Paises,
                                obj.ClienteId,
                                obj.PeopleSoftId,
                                obj.NumeroNivelAutorizante,
                                obj.AutorizacionAutomatica,
                                obj.AutorizacionObligatoria,
                                obj.Vigencia,
                                obj.PagosFijos,
                                obj.Tope,
                                obj.PeriodicidadNominaId,
                                fechaInicio,
                                fechaFin,
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
                                obj.TipoConceptoId,
                                obj.Paises,
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