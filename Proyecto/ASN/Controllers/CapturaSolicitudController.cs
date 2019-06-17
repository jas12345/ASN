﻿using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASN.CapturasRapidas.Controllers
{
    public class CapturaSolicitudController : Controller
    {
        // GET: CapturaSolicitud
        public ActionResult Index()
        {
            var obj = new CatSolicitudesSel_Result();
            obj.FolioSolicitud = 0;
            return View(obj);
        }

        public ActionResult GetSolicitudesRapidas([DataSourceRequest]DataSourceRequest request, int folioid)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.CatCargaRapidaSel(folioid).ToList();
                    DataSourceResult ok = lstSolicitudes.ToDataSourceResult(request);
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

        public ActionResult GetUserInfo(int ccms)
        {
            var emp = new CatEmployeeInfoSel_Result();
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    emp = context.CatEmployeeInfoSel(ccms).ToList().SingleOrDefault();
                }

                return Json(emp, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetEmpleadoPuesto(int Ident)
        {
            try
            {
                var lstEmpleadoPuesto = new List<CatEmpleadoPuestoSel_Result>();

                using (ASNContext context = new ASNContext())
                {
                    lstEmpleadoPuesto = context.CatEmpleadoPuestoSel(Ident).ToList();
                }

                return Json(lstEmpleadoPuesto, JsonRequestBehavior.AllowGet);
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

        public JsonResult GetConceptosCMB()
        {
            try
            {
                var listPeriodoNomina = new List<CatConceptosCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatConceptosCMB(0).OrderBy(x => x.Valor).ToList();
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

        public JsonResult GetMotivosCMB()
        {
            try
            {
                var listPeriodoNomina = new List<CatMotivoSolicitudCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatMotivoSolicitudCMB().OrderBy(x => x.Value).ToList();
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

        public JsonResult GetConceptosMotivosCMB()
        {
            try
            {
                var listPeriodoNomina = new List<CatConceptosMotivoCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatConceptosMotivoCMB().OrderBy(x => x.Valor).ToList();
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

        public JsonResult GetConceptoParametroConcepto(int conceptoIdent)
        {
            try
            {
                var lstConceptosParametroConceptos = new List<CatConceptosParametroConceptosSel_Result>();

                using (ASNContext context = new ASNContext())
                {
                    lstConceptosParametroConceptos = context.CatConceptosParametroConceptosSel(conceptoIdent).ToList();
                }

                return Json(lstConceptosParametroConceptos, JsonRequestBehavior.AllowGet);
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

        public ActionResult CreateSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int res = 0;
                    int ccmsidAdmin = 0;

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    ObjectParameter folioSolicitudOut = new ObjectParameter("FolioSolicitudOut", typeof(int));
                    resultado.Value = 0;
                    folioSolicitudOut.Value = 0;

                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.CatSolicitudesSi(
                          FolioSolicitud
                        , idAdmin
                        , folioSolicitudOut
                        , resultado);

                    int.TryParse(resultado.Value.ToString(), out res);
                    int.TryParse(folioSolicitudOut.Value.ToString(), out FolioSolicitud);

                    switch (res)
                    {
                        case -1:
                            ModelState.AddModelError("error", "Ya existe un registro para esta solicitud.");
                            break;
                    }

                    //return Json(profiles.ToDataSourceResult(request, ModelState));
                    //return Json(ModelState);

                    return Json(ModelState);
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(ModelState);
            }
        }

        public ActionResult CreateEmpleadoSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud, int Solicitante_Ident, int empleadoId, int perfil_Ident, Nullable<int> nivel)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int res = 0;

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    ObjectParameter folioSolicitudOut = new ObjectParameter("FolioSolicitudOut", typeof(int));
                    resultado.Value = 0;
                    folioSolicitudOut.Value = 0;

                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.CatSolicitudesSi(
                          FolioSolicitud
                        , idAdmin
                        , folioSolicitudOut
                        , resultado);

                    int.TryParse(resultado.Value.ToString(), out res);
                    int.TryParse(folioSolicitudOut.Value.ToString(), out FolioSolicitud);

                    switch (res)
                    {
                        case -1:
                            ModelState.AddModelError("error", "Ya existe un registro para esta solicitud.");
                            break;
                    }

                    //return Json(profiles.ToDataSourceResult(request, ModelState));
                    //return Json(ModelState);

                    return Json(ModelState);
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(ModelState);
            }
        }
    }
}