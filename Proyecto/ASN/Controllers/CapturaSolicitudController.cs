﻿using ASN.Models;
using CsvHelper;
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
    [Authorize(Roles = "Solicitante")]
    public class CapturaSolicitudController : Controller
    {
        // GET: CapturaSolicitud
        public ActionResult Index(int? FolioSolicitud)
        {
            if (User.Identity.IsAuthenticated)
            {
                var obj = new CatSolicitudesSel_Result();
                obj.FolioSolicitud = (int)(FolioSolicitud ?? -1);
                return View(obj);
            }
            else
            {
                return RedirectToAction("Login", "Home");
            }

            //return View();
        }

        public ActionResult GetSolicitudes([DataSourceRequest]DataSourceRequest request, int FolioSolicitud)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.CatSolicitudesSel(FolioSolicitud).ToList();
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


        public JsonResult GetAutorizadores(int FolioSolicitud, int Conceptoid, int Empleado_Ident)
        {
            try
            {
                var lstEmpleadoAutorizantes = new List<CatSolicitudAutorizantesSel_Result>();

                //int.TryParse(User.Identity.Name, out int solicitanteIdent);

                using (ASNContext context = new ASNContext())
                {
                    lstEmpleadoAutorizantes = context.CatSolicitudAutorizantesSel(FolioSolicitud, Conceptoid, Empleado_Ident).ToList();
                }

                return Json(lstEmpleadoAutorizantes, JsonRequestBehavior.AllowGet);
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
        public JsonResult GetPeriodoNominaCMB(int? active)
        {
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(active).ToList();
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
        public JsonResult GetEmpleadosPerfilAutorizadoresCMB(string EmpleadoIdent, string ConceptoId)
        {
            try
            {
                var listPeriodoNomina = new List<AutorizadoresxEmpleadoxConceptoCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.AutorizadoresxEmpleadoxConceptoCMB(int.Parse(EmpleadoIdent), int.Parse(ConceptoId)).ToList();
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

        public JsonResult GetConceptosxEmpleadoxSolicitanteCMB(int ident)
            {
            try
            {
                int.TryParse(User.Identity.Name, out int ident_Solicitante);

                var listPeriodoNomina = new List<CatConceptosxEmpleadoxSolicitanteCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatConceptosxEmpleadoxSolicitanteCMB(ident, ident_Solicitante).OrderBy(x => x.Valor).ToList();
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
                    listPeriodoNomina = context.CatMotivoSolicitudCMB().OrderBy(x => x.Valor).ToList();
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
                    resultado.Value = 0;

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

        public ActionResult CancelaEmpleadoSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud, int Empleado_Ident, int ConceptoId)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    //int res = 0;
                    //int ccmsid = 0;
                    //int.TryParse(User.Identity.Name, out ccmsid);
                    MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    context.ActualizaEstatusConcepto(FolioSolicitud, Empleado_Ident, ConceptoId, "C", usuario.UserInfo.Ident.Value);

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

        public JsonResult Save(IEnumerable<HttpPostedFileBase> files, int solicitudid, int useremployeeid)
        {
            try
            {
                int solicitudId = solicitudid;
                int userEmployeeId = useremployeeid;
                int ccmsId = 0;
                int parametro = 0;
                string detalle = string.Empty;

                ObjectParameter resultado = new ObjectParameter("Estatus", typeof(string));
                resultado.Value = String.Empty;

                var lista = new List<CargaMasivaRegistroViewModel>();

                if (files != null)
                {
                    foreach (var file in files)
                    {
                        if (file != null)
                        {
                            var fileName = Path.GetFileName(file.FileName);
                            var ext = Path.GetExtension(fileName);

                            if (ext.ToUpper() == ".CSV")
                            {
                                var postedFile = file;

                                if (postedFile.ContentLength > 0)
                                {

                                    using (var csvReader = new StreamReader(postedFile.InputStream))
                                    {

                                        using (var csv = new CsvReader(csvReader))
                                        {

                                            while (csv.Read())
                                            {
                                                var objeton = new CargaMasivaRegistroViewModel();

                                                if (csv.TryGetField(0, out ccmsId) && csv.TryGetField(1, out parametro) && csv.TryGetField(2, out detalle))
                                                {
                                                    objeton.parametro = parametro;
                                                    objeton.detalle = detalle;
                                                    objeton.solicitudId = solicitudId;
                                                    objeton.userEmployeeId = userEmployeeId;
                                                    objeton.catEmployeeId = ccmsId;
                                                    objeton.estatus = string.Empty;

                                                    lista.Add(objeton);
                                                }
                                            }
                                        }
                                    }
                                }


                                using (ASNContext context = new ASNContext())
                                {

                                    foreach (var obj in lista)
                                    {
                                        if (obj.solicitudId == -1) {
                                            obj.solicitudId = solicitudId;
                                        }
                                        context.ProcesaSolicitudEmpleados(obj.solicitudId, obj.catEmployeeId, string.Empty, obj.userEmployeeId, string.Empty, obj.parametro, obj.detalle, resultado);
                                        //context.CatEmpleadosSolicitudesSi(obj.solicitudId, obj.catEmployeeId,);
                                        // context.CatSolicitudEmpleadosDetalleMasivoSi(obj.solicitudId, obj.catEmployeeId, obj.detalle, obj.userEmployeeId, resultado);// obj.parametro,
                                        obj.estatus = resultado.Value.ToString();

                                    }
                                }
                            }
                        }
                    }
                }

                return Json(new { res = 1 }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(e, usuario.UserInfo.Ident.Value);

                return Json(new { res = -1 }, JsonRequestBehavior.AllowGet);
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

        public JsonResult GetConceptoParametroConcepto(int conceptoIdent, string eid)
        {
            try
            {
                var lstConceptosParametroConceptos = new List<CatConceptosParametroConceptosSel_Result>();
                int employeeId = 0;

                using (ASNContext context = new ASNContext())
                {
                    if (int.TryParse(eid,out employeeId))
                    {
                        lstConceptosParametroConceptos = context.CatConceptosParametroConceptosSel(conceptoIdent, employeeId).ToList();
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

        public ActionResult CreateSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud, int Empleado_Ident, int ConceptoId, string PeriodoNomina_Id, decimal ParametroConceptoMonto, int MotivosSolicitudId, Nullable<int> conceptoMotivoId, Nullable<int> responsableId, Nullable<int> periododOriginalId, Nullable<int> autorizadorNivel1, Nullable<int> autorizadorNivel2, Nullable<int> autorizadorNivel3, Nullable<int> autorizadorNivel4, Nullable<int> autorizadorNivel5, Nullable<int> autorizadorNivel6, Nullable<int> autorizadorNivel7, Nullable<int> autorizadorNivel8, Nullable<int> autorizadorNivel9)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int res = 0;
                    int ccmsidAdmin = 0;
                    int periodoNominaId = 0;

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);
                    int.TryParse(PeriodoNomina_Id, out periodoNominaId);

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    ObjectParameter folioSolicitudOut = new ObjectParameter("FolioSolicitudOut", typeof(int));
                    resultado.Value = 0;
                    folioSolicitudOut.Value = 0;

                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.CatSolicitudesSi(
                          FolioSolicitud
                        , Empleado_Ident
                        , ConceptoId
                        , ParametroConceptoMonto
                        , MotivosSolicitudId
                        , conceptoMotivoId
                        , responsableId
                        , periododOriginalId
                        , autorizadorNivel1
                        , autorizadorNivel2
                        , autorizadorNivel3
                        , autorizadorNivel4
                        , autorizadorNivel5
                        , autorizadorNivel6
                        , autorizadorNivel7
                        , autorizadorNivel8
                        , autorizadorNivel9
                        , periodoNominaId
                        , true//active
                        , idAdmin
                        , folioSolicitudOut
                        , resultado);

                    var lstResultado = resultado.Value.ToString().Split('_');
                    int.TryParse(lstResultado[0], out res);
                    var resultadoAccion = "";
                    int SolicitudId = 0;
                    object Error = null;

                    //////if (FolioSolicitud != -1)
                    //////{
                    //////     if (files2 != null)
                    //////    {
                    //////        lista = Save(files2, int.Parse(lstResultado[1].ToString()), ccmsidAdmin);
                    //////    }
                    //////}

                    if (res == -1)
                    {
                        resultadoAccion = "Ya existe un concepto con la misma descripción.";
                        Error = new { Errors = resultadoAccion };
                        ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                    }
                    else
                    {
                        if (lstResultado.Length > 1)
                        {
                            SolicitudId = int.Parse(lstResultado[1].ToString());
                        }
                    }

                    ///result = new { Id = SolicitudId, type = "create", responseError = Error, listaEmpleados = lista, status = res.ToString() };


                    int.TryParse(resultado.Value.ToString(), out res);
                    int.TryParse(folioSolicitudOut.Value.ToString(), out FolioSolicitud);

                    //TODO: Guardar 
                    
                    return Json(new { FolioSolicitud, res }, JsonRequestBehavior.AllowGet);                    
                }
            }

            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(new { FolioSolicitud, res = 0 }, JsonRequestBehavior.AllowGet);
            }
        }

        public ActionResult EnviaSolicitud([DataSourceRequest]DataSourceRequest request, int FolioSolicitud)
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
                    context.EnviaSolicitud(FolioSolicitud, resultado);

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

        public JsonResult GetNivelesAutorizacionxEmpleadoxConcepto(int EmpleadoIdent, int ConceptoId, string folioId)
        {
            try
            {
                var lstAutorizadoresxEmpleadoxConcepto = new List<NivelesAutorizacionxEmpleadoxConcepto_Result>();
                int foliId = 0;

                using (ASNContext context = new ASNContext())
                {
                    if(int.TryParse(folioId,out foliId))
                    {
                        lstAutorizadoresxEmpleadoxConcepto = context.NivelesAutorizacionxEmpleadoxConcepto(EmpleadoIdent, ConceptoId, foliId).ToList();
                    }
                }

                return Json(lstAutorizadoresxEmpleadoxConcepto, JsonRequestBehavior.AllowGet);
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

        //public ActionResult Right_To_Left_Support()
        //{
        //    return View();
        //}

        public ActionResult Async_Save(IEnumerable<HttpPostedFileBase> files)
        {
            // The Name of the Upload component is "files"
            if (files != null)
            {
                foreach (var file in files)
                {
                    // Some browsers send file names with full path.
                    // We are only interested in the file name.
                    var fileName = Path.GetFileName(file.FileName);
                    var physicalPath = Path.Combine(Server.MapPath("~/App_Data"), fileName);

                    // The files are not actually saved in this demo
                    file.SaveAs(physicalPath);
                }
            }





            try
            {
                int solicitudId = 0;
                int userEmployeeId = useremployeeid;
                int ccmsId = 0;
                int parametro = 0;
                string detalle = string.Empty;

                ObjectParameter resultado = new ObjectParameter("Estatus", typeof(string));
                resultado.Value = String.Empty;

                var lista = new List<CargaMasivaRegistroViewModel>();

                if (files != null)
                {
                    foreach (var file in files)
                    {
                        if (file != null)
                        {
                            var fileName = Path.GetFileName(file.FileName);
                            var ext = Path.GetExtension(fileName);

                            if (ext.ToUpper() == ".CSV")
                            {
                                var postedFile = file;

                                if (postedFile.ContentLength > 0)
                                {

                                    using (var csvReader = new StreamReader(postedFile.InputStream))
                                    {

                                        using (var csv = new CsvReader(csvReader))
                                        {

                                            while (csv.Read())
                                            {
                                                var objeton = new CargaMasivaRegistroViewModel();

                                                if (csv.TryGetField(0, out ccmsId) && csv.TryGetField(1, out parametro) && csv.TryGetField(2, out detalle))
                                                {
                                                    objeton.parametro = parametro;
                                                    objeton.detalle = detalle;
                                                    objeton.solicitudId = solicitudId;
                                                    objeton.userEmployeeId = userEmployeeId;
                                                    objeton.catEmployeeId = ccmsId;
                                                    objeton.estatus = string.Empty;

                                                    lista.Add(objeton);
                                                }
                                            }
                                        }
                                    }
                                }


                                using (ASNContext context = new ASNContext())
                                {

                                    foreach (var obj in lista)
                                    {
                                        if (obj.solicitudId == -1)
                                        {
                                            obj.solicitudId = solicitudId;
                                        }
                                        context.ProcesaSolicitudEmpleados(obj.solicitudId, obj.catEmployeeId, string.Empty, obj.userEmployeeId, string.Empty, obj.parametro, obj.detalle, resultado);
                                        //context.CatEmpleadosSolicitudesSi(obj.solicitudId, obj.catEmployeeId,);
                                        // context.CatSolicitudEmpleadosDetalleMasivoSi(obj.solicitudId, obj.catEmployeeId, obj.detalle, obj.userEmployeeId, resultado);// obj.parametro,
                                        obj.estatus = resultado.Value.ToString();

                                    }
                                }
                            }
                        }
                    }
                }

                return Json(new { res = 1 }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(e, usuario.UserInfo.Ident.Value);

                return Json(new { res = -1 }, JsonRequestBehavior.AllowGet);
            }





            // Return an empty string to signify success
            //return Content("");
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
    }
}