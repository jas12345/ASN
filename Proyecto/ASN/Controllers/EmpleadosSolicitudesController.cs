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
    public class EmpleadosSolicitudesController : Controller
    {
        // GET: EmpleadosSolicitudes
        public ActionResult Index()
        {
            return View();
        }

        public PartialViewResult MuestraEmpleados(string id, string perfilId)
        {
            if (!string.IsNullOrEmpty(id))
            {
                ViewBag.SolicitudBaseId = id;
                TempData["PerfilId"] = perfilId;
            }
            
            return PartialView("GridEmpleados");
        }

        public JsonResult GetEmpleadosSolicitudesSel([DataSourceRequest]DataSourceRequest request,string SolicitudId)
        {
            try
            {
                var listEmpleadosSolicitudes = new List<CatEmpleadosSolicitudesSel_Result>();

                    using (ASNContext context = new ASNContext())
                    {
                        SolicitudId = (string.IsNullOrEmpty(SolicitudId) && !string.IsNullOrEmpty(ViewBag.SolicitudBaseId) ? ViewBag.SolicitudBaseId : SolicitudId);
                        int i = 0;
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        listEmpleadosSolicitudes = context.CatEmpleadosSolicitudesSel(((Int32.TryParse(SolicitudId, out i) ? i : (int?)null))).ToList();
                        DataSourceResult ok = listEmpleadosSolicitudes.ToDataSourceResult(request);

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

        [AcceptVerbs(HttpVerbs.Post)]
        public ActionResult EditingInline_Update([DataSourceRequest] DataSourceRequest request, CatEmpleadosSolicitudesSel_Result model, string TTConceptoMotivoId, string TTManager_Ident, string TTMonto, string TTDetalleId, string TTPeriodoNomina)
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
                    context.CatEmpleadosSolicitudesSu(model.FolioSolicitud,model.Empleado_Ident,model.Active, ccmsidAdmin,resultado);
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