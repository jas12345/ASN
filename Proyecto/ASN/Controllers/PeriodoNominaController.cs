using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASN.Controllers
{
    public class PeriodoNominaController : Controller
    {
        // GET: PeriodoNomina
        /// <summary>
        /// Método que valida los permisos y muestra la vista principal de los periodos de nomina
        /// </summary>
        /// <returns>Si tiene le permite acceder al modulo, de lo contrario lo redirecciona al login</returns>
        public ActionResult Index()
        {
            try
            {
                if (User.Identity.IsAuthenticated)
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        ViewData["Anios"] = context.CatAniosNominaCMB(null).ToList();
                        ViewData["Meses"] = context.CatMesesCMB(0).ToList();
                        ViewData["PeriodicidadNomina"] = context.CatPeriodicidadNominaCMB().ToList();
                        ViewData["Consecutivos"] = context.CatConsecutivoPeriodicidadCMB("All").ToList();
                        ViewData["TipoPeriodicidad"] = context.CatTiposPeriodoNominaCMB().ToList();
                        ViewData["TipoConsecutivo"] = context.CatTiposConsecutivoCMB().ToList();
                    }
                    return View();
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
            }

            return RedirectToAction("Login", "Home");
        }

        /// <summary>
        /// Método que devuelve todos los periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
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

        /// <summary>
        /// Método que se encarga de llenar el combo de País
        /// </summary>
        /// <returns></returns>
        public JsonResult GetCountryIdentsCMB()
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

        //public List<dynamic> GetCountryDynamic()
        //{
        //    try
        //    {
        //        var lstCMB = new List<CatCountryCMB_Result>();
        //        var lstDynamic = new List<dynamic>();
        //        using (ASNContext context = new ASNContext())
        //        {
        //            lstCMB = context.CatCountryCMB().ToList();
        //        }

        //        foreach (var item in lstCMB)
        //        {
        //            lstDynamic.Add(new { Text = item.Value, Value = item.Id });
        //        }

        //        return lstDynamic;
        //    }
        //    catch (Exception excepcion)
        //    {
        //        ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(excepcion, usuario.UserInfo.Ident.Value);
        //        return null;
        //    }
        //}

        /// <summary>
        /// Método para obtener el listado de los tipos de período
        /// </summary>
        /// <returns></returns>
        public JsonResult GetTipoPeriodoCMB()
        {
            try
            {
                var listTipoPeriodo = new List<CatTiposPeriodoNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listTipoPeriodo = context.CatTiposPeriodoNominaCMB().ToList();
                }

                return Json(listTipoPeriodo, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetAniosNominaCMB()
        {
            try
            {
                var lstCMB = new List<CatAniosNominaCMB_Result>();

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

        /// <summary>
        /// Método para obtener los meses que se encuentran relacionados con los consecutivos de periodos
        /// </summary>
        /// <param name="anioId"></param>
        /// <returns></returns>
        public JsonResult GetAnioMesesConsecutivoCMB(int anioId)
        {
            try
            {
                var lstCMB = new List<CatAnioMesesConsecutivoCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatAnioMesesConsecutivoCMB(anioId).ToList();
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

        public JsonResult GetAnioMesPeriodicidadNominaCMB(int anioId, string mesId)
        {
            try
            {
                var lstPeriodicidadNomina = new List<CatAnioMesPeriodicidadNominaCMB_Result>();
                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstPeriodicidadNomina = ctx.CatAnioMesPeriodicidadNominaCMB(anioId, mesId).ToList();
                }

                return Json(lstPeriodicidadNomina, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetConsecutivoPeriodoNominaCMB(int anioId, string mesId, string perid)
        {
            try
            {
                var lstConsecutivo = new List<CatPeriodicidadNominaAnioMesConsecutivoCMB_Result>();
                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstConsecutivo = ctx.CatPeriodicidadNominaAnioMesConsecutivoCMB(anioId, mesId, perid).ToList();
                }

                return Json(lstConsecutivo, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetTipoConsecutivo()
        {
            try
            {
                var lstTipoConsecutivo = new List<CatTiposConsecutivoCMB_Result>();
                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstTipoConsecutivo = ctx.CatTiposConsecutivoCMB().ToList();
                }

                return Json(lstTipoConsecutivo, JsonRequestBehavior.AllowGet);
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
        /// Método que retorna los registros actuales para su uso en el grid
        /// </summary>
        /// <param name="request"></param>
        /// <returns>Retorna un datasource con todos los periodos de nomina y en caso de excepción retorna vacio.</returns>
        [HttpPost]
        public JsonResult GetPeriodosNomina([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaSel_Result>();
                var lstPeriodosNomina = new List<PeriodoNominaViewModel>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaSel().ToList();
                    foreach (var item in listPeriodoNomina)
                    {
                        lstPeriodosNomina.Add(new PeriodoNominaViewModel()
                        {
                            AnioId = item.AnioId,
                            MesId = item.MesId,
                            PeriodicidadNominaId = item.PeriodicidadNominaId,
                            ConsecutivoId = item.ConsecutivoId.ToString(),
                            TipoPeriodo = item.TipoPeriodo,
                            CountryIdents = item.CountryIdents,
                            LtCountryIdents = (!string.IsNullOrEmpty(item.CountryIdents) ? item.CountryIdents.Split(',') : null),
                            NombrePeriodo = item.NombrePeriodo,
                            FechaInicio = item.FechaInicio.ToString("MM/dd/yyyy"),
                            FechaFin = item.FechaFin.ToString("MM/dd/yyyy"),
                            FechaCaptura = item.FechaCaptura.ToString("MM/dd/yyyy HH:mm tt"),
                            FechaCierre = item.FechaCierre.ToString("MM/dd/yyyy HH:mm tt"),
                            EstatusPeriodo = item.Estatus,
                            TipoConsecutivoId = item.TipoConsecutivoId,
                            Active = item.Active
                        });
                    }
                    DataSourceResult ok = lstPeriodosNomina.ToDataSourceResult(request);

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
        public ActionResult CreatePeriodoNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<PeriodoNominaViewModel> profiles, string FechaInicio, string FechaFin, string FechaCaptura, string FechaCierre)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int idAdmin = 0, res = 0;
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out idAdmin);
                    var CountryIdents = string.Empty;

                    foreach (var item in profiles)
                    {
                        if (!string.IsNullOrEmpty(item.NombrePeriodo))
                        {
                            CountryIdents = string.Empty;
                            foreach (var itemElement in item.LstCountryIdents) { CountryIdents += itemElement.Id + ","; }

                            CountryIdents = CountryIdents.TrimEnd(',');

                            context.CatPeriodosNominaSi(
                                item.AnioId, item.MesId,
                                item.PeriodicidadNominaId, item.ConsecutivoId,
                                item.TipoPeriodo,
                                (string.IsNullOrEmpty(FechaInicio) ? DateTime.Now : DateTime.Parse(FechaInicio)),
                                (string.IsNullOrEmpty(FechaFin) ? DateTime.Now : DateTime.Parse(FechaFin)),
                                (string.IsNullOrEmpty(FechaCaptura) ? DateTime.Now : DateTime.Parse(FechaCaptura)),
                                (string.IsNullOrEmpty(FechaCierre) ? DateTime.Now : Convert.ToDateTime(FechaCierre)),
                                CountryIdents,
                                item.NombrePeriodo,
                                idAdmin, resultado);
                        }
                    }

                    int.TryParse(resultado.Value.ToString(), out res);

                    switch (res)
                    {
                        case -1:
                            ModelState.AddModelError("error", "Existe un periodo de nomina con los mismos parametros");
                            break;
                        case -2:
                            ModelState.AddModelError("error", "Existe un periodo de nomina con el mismo nombre.");
                            break;
                        case -3:
                            ModelState.AddModelError("error", "Existe un periodo de nomina con el mismo nombre/parametro.");
                            break;
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
        public ActionResult UpdatePerdiodoNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<PeriodoNominaViewModel> profiles, string FechaInicio, string FechaFin, string FechaCaptura, string FechaCierre)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int idAdmin = 0, res = 0;
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out idAdmin);
                    var CountryIdents = string.Empty;

                    foreach (var item in profiles)
                    {
                        if (!string.IsNullOrEmpty(item.NombrePeriodo))
                        {
                            CountryIdents = string.Empty;
                            foreach (var itemElement in item.LstCountryIdents) { CountryIdents += (itemElement != null ? itemElement.Id + "," : item.CountryIdents); }
                            CountryIdents = CountryIdents.TrimEnd(',');

                            context.CatPeriodosNominaSu(
                                item.AnioId, item.MesId,
                                item.PeriodicidadNominaId, item.ConsecutivoId.ToString(),
                                item.TipoPeriodo,
                                (string.IsNullOrEmpty(FechaInicio) ? DateTime.Now.ToString() : FechaInicio),
                                (string.IsNullOrEmpty(FechaFin) ? DateTime.Now.ToString() :FechaFin),
                                (string.IsNullOrEmpty(FechaCaptura) ? DateTime.Now.ToString() : FechaCaptura),
                                (string.IsNullOrEmpty(FechaCierre) ? DateTime.Now.ToString() : FechaCierre),
                                CountryIdents,
                                item.NombrePeriodo,
                                idAdmin,
                                item.Active,
                                resultado);
                        }
                    }

                    int.TryParse(resultado.Value.ToString(), out res);

                    switch (res)
                    {
                        case -1:
                            ModelState.AddModelError("error", "Existe un periodo de nomina con el mismo nombre."); 
                            break;
                        case -2:
                            ModelState.AddModelError("error", "Existe un periodo de nomina con los mismos parametros");
                            break;
                        case -3:
                            ModelState.AddModelError("error", "Existe un periodo de nomina con el mismo nombre/parametro.");
                            break;
                    }

                    return Json(profiles.ToDataSourceResult(request, ModelState));

                }
            }
            catch (Exception exception)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(exception, usuario.UserInfo.Ident.Value);
                return Json(profiles.ToDataSourceResult(request, ModelState));
            }
        }

        public JsonResult GetFechasMes(int mesId, int anioId, string ConsecutivoId, string TipoPeriodo)
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
            catch (Exception ex)
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