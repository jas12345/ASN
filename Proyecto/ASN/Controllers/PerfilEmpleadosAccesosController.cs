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
    public class PerfilEmpleadosAccesosController : Controller
    {
        // GET: Solicitudes
        public ActionResult Index()
        {
            return View();
        }

        public JsonResult GetPerfilCMB()
        {
            try
            {
                var lstCMB = new List<CatPerfilEmpleadosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatPerfilEmpleadosCMB(-1).ToList();
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

        [HttpPost]
        public JsonResult GetPerfilEmpleadosAccesos([DataSourceRequest]DataSourceRequest request, string perfil)
        {
            try
            {
                var listPerfilEmpleadosAccesos = new List<CatPerfilEmpleadosAccesosSel_Result>();
                if (!string.IsNullOrEmpty(perfil))
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        int perfil_Ident = int.Parse(perfil);
                        listPerfilEmpleadosAccesos = context.CatPerfilEmpleadosAccesosSel(perfil_Ident).ToList();
                        DataSourceResult ok = listPerfilEmpleadosAccesos.ToDataSourceResult(request);

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

        [HttpPost]
        public ActionResult CreatePerfilEmpleadosAccesos([DataSourceRequest]DataSourceRequest request, int empleadoId, int perfil_Ident, Nullable<int> nivel)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int idAdmin = 0, res = 0;
                    string mensaje = "";

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    ObjectParameter resultado = new ObjectParameter("estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out idAdmin);

                    context.CatPerfilEmpleadosAccesosSi(
                          empleadoId
                        , perfil_Ident
                        , nivel
                        , idAdmin
                        , true
                        , resultado);

                    int.TryParse(resultado.Value.ToString(), out res);

                    switch (res)
                    {
                        case -1:
                            mensaje = "Ya existe este registro de Acceso para este empleado y perfil.";
                            break;
                        case -2:
                            mensaje = "El empleado no existe en CCMS o no está activo.";
                            break;
                        case -3:
                            mensaje = "El puesto del empleado no es válido para este perfil.";
                            break;
                        case -4:
                            mensaje = "El nivel ya está asignado a otro empleado";
                            break;
                    }

                    //return Json(profiles.ToDataSourceResult(request, ModelState));
                    //return Json(ModelState);

                    return Json(mensaje);
                }
            }
            catch (Exception ex)
            {
                string mensaje = "Ocurrió un error al procesar la solicitud.";
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(mensaje);
            }
        }

        [HttpPost]
        public ActionResult UpdatePerfilEmpleadosAccesos([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPerfilEmpleadosAccesosSel_Result> profiles, int Perfil_Ident, int Ident, bool Active/*, int resultado*/)
        {
            try
            {

                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    
                    int ccmsidAdmin = 0, res = 0;

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(resultado.Value.ToString(), out res);

                    context.CatPerfilEmpleadosAccesosSu(Perfil_Ident, Ident, null, ccmsidAdmin, Active, resultado);

                    int.TryParse(resultado.Value.ToString(), out res);

                    switch (res)
                    {
                        case -1:
                            ModelState.AddModelError("error", "Error general.");
                            break;
                        case -2:
                            ModelState.AddModelError("error", "Error general.");
                            break;
                        case -3:
                            ModelState.AddModelError("error", "Error general.");
                            break;
                    }

                    return Json(profiles.ToDataSourceResult(request, ModelState));
                    //return Json(Perfil_Ident);
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(Perfil_Ident);
            }
        }

        public ActionResult Checkbox_Selection()
        {
            return View();
        }

        public JsonResult GetEmpleadoPuestoSupervisor(int Ident)
        {
            try
            {
                var lstEmpleadoPuestoSupervisor = new List<CatEmpleadoPuestoSupervisorSel_Result>();

                using (ASNContext context = new ASNContext())
                {
                    lstEmpleadoPuestoSupervisor = context.CatEmpleadoPuestoSupervisorSel(Ident).ToList();
                }

                return Json(lstEmpleadoPuestoSupervisor, JsonRequestBehavior.AllowGet);
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

        public ActionResult GetPerfilTipoAcceso(int Perfil_Ident)
        {
            try
            {
                var lstPerfilTipoAcceso = new List<CatPerfilTipoAccesoSel_Result>();

                using (ASNContext context = new ASNContext())
                {
                    lstPerfilTipoAcceso = context.CatPerfilTipoAccesoSel(Perfil_Ident).ToList();
                }

                return Json(lstPerfilTipoAcceso.SingleOrDefault(), JsonRequestBehavior.AllowGet);
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