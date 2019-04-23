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

namespace ASN.Controllers
{
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
                TempData["PerfilId"] = perfilId;
               if (User.Identity.IsAuthenticated)
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        ViewData["ConceptoMotivo"] = context.CatConceptosMotivoCMB().ToList();
                    }
                }
            }
            
            return PartialView("GridEmpleados");
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

        public ActionResult CreateSolicitudEmpleadosDetalle([DataSourceRequest] DataSourceRequest request, EmpleadosSolicitudesViewModel model)//,string aplicaTodos, string listEmpleados, string listConceptosMotivo)
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

                    if (model.LstConceptoMotivo.Count() > 0)
                    {
                        ConceptosMotivos = string.Empty;
                        foreach (var itemElement in model.LstConceptoMotivo) { ConceptosMotivos += itemElement.Ident + ","; }

                    }
                    ConceptosMotivos = ConceptosMotivos.TrimEnd(',');

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);

                    foreach (var item in model.LstConceptoMotivo)
                    {
                        context.CatSolicitudEmpleadosDetalleSi(
                        model.FolioSolicitud, model.Empleado_Ident,
                        item.Ident,
                        ccmsidAdmin, resultado);
                    }

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                    }

                    return Json("");
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                //MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                //LogError log = new LogError();
                //log.RecordError(ex, usuario.UserInfo.Ident.Value);
                var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
                //return Json(model.ToDataSourceResult(request, ModelState));
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
        public ActionResult UpdateSolicitudEmpleadosDetalle([DataSourceRequest] DataSourceRequest request, EmpleadosSolicitudesViewModel model, 
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
                    context.CatSolicitudEmpleadosDetalleSu(
                        model.FolioSolicitud,model.Empleado_Ident,
                        model.CatConceptoMotivoId, model.Manager_Ident,
                        model.ParametroConceptoMonto, model.Detalle,
                        model.PeriodoNomina, model.Active,
                        (string.IsNullOrEmpty(TTConceptoMotivoId) || TTConceptoMotivoId =="false" ? false:true),
                        (string.IsNullOrEmpty(TTManager_Ident) || TTManager_Ident == "false" ? false :true),
                        (string.IsNullOrEmpty(TTMonto) || TTMonto == "false" ? false :true),
                        (string.IsNullOrEmpty(TTDetalle) || TTDetalle == "false" ? false : true),
                        (string.IsNullOrEmpty(TTPeriodoNomina) || TTPeriodoNomina == "false" ? false : true),
                        ccmsidAdmin, resultado);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                    }

                    return Json("");
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                //MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                //LogError log = new LogError();
                //log.RecordError(ex, usuario.UserInfo.Ident.Value);
                var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
                //return Json(model.ToDataSourceResult(request, ModelState));
                return Json(new { Id = 0, type = "create", response = new { Errors = resultadoAccion } }, JsonRequestBehavior.AllowGet);
            }
        }
    }
}