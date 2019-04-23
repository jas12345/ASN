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

        public ActionResult SeleccionaPersonal(string id)
        {

            return View();
        }

        [HttpPost]
        public JsonResult GetSolicitudes([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.CatSolicitudesSel().ToList();
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
                    lstCMB = ctx.CatPerfilEmpleadosCMB().ToList();
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
        /// Método que retorna todos los empleados relacionados con un perfil
        /// </summary>
        /// <param name="request"></param>
        /// <param name="perfil"></param>
        /// <returns></returns>
        [HttpPost]
        public JsonResult GetEmployee([DataSourceRequest]DataSourceRequest request, string perfil)
        {
            try
            {
                var listPeriodoNomina = new List<EmpleadosxPerfilSel_Result>();
                if (!string.IsNullOrEmpty(perfil))
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        listPeriodoNomina = context.EmpleadosxPerfilSel(int.Parse(perfil)).ToList();
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
        public ActionResult CreateSolicitud([DataSourceRequest]DataSourceRequest request, CatSolicitudesSel_Result profiles, string listaEmpleados)
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
                                profiles.PeriodoNominaAnio_Id,
                                profiles.PeriodoNominaMes_Id,
                                profiles.PeriodoOriginal_ConsecutivoId,
                                profiles.PeriodoNominaPeriodicidadNomina_Id,
                                profiles.PeriodoNominaTipoPeriodo_Id,
                                profiles.ConceptoId,
                                profiles.MotivoId,
                                profiles.Justficacion,
                                profiles.Responsable_Id,
                                profiles.Detalle,
                                profiles.PeriodoOriginal_AnioId,
                                profiles.PeriodoOriginal_MesId,
                                profiles.PeriodoOriginal_ConsecutivoId,
                                profiles.PeriodoOriginal_PeriodicidadId,
                                profiles.PeriodoOriginal_TipoPeriodoId,
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

                    if (res == -1)
                    {
                        resultadoAccion = "Ya existe un concepto con la misma descripción.";
                        Error = new { Errors = resultadoAccion };
                        ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                    } else
                    {
                        if (lstResultado.Length >1)
                        {
                            SolicitudId = int.Parse(lstResultado[1].ToString());
                        }
                    }

                    return Json(new { Id =SolicitudId,type= "create", response = Error }, JsonRequestBehavior.AllowGet);// (profiles.ToDataSourceResult(request, ModelState));
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
                return Json(new { Id = 0,type = "create", response = new { Errors = resultadoAccion } }, JsonRequestBehavior.AllowGet);
            }
        }

    }
}