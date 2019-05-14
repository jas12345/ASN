using ASN.Models;
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
using System.Web.Routing;

namespace ASN.Controllers
{
    public class SolicitudesController : Controller
    {
        // GET: Solicitudes
        public ActionResult Index()
        {
            return View();
        }

         public ActionResult Create()
        {
            return View();            
        }

        public ActionResult EditaSolicitud(string id)
        {
            return RedirectToAction("Editar","Solicitudes", id);//, new RouteValueDictionary( new { controller = "Solicitudes", action = "Editar", id = id }));
        }

        public ActionResult Editar(string id)
        {
            
                var modelo = new CatSolicitudesSel_Result();
                using (ASNContext context = new ASNContext())
                {
                    modelo = context.CatSolicitudesSel(int.Parse(id)).FirstOrDefault();
                }
                return View(modelo);
        }

        public ActionResult SelecionaEmpleadosSolicitud(string id, string perfil)
        {
            return RedirectToAction("SeleccionaPersonal", "Solicitudes", new { solicitudId= id, perfilId = perfil});//new RouteValueDictionary(new { controller = "Solicitudes", action = "Editar", id = id }));
        }

        public ActionResult SeleccionaPersonal(string solicitudId, string perfilId)
        {
            TempData["SolicitudId"] = solicitudId;
            TempData["PerfilId"] = perfilId;
            return View();
        }
        #region Métodos para carga de combos
        [HttpPost]
        public JsonResult GetSolicitudes([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.CatSolicitudesSel(0).ToList();
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
        /// <summary>
        /// Método que retorna un listado de los Perfiles activos
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPerfilCMB()
        {
            try
            {
                var lstCMB = new List<CatPerfilEmpleadosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatPerfilEmpleadosCMB(1).ToList();
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
        /// Método que devuelve todos los periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPeriodoNominaCMB(int filtra=0)
        {
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(filtra).ToList();
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

        public JsonResult GetConceptosCMB(string perfil)
        {
            try
            {
                var listConceptos = new List<CatConceptosCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    perfil = (string.IsNullOrEmpty(perfil) ? "0": perfil);
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listConceptos = context.CatConceptosCMB(int.Parse(perfil)).ToList();
                }

                return Json(listConceptos, JsonRequestBehavior.AllowGet);
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
        /// Método para obtener el listado de los conceptos de motivos
        /// </summary>
        /// <returns></returns>
        public JsonResult GetMotivoSolicitudCMB()
        {
            try
            {
                var listMotivos = new List<CatMotivoSolicitudCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listMotivos = context.CatMotivoSolicitudCMB().ToList();
                }

                return Json(listMotivos, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }
        #endregion

        [HttpPost]
        public JsonResult GetPerfil(string perfilId)
        {
            try
            {
                var perfil = new CatPerfilEmpleadosSel_Result();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstPerfil = context.CatPerfilEmpleadosSel(int.Parse(perfilId)).ToList();
                    perfil = lstPerfil.FirstOrDefault();
                }

                return Json(perfil, JsonRequestBehavior.AllowGet);
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
        /// Método que retorna todos los empleados relacionados con un perfil
        /// </summary>
        /// <param name="request"></param>
        /// <param name="perfil"></param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult GetEmployee([DataSourceRequest]DataSourceRequest request, string perfil, string solicitud)
        {
            try
            {
                var listPeriodoNomina = new List<SolicitudEmpleadosxPerfilSel_Result>();
                if (!string.IsNullOrEmpty(perfil))
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        listPeriodoNomina = context.SolicitudEmpleadosxPerfilSel(0,int.Parse(solicitud)).ToList();
                        DataSourceResult ok = listPeriodoNomina.ToDataSourceResult(request);

                        return Json(ok);
                    }
                }
                else
                {
                    return Json("");
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

        /// <summary>
        /// Método para crear la solicitud y los registros de CatEmpleadosSolicitudes
        /// </summary>
        /// <param name="request"></param>
        /// <param name="profiles"></param>
        /// <param name="listaEmpleados"></param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult CreateSolicitud([DataSourceRequest]DataSourceRequest request, CatSolicitudesSel_Result profiles, IEnumerable<HttpPostedFileBase> files, IEnumerable<HttpPostedFileBase> files2, string listaEmpleados)
        {
            try
            {
                var lista = new List<CargaMasivaRegistroViewModel>();
                int res = 0;
                var result = new object();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    int ccmsidAdmin = 0;
                   
                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);

                    if (profiles != null)
                    {
                        if (profiles.FolioSolicitud == 0)
                        {
                            context.CatSolicitudesSi(
                                profiles.FolioSolicitud,
                                profiles.Fecha_Solicitud,
                                profiles.Perfil_Ident,
                                profiles.Solicitante_Ident,
                                profiles.Solicintante_Nombre,
                                profiles.Puesto_solicitante_Ident,
                                profiles.PeriodoNomina_Id,
                                profiles.ConceptoId,
                                profiles.MotivoId,
                                profiles.Justficacion,
                                profiles.Responsable_Id,
                                profiles.Detalle,
                                profiles.PeriodoNominaOriginal_Id,
                                profiles.Autorizantes,
                                listaEmpleados,
                                ccmsidAdmin,
                                resultado);
                        }
                    }

                    var lstResultado = resultado.Value.ToString().Split('_');
                    int.TryParse(lstResultado[0], out res);
                    var resultadoAccion = "";
                    int SolicitudId = 0;
                    object Error = null;

                    if (res != -1)
                    {
                        if (files != null)
                        {
                            GuardaArchivos(lstResultado[1].ToString(), files, ccmsidAdmin);
                        }
                        if (files2 != null)
                        {
                            lista = Save(files2, int.Parse(lstResultado[1].ToString()), ccmsidAdmin);
                        }
                    }

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

                    result = new { Id = SolicitudId, type = "create", responseError = Error, listaEmpleados = lista, status = res.ToString() };
                }
                return Json(result,JsonRequestBehavior.AllowGet);// (profiles.ToDataSourceResult(request, ModelState)); //(profiles);//

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
                //return Json(profiles.ToDataSourceResult(request, ModelState));
                return Json(new { Id = 0, type = "create", responseError = new { Errors = resultadoAccion }, listaEmpleados ="", status ="-1" }, JsonRequestBehavior.AllowGet);
            }
            //return View(profiles);
        }

        [HttpPost]
        public JsonResult EditaSolicitud([DataSourceRequest]DataSourceRequest request, CatSolicitudesSel_Result profiles, IEnumerable<HttpPostedFileBase> files, IEnumerable<HttpPostedFileBase> files2, string listaEmpleados)
        {
            try
            {
                var lista = new List<CargaMasivaRegistroViewModel>();
                int res = 0;
                var result = new object();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    int ccmsidAdmin = 0;

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);

                    if (profiles != null)
                    {
                        if (profiles.FolioSolicitud != 0)
                        {
                            context.CatSolicitudesSu(
                                profiles.FolioSolicitud,
                                DateTime.Now,
                                profiles.Perfil_Ident,
                                profiles.Solicitante_Ident,
                                profiles.Solicintante_Nombre,
                                profiles.Puesto_solicitante_Ident,
                                profiles.PeriodoNomina_Id,
                                profiles.PeriodoNominaOriginal_Id,
                                profiles.ConceptoId,
                                profiles.MotivoId,
                                profiles.Justficacion,
                                profiles.Responsable_Id,
                                profiles.Detalle,
                                profiles.Autorizantes,
                                resultado,
                                ccmsidAdmin
                                );
                        }
                    }

                    var lstResultado = resultado.Value.ToString().Split('_');
                    int.TryParse(lstResultado[0], out res);
                    var resultadoAccion = "";
                    int SolicitudId = profiles.FolioSolicitud;
                    object Error = null;

                    if (res != -1)
                    {
                        if (files != null)
                        {
                            GuardaArchivos(SolicitudId.ToString(), files, ccmsidAdmin);
                        }
                        if (files2 != null)
                        {
                            lista = Save(files2, SolicitudId, ccmsidAdmin);
                        }
                    }

                    if (res == -1)
                    {
                        resultadoAccion = "Ya existe un concepto con la misma descripción.";
                        Error = new { Errors = resultadoAccion };
                        ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                    }

                    result = new { Id = SolicitudId, type = "create", responseError = Error, listaEmpleados = lista, status = res.ToString() };
                }
                return Json(result, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
                //return Json(profiles.ToDataSourceResult(request, ModelState));
                return Json(new { Id = 0, type = "create", responseError = new { Errors = resultadoAccion }, listaEmpleados = "", status = "-1" }, JsonRequestBehavior.AllowGet);
            }
        }

        public List<CargaMasivaRegistroViewModel> Save(IEnumerable<HttpPostedFileBase> files, int solicitudid, int useremployeeid)
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
                                        context.ProcesaSolicitudEmpleados(obj.solicitudId,obj.catEmployeeId,string.Empty,obj.userEmployeeId,string.Empty,obj.parametro,obj.detalle,resultado);
                                        //context.CatEmpleadosSolicitudesSi(obj.solicitudId, obj.catEmployeeId,);
                                        // context.CatSolicitudEmpleadosDetalleMasivoSi(obj.solicitudId, obj.catEmployeeId, obj.detalle, obj.userEmployeeId, resultado);// obj.parametro,
                                        obj.estatus = resultado.Value.ToString();

                                    }
                                }
                            }
                        }
                    }
                }

                return lista;
            }
            catch (Exception e)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(e, usuario.UserInfo.Ident.Value);

                var lista = new List<CargaMasivaRegistroViewModel>();
                return lista;
            }
        }

        public string GuardaArchivos(string solicitudId, IEnumerable<HttpPostedFileBase> files, int useremployeeid)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    string fullPath = Request.MapPath("~/Evidencias/");
                    if (!System.IO.File.Exists(fullPath))
                    {
                        ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                        resultado.Value = 0;

                        Directory.CreateDirectory(fullPath);
                        foreach (var item in files)
                        {
                            if (item != null)
                            {
                                var nombreArchivo = DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + item.FileName;
                                item.SaveAs(fullPath + Path.GetFileName(nombreArchivo));

                                context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                                context.CatSolicitudesArchivosSi(int.Parse(solicitudId), nombreArchivo, useremployeeid, resultado);
                            }

                        }
                    }

                    return "Ok";
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return "Error";

            }
        }

        [HttpPost]
        public JsonResult GuardaEmpleados([DataSourceRequest]DataSourceRequest request, string solicitud, string listaEmpleados)
        {
            try
            {
                int res = 0;
                var result = new object();
                var resultadoAccion = "";
                if (!string.IsNullOrEmpty(listaEmpleados))
                {
                    object Error = null;

                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        int ccmsidAdmin = 0;

                        ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                        resultado.Value = 0;

                        int.TryParse(User.Identity.Name, out ccmsidAdmin);
                        context.ProcesaSolicitudEmpleados(int.Parse(solicitud),0,string.Empty,ccmsidAdmin,listaEmpleados,0,string.Empty,resultado);

                        int.TryParse(resultado.Value.ToString(), out res);

                        if (res == -1)
                        {
                            resultadoAccion = "Ya existe un concepto con la misma descripción.";
                            Error = new { Errors = resultadoAccion };
                            ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                        }
                    }

                    result = new { Id = solicitud, responseError = Error, status = res.ToString() };
                }
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
                return Json(new { Id = 0, responseError = new { Errors = resultadoAccion }, status = "-1" }, JsonRequestBehavior.AllowGet);
            }
        }

        public JsonResult EnviarSolicitud([DataSourceRequest]DataSourceRequest request, string solicitud)
        {
            try
            {
                var lista = new List<CargaMasivaRegistroViewModel>();
                int res = 0;
                var result = new object();

                using (ASNContext context = new ASNContext())
                {
                    object Error = null;

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    int ccmsidAdmin = 0;

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 1;

                    var resultadoValidacion = context.ValidaSolicitud(int.Parse(solicitud),resultado);

                    int.TryParse(resultado.Value.ToString(), out res);

                    if (res == 0)
                    {
                        int.TryParse(resultado.Value.ToString(), out res);

                        if (res == 0)
                        {
                            int.TryParse(User.Identity.Name, out ccmsidAdmin);
                            context.CatSolicitudesSu(int.Parse(solicitud), DateTime.Now, 0, 0, string.Empty, 0, string.Empty, string.Empty, 0, 0, string.Empty, 0, 0, string.Empty, resultado, ccmsidAdmin);

                            var resultadoAccion = "";
                            if (res == -1)
                            {
                                resultadoAccion = "Ocurrio un problema durante la actualización de la solicitud. Intente más tarde.";
                                Error = new { Errors = resultadoAccion };
                            }
                            else
                            {
                                var listadoAutorizadores = context.CatSolicitudEmpleadosAutorizantesSel(int.Parse(solicitud)).ToList();
                                var correos = string.Empty;
                                foreach (var item in listadoAutorizadores)
                                {
                                    if (!string.IsNullOrEmpty(item.EmailManager))
                                    {
                                        correos += item.EmailManager + ";";
                                    }
                                }

                                correos = correos.Substring(0, correos.Length - 1);

                                MailHelper mail = new MailHelper();
                                mail.IsBodyHtml = true;
                                mail.RecipientCCO = correos;//emails.EmailTo; mail.RecipientCC = emails.EmailCC;
                                mail.Subject = "Notificación de Nueva Solicitud";
                                //mail.AttachmentFile = Server.MapPath("~/Content/images/logo.png");
                                mail.Body = RenderPartialView.RenderPartialViewToString(this, "~\\Views\\Shared\\Mail\\NoticacionSolicitud.cshtml", null);
                                mail.Send();
                            }
                        }
                    }

                    result = new { Id = solicitud, type = "create", responseError = Error, listaEmpleados = lista, status = res.ToString() };
                }

                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch (Exception  ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
                return Json(new { Id = 0, type = "create", responseError = new { Errors = resultadoAccion }, status = "-1" }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}