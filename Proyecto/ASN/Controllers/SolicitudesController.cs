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

        [HttpPost]
        public ActionResult CreateSolicitud(CatSolicitudesSel_Result profiles, string listaEmpleados)
        {
            //[DataSourceRequest]DataSourceRequest request, IEnumerable< [Bind(Prefix = "models")]IEnumerable<
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

                    //foreach (var obj in profiles)
                    //{
                    //    if (!string.IsNullOrEmpty(obj.Descripcion))
                    //    {
                    //        context.CatConceptosSi(
                    //            obj.Descripcion,
                    //            obj.TipoConcepto,
                    //            obj.Paises,
                    //            obj.MercadoId,
                    //            obj.ClienteId,
                    //            obj.PeopleSoftId,
                    //            obj.NumeroNivelAutorizante,
                    //            obj.AutorizacionAutomatica,
                    //            obj.AutorizacionObligatoria,
                    //            obj.Vigencia,
                    //            obj.PagosFijos,
                    //            obj.Tope,
                    //            obj.PeriodicidadNominaId,
                    //            fechaInicio,
                    //            fechaFin,
                    //            obj.ParametroConceptoId,
                    //            ccmsidAdmin,
                    //            resultado);
                    //    }
                    //}

                    //int.TryParse(resultado.Value.ToString(), out res);

                    //if (res == -1)
                    //{
                    //    ModelState.AddModelError("error", "Ya existe un concepto con la misma descripción.");
                    //}

                    return Json("");//(profiles.ToDataSourceResult(request, ModelState));
                }

                //return Json("");
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");// (profiles.ToDataSourceResult(request, ModelState));
            }
        }

    }
}