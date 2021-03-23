﻿using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASN.Controllers
{
    //[Authorize(Roles = "NOSEUSA")]
    [Authorize(Roles = "Responsable")]
    public class ResponsableAutorizaController : Controller
    {
        // GET: AutorizaSolicitud
        public ActionResult Index(int? FolioSolicitud)
        {
            var obj = new CatResponsabilidadesSel_Result();
            obj.FolioSolicitud = (int)(FolioSolicitud ?? -1);
            return View(obj);
            //return View();
        }

        public ActionResult GetResponsabilidades([DataSourceRequest]DataSourceRequest request, int FolioSolicitud)
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            int.TryParse(User.Identity.Name, out int idAdmin);

            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.CatResponsabilidadesSel(FolioSolicitud, idAdmin).ToList();
                    DataSourceResult ok = lstSolicitudes.ToDataSourceResult(request);
                    return Json(ok);
                }
            }
            catch (Exception ex)
            {                
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public PartialViewResult GetMontosResponsabilidades(int? FolioSolicitud, int? ResponsableIdent)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.CatMontosResponsabilidadesSel(FolioSolicitud, ResponsableIdent).ToList();
                    return PartialView("GetMontosResponsabilidades", lstSolicitudes);
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return PartialView("");
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

                int.TryParse(User.Identity.Name, out int solicitanteIdent);

                using (ASNContext context = new ASNContext())
                {
                    lstEmpleadoPuesto = context.CatEmpleadoPuestoSel(Ident, solicitanteIdent).ToList();
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
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(0,usuario.UserInfo.Ident.Value).ToList();
                }

                return Json(listPeriodoNomina, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
               
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        /// <summary>
        /// Método que devuelve todos los periodos de nomina cerrados para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPeriodoNominaCerradosCMB()
        {
            try
            {
                var listPeriodoCerradosNomina = new List<CatPeriodosNominaCerradosCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoCerradosNomina = context.CatPeriodosNominaCerradosCMB(1).ToList();
                }

                return Json(listPeriodoCerradosNomina, JsonRequestBehavior.AllowGet);
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
        /// Método que devuelve todos los periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetEmpleadosPerfilNivelAccesoCMB()
        {
            try
            {
                var listPeriodoNomina = new List<CatEmpleadosPerfilNivelAccesoSel_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatEmpleadosPerfilNivelAccesoSel(32).ToList();
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

        public JsonResult GetConceptosxEmpleadoxSolicitanteCMB(int ident, int Ident_Solicitante,string TipoNomina)
        {
            try
            {
                // Se asigna el Solicitante de la solicitud, no el usuario actual de la aplicación
                //int.TryParse(User.Identity.Name, out int ident_Solicitante);

                var listPeriodoNomina = new List<CatConceptosxEmpleadoxSolicitanteCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatConceptosxEmpleadoxSolicitanteCMB(ident, Ident_Solicitante, TipoNomina).OrderBy(x => x.Valor).ToList();
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
                    listPeriodoNomina = context.CatMotivoSolicitudCMB(0,0).OrderBy(x => x.Valor).ToList();
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
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var listPeriodoNomina = new List<CatConceptosMotivoCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatConceptosMotivoCMB(usuario.UserInfo.Ident.Value).OrderBy(x => x.Valor).ToList();
                }

                return Json(listPeriodoNomina, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
               
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetConceptoParametroConcepto(int conceptoIdent, string eid)
        {
            try
            {
                var lstConceptosParametroConceptos = new List<CatConceptosParametroConceptosSel_Result>();
                int employeeId = 0;

                using (ASNContext context = new ASNContext())
                {
                    if (int.TryParse(eid, out employeeId))
                    {
                        lstConceptosParametroConceptos = context.CatConceptosParametroConceptosSel(conceptoIdent,employeeId).ToList();
                    }
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

        public JsonResult ConsultarEstatusSolicitud(int folioSolicitud)
        {
            try
            {
                var lstEstatusSolicitud = new List<CatEstatusSolicitudSel_Result>();

                using (ASNContext context = new ASNContext())
                {
                    lstEstatusSolicitud = context.CatEstatusSolicitudSel(folioSolicitud).ToList();
                }

                return Json(lstEstatusSolicitud, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al consultar Estatus.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult ConsultarPeriodoNominaSolicitud(int folioSolicitud)
        {
            try
            {
                var lstPeriodoNominaSolicitud = new List<CatPeriodoNominaSolicitudSel_Result>();

                using (ASNContext context = new ASNContext())
                {
                    lstPeriodoNominaSolicitud = context.CatPeriodoNominaSolicitudSel(folioSolicitud).ToList();
                }

                return Json(lstPeriodoNominaSolicitud, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al consultar Periodo de Nomina.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        //public ActionResult EnviaSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud)
        //{
        //    try
        //    {
        //        using (ASNContext context = new ASNContext())
        //        {
        //            int res = 0;
        //            int ccmsidAdmin = 0;

        //            int.TryParse(User.Identity.Name, out ccmsidAdmin);

        //            context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

        //            ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
        //            //ObjectParameter folioSolicitudOut = new ObjectParameter("FolioSolicitudOut", typeof(int));
        //            resultado.Value = 0;
        //            //folioSolicitudOut.Value = 0;

        //            int.TryParse(User.Identity.Name, out int idAdmin);

        //            // EnviarSolicitud A Autorizadores
        //            context.EnviaSolicitud(FolioSolicitud, resultado);

        //            int.TryParse(resultado.Value.ToString(), out res);

        //            // 
        //            return Json(new { res }, JsonRequestBehavior.AllowGet);
        //        }
        //    }

        //    catch (Exception ex)
        //    {
        //        ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(ex, usuario.UserInfo.Ident.Value);
        //        return Json(new { res = -1 }, JsonRequestBehavior.AllowGet);
        //    }
        //}

        public ActionResult CancelaSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud)
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
                    //ObjectParameter folioSolicitudOut = new ObjectParameter("FolioSolicitudOut", typeof(int));
                    resultado.Value = 0;
                    //folioSolicitudOut.Value = 0;

                    int.TryParse(User.Identity.Name, out int idAdmin);

                    // EnviarSolicitud A Autorizadores
                    context.CancelaSolicitud(FolioSolicitud, resultado);

                    int.TryParse(resultado.Value.ToString(), out res);

                    // 
                    return Json(new { res }, JsonRequestBehavior.AllowGet);
                }
            }

            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(new { res = -1 }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult CierraSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud)
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
                    //ObjectParameter folioSolicitudOut = new ObjectParameter("FolioSolicitudOut", typeof(int));
                    resultado.Value = 0;
                    //folioSolicitudOut.Value = 0;

                    int.TryParse(User.Identity.Name, out int idAdmin);

                    // EnviarSolicitud A Autorizadores
                    context.CierraSolicitud(FolioSolicitud, idAdmin, resultado);

                    int.TryParse(resultado.Value.ToString(), out res);

                    // 
                    return Json(new { res }, JsonRequestBehavior.AllowGet);
                }
            }

            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(new { res = -1 }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult UpdateEmpleadoSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud, int Empleado_Ident, int ConceptoId, Nullable<decimal> ParametroConceptoMonto, Nullable<int> MotivosSolicitudId, bool Activo)
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
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.CatEmpleadosSolicitudesSu(
                          FolioSolicitud
                        , Empleado_Ident
                        , ConceptoId
                        , ParametroConceptoMonto
                        , MotivosSolicitudId
                        , Activo
                        , idAdmin
                        , resultado);

                    int.TryParse(resultado.Value.ToString(), out res);

                    return Json(new { FolioSolicitud, Empleado_Ident, res }, JsonRequestBehavior.AllowGet);

                    //return Json(new { Id = 0, type = "create", response = new { Errors = resultadoAccion } }, JsonRequestBehavior.AllowGet);

                }
            }

            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(new { FolioSolicitud, Empleado_Ident, res = 0 }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult ProcesaConcepto([DataSourceRequest]DataSourceRequest request, int FolioSolicitud, int Empleado_Ident, int ConceptoId, Nullable<int> NivelAutorizacion, int Accion)
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
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.CatSolicitudEmpleadosAutorizantesSu(
                          FolioSolicitud
                        , Empleado_Ident
                        , ConceptoId
                        , NivelAutorizacion
                        , idAdmin
                        , Accion
                        , idAdmin
                        , resultado);

                    int.TryParse(resultado.Value.ToString(), out res);

                    return Json(new { FolioSolicitud, Empleado_Ident, res }, JsonRequestBehavior.AllowGet);

                    //return Json(new { Id = 0, type = "create", response = new { Errors = resultadoAccion } }, JsonRequestBehavior.AllowGet);

                }
            }

            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(new { FolioSolicitud, Empleado_Ident, res = 0 }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult Async_SaveFiles(IEnumerable<HttpPostedFileBase> evidencias, int? folioSolicitud) //
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    string fullPath = Request.MapPath("~/Evidencias/");

                    //int folioSolicitud = -1;

                    //var obj = new CatSolicitudesSel_Result();
                    //folioSolicitud = obj.FolioSolicitud;

                    if (!System.IO.File.Exists(fullPath))
                    {
                        Directory.CreateDirectory(fullPath);
                    }

                    foreach (var item in evidencias)
                    {
                        if (item != null)
                        {   // s
                            var nombreArchivo = folioSolicitud.ToString() + "_" + DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + item.FileName;
                            item.SaveAs(fullPath + Path.GetFileName(nombreArchivo));
                        }
                    }

                    return Json(new { res = 1 }, JsonRequestBehavior.AllowGet);
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(new { res = -1 }, JsonRequestBehavior.AllowGet);

            }
        }

        //public ActionResult CreateEmpleadoSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud, int Empleado_Ident, int ConceptoId, decimal ParametroConceptoMonto, int conceptoMotivoId, int responsableId, int periododOriginalId)
        //{
        //    try
        //    {
        //        using (ASNContext context = new ASNContext())
        //        {
        //            int res = 0;

        //            context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

        //            ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
        //            ObjectParameter folioSolicitudOut = new ObjectParameter("FolioSolicitudOut", typeof(int));
        //            resultado.Value = 0;
        //            folioSolicitudOut.Value = 0;

        //            int.TryParse(User.Identity.Name, out int idAdmin);

        //            context.CatSolicitudesSi(
        //                  FolioSolicitud
        //                , idAdmin
        //                , Empleado_Ident
        //                , ConceptoId
        //                , ParametroConceptoMonto
        //                , conceptoMotivoId
        //                , responsableId
        //                , periododOriginalId
        //                , resultado);

        //            int.TryParse(resultado.Value.ToString(), out res);
        //            int.TryParse(folioSolicitudOut.Value.ToString(), out FolioSolicitud);

        //            switch (res)
        //            {
        //                case -1:
        //                    ModelState.AddModelError("error", "Ya existe un registro para esta solicitud.");
        //                    break;
        //            }

        //            //return Json(profiles.ToDataSourceResult(request, ModelState));
        //            //return Json(ModelState);

        //            return Json(ModelState);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(ex, usuario.UserInfo.Ident.Value);
        //        return Json(ModelState);
        //    }
        //}

        public PartialViewResult GetEvidencias(int? folio)
        {
            try
            {
                var dir = new DirectoryInfo(Server.MapPath("~/Evidencias/"));

                FileInfo[] files = dir.GetFiles("*.*");
                //.Where(x=> x.Name.Contains(Convert.ToString(folioSolicitud)));

                List<string> items = new List<string>();
                string folio_ = string.Format("{0}_", folio);
                foreach (var file in files)
                {
                    if (file.Name.StartsWith(folio_))
                    {
                        items.Add(file.Name);
                    }

                }

                return PartialView("GetEvidencias", items);
            }
            catch (Exception ex)
            {

                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return PartialView("");
            }

        }

        public FileResult DownLoadEvidencia(string EvidenciaFile)
        {
            var FileVirtualPath = "~/Evidencias/" + EvidenciaFile;

            return File(FileVirtualPath, "application/force- download", Path.GetFileName(FileVirtualPath));
        }
    }
}