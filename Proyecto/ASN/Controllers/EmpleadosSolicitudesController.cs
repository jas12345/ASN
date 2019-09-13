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
    [Authorize(Roles = "NOSEUSA")]
    public class EmpleadosSolicitudesController : Controller
    {
        // GET: EmpleadosSolicitudes
        public ActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Método que retorna el grid de CatEmpleadosSolicitudes
        /// </summary>
        /// <param name="id">Solicitud Id</param>
        /// <param name="perfilId">Perfil Id</param>
        /// <returns></returns>
        public PartialViewResult MuestraEmpleados(string id, string perfilId)
        {
            if (!string.IsNullOrEmpty(id))
            {
                ViewBag.SolicitudBaseId = id;
                ViewBag.perfilId = perfilId;//TempData["PerfilId"] 
                if (User.Identity.IsAuthenticated)
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        ViewData["ConceptoMotivo"] = context.CatConceptosMotivoCMB().ToList();
                        ViewData["PeriodosNomina"] = context.CatPeriodosNominaCMB(0).ToList();
                    }
                }
            }
            
            return PartialView("GridEmpleados");
        }

        public PartialViewResult GridEmpleadosAutorizantes(string id, string perfil)
        {
            ViewBag.SolicitudBaseId = id;
            return PartialView("GridEmpleadosAutorizantes");
        }

        /// <summary>
        /// Método que retorna los registros de llenado del grid
        /// </summary>
        /// <param name="request"></param>
        /// <param name="SolicitudId"></param>
        /// <returns></returns>
        public JsonResult GetEmpleadosSolicitudesSel([DataSourceRequest]DataSourceRequest request,string SolicitudId)
        {
            try
            {
                var listEmpleadosSolicitudes = new List<CatEmpleadosSolicitudesSel_Result>();
                var lstEmpleadosSolicitud = new List<EmpleadosSolicitudesViewModel>();

                    using (ASNContext context = new ASNContext())
                    {
                        SolicitudId = (string.IsNullOrEmpty(SolicitudId) && !string.IsNullOrEmpty(ViewBag.SolicitudBaseId) ? ViewBag.SolicitudBaseId : SolicitudId);
                        int i = 0;
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        listEmpleadosSolicitudes = context.CatEmpleadosSolicitudesSel(((Int32.TryParse(SolicitudId, out i) ? i : (int?)null))).ToList();

                    //Cambiamos la información de modelo para poder trabajar con el multiselect.
                    foreach (var item in listEmpleadosSolicitudes)
                    {
                        var lstConceptos = new List<selectModelConceptoMotivo>();
                        if (item.CatConceptoMotivoId != null)
                        {
                            lstConceptos.Add(new selectModelConceptoMotivo() { Ident = int.Parse(item.CatConceptoMotivoId), Valor = item.ConceptoMotivo });
                        }

                        lstEmpleadosSolicitud.Add(new EmpleadosSolicitudesViewModel()
                        {
                            FolioSolicitud = item.FolioSolicitud,
                            Empleado_Ident = item.Empleado_Ident,
                            Empleado_First_Name = item.Empleado_First_Name,
                            Empleado_Middle_Name = item.Empleado_Middle_Name,
                            Empleado_Last_Name = item.Empleado_Last_Name,
                            Empleado_Position_Code_Ident = item.Empleado_Position_Code_Ident,
                            Empleado_Position_Code_Title = item.Empleado_Position_Code_Title,
                            Empleado_Contract_Type_Ident = item.Empleado_Contract_Type_Ident,
                            Empleado_Contract_Type = item.Empleado_Contract_Type,
                            Manager_Ident = item.Manager_Ident,
                            Manager_First_Name = item.Manager_First_Name,
                            Manager_Last_Name = item.Manager_Last_Name,
                            Manager_Middle_Name = item.Manager_Middle_Name,
                            Manager_Position_Code_Ident = item.Manager_Position_Code_Ident,
                            Manager_Position_Code_Title = item.Manager_Position_Code_Title,
                            Manager_Contract_Type_Ident = item.Manager_Contract_Type_Ident,
                            Manager_Contract_Type = item.Manager_Contract_Type,
                            CatConceptoMotivoId = item.CatConceptoMotivoId,
                            ConceptoMotivo = item.ConceptoMotivo,
                            LstConceptoMotivo = lstConceptos,
                            ParametroConceptoMonto = item.ParametroConceptoMonto,
                            Detalle = item.Detalle,
                            PeriodoNomina = item.PeriodoNomina,
                            Active = item.Active
                        });
                    }

                        DataSourceResult ok = lstEmpleadosSolicitud.ToDataSourceResult(request);

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

        public JsonResult GridEmpleadosAutorizantesSel([DataSourceRequest]DataSourceRequest request, string SolicitudId)
        {
            try
            {
                var listEmpleadosAutorizante = new List<CatSolicitudEmpleadosAutorizantesSel_Result>();
                using (ASNContext context = new ASNContext())
                {
                    SolicitudId = (string.IsNullOrEmpty(SolicitudId) && !string.IsNullOrEmpty(ViewBag.SolicitudBaseId) ? ViewBag.SolicitudBaseId : SolicitudId);
                    int i = 0;
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listEmpleadosAutorizante = context.CatSolicitudEmpleadosAutorizantesSel(((Int32.TryParse(SolicitudId, out i) ? i : (int?)null))).ToList();

                    DataSourceResult ok = listEmpleadosAutorizante.ToDataSourceResult(request);
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
                    listPeriodoNomina = context.CatPeriodosNominaCMB(0).ToList();
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
        /// Método que retorna todos los empleados que pueden ser responsables de alguna solicitud de motivo de concepto
        /// </summary>
        /// <returns></returns>
        public JsonResult GetEmpleadosCMB()
        {
            try
            {
                var listEmpleados = new List<CatEmpleadosPerfilEmpleadosCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    TempData["PerfilId"] = (!string.IsNullOrEmpty(TempData["PerfilId"].ToString()) ? TempData["PerfilId"] :0);
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listEmpleados = context.CatEmpleadosPerfilEmpleadosCMB(int.Parse(TempData["PerfilId"].ToString())).ToList();
                }

                return Json(listEmpleados, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetAutorizanteXperfilCMB(string perfilBase)
        {
            try
            {
                var listEmpleados = new List<AutorizadoresxPerfilSolicitanteCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listEmpleados = context.AutorizadoresxPerfilSolicitanteCMB((!string.IsNullOrEmpty(perfilBase) ? int.Parse(perfilBase) : 0)).ToList();
                }

                return Json(listEmpleados, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public ActionResult CreateSolicitudEmpleadosDetalle([DataSourceRequest] DataSourceRequest request, EmpleadosSolicitudesViewModel profiles,
            string TTConceptoMotivoId, string TTManager_Ident, string TTMonto, string TTDetalleId, string TTPeriodoNomina)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    int ccmsidAdmin = 0, res = 0;
                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;
                    var ConceptosMotivos = string.Empty;

                    
                        if (profiles.LstConceptoMotivo.Count() > 0)
                        {
                            ConceptosMotivos = string.Empty;
                            foreach (var itemElement in profiles.LstConceptoMotivo) { ConceptosMotivos += itemElement.Ident + ","; }

                        }
                        ConceptosMotivos = ConceptosMotivos.TrimEnd(',');

                        int.TryParse(User.Identity.Name, out ccmsidAdmin);

                        foreach (var element in profiles.LstConceptoMotivo)
                        {
                            context.CatSolicitudEmpleadosDetalleSi(
                            profiles.FolioSolicitud, profiles.Empleado_Ident,
                            element.Ident, profiles.PeriodoNomina,
                            profiles.Manager_Ident, profiles.ParametroConceptoMonto, profiles.Detalle,
                            (!string.IsNullOrEmpty(TTConceptoMotivoId) && TTConceptoMotivoId  == "true" ?  true: false),
                            (!string.IsNullOrEmpty(TTManager_Ident) && TTManager_Ident == "true" ? true : false),
                            (!string.IsNullOrEmpty(TTMonto) && TTMonto =="true"?  true : false),
                            (!string.IsNullOrEmpty(TTDetalleId) && TTDetalleId  == "true" ? true : false),
                            (!string.IsNullOrEmpty(TTPeriodoNomina) && TTPeriodoNomina == "true"? true : false),
                            ccmsidAdmin, resultado);
                        }

                 
                    int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                    }

                    return Json("Ok");//(profiles.ToDataSourceResult(request, ModelState));
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
                //return Json(profiles.ToDataSourceResult(request, ModelState));
                return Json(new { Id = 0, type = "create", response = new { Errors = resultadoAccion } }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Actualiza los registros de la tabla SolicitudEmpleadosDetalle
        /// </summary>
        /// <param name="request"></param>
        /// <param name="model"></param>
        /// <param name="TTConceptoMotivoId">Check para determinar si aplica a todos los empleados relacionados con la solicitud</param>
        /// <param name="TTManager_Ident">Check para determinar si aplica a todos los empleados relacionados con la solicitud</param>
        /// <param name="TTMonto">Check para determinar si aplica a todos los empleados relacionados con la solicitud</param>
        /// <param name="TTDetalle">Check para determinar si aplica a todos los empleados relacionados con la solicitud</param>
        /// <param name="TTPeriodoNomina">Check para determinar si aplica a todos los empleados relacionados con la solicitud</param>
        /// <returns></returns>
        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult UpdateSolicitudEmpleadosDetalle([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<EmpleadosSolicitudesViewModel> profiles, 
            string TTConceptoMotivoId, string TTManager_Ident, string TTMonto, string TTDetalle, string TTPeriodoNomina)
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
                    foreach (var item in profiles)
                    {
                        context.CatSolicitudEmpleadosDetalleSu(
                        item.FolioSolicitud, item.Empleado_Ident,
                        item.CatConceptoMotivoId, item.Manager_Ident,
                        //item.ParametroConceptoMonto, item.Detalle,
                        item.PeriodoNomina, item.Active,
                        (string.IsNullOrEmpty(TTConceptoMotivoId) || TTConceptoMotivoId == "false" ? false : true),
                        (string.IsNullOrEmpty(TTManager_Ident) || TTManager_Ident == "false" ? false : true),
                        (string.IsNullOrEmpty(TTMonto) || TTMonto == "false" ? false : true),
                        (string.IsNullOrEmpty(TTDetalle) || TTDetalle == "false" ? false : true),
                        (string.IsNullOrEmpty(TTPeriodoNomina) || TTPeriodoNomina == "false" ? false : true),
                        ccmsidAdmin, resultado);
                }

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
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
                //var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
                return Json(profiles.ToDataSourceResult(request, ModelState));
               // return Json(new { Id = 0, type = "create", response = new { Errors = resultadoAccion } }, JsonRequestBehavior.AllowGet);
            }
        }

        /// <summary>
        /// Método para guardar los autorizadores de cada empleado
        /// </summary>
        /// <param name="request"></param>
        /// <param name="profiles"></param>
        /// <param name="solicitud"></param>
        /// <param name="Autorizador_Id"></param>
        /// <returns></returns>
        public ActionResult UpdateAutorizantesEmpleado([DataSourceRequest] DataSourceRequest request, CatSolicitudEmpleadosAutorizantesSel_Result profiles, string solicitud, string Autorizador_Id, 
            string TTAutorizador_Ident, string TTNivelAutorizacion, string TTMontoAutorizacionAutomatica, int accion = 0)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    int ccmsidAdmin = 0;
                    int res = 0;
                    bool? Obligatorio = profiles.Obligatorio.HasValue ? profiles.Obligatorio : false;

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    
                    int.TryParse(User.Identity.Name, out ccmsidAdmin);
                    
                    context.CatSolicitudEmpleadosAutorizantesSI(
                        int.Parse(solicitud),
                        profiles.Empleado_Ident,
                        int.Parse(Autorizador_Id),
                        profiles.NivelAutorizacion,
                        Obligatorio,
                        profiles.MontoAutorizacionAutomatica,
                        accion,
                        (string.IsNullOrEmpty(TTAutorizador_Ident) || TTAutorizador_Ident == "false" ? false : true),
                        (string.IsNullOrEmpty(TTNivelAutorizacion) || TTNivelAutorizacion == "false" ? false : true),
                        (string.IsNullOrEmpty(TTMontoAutorizacionAutomatica) || TTMontoAutorizacionAutomatica == "false" ? false : true),
                        true,
                        ccmsidAdmin,resultado);

                    int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ocurrio un detalle");
                    }
                }

                return Json(profiles, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                var resultadoAccion = "Ocurrió un error al procesar los autorizantes.";
                return Json(new { Id = 0, type = "create", response = new { Errors = resultadoAccion } }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}