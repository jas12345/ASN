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
    public class PerfilEmpleadosController : Controller
    {
        // GET: PerfilEmpleados
        public ActionResult Index()
        {
            try
            {
                if (User.Identity.IsAuthenticated)
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        ViewData["Pais"] = context.CatCountryCMB().ToList();
                        ViewData["Ciudad"] = context.CatCityCMB().ToList();
                        ViewData["Mercado"] = context.CatCompanyCMB().ToList();
                        ViewData["Site"] = context.CatLocationCMB().ToList();
                        ViewData["Cliente"] = context.CatClientCMB().ToList();
                        ViewData["Programa"] = context.CatProgramCMB().ToList();
                        ViewData["TipoContrato"] = context.CatContractTypeCMB().ToList();
                        ViewData["Concepto"] = context.CatConceptosCMB().ToList();
                        ViewData["TipoAcceso"] = context.CatTiposAccesoCMB().ToList();

                    }

                    return View();
                }
                else
                {
                    return RedirectToAction("Login", "Home");
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return RedirectToAction("Login", "Home");
            }
        }

        public JsonResult GetPaisesCMB()
        {
            try
            {
                var lstCMB = new List<CatCountryCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCountryCMB().ToList();
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

        public JsonResult GetCiudadesCMB()
        {
            try
            {
                var lstCMB = new List<CatCityCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCityCMB().ToList();
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

        public JsonResult GetMercadosCMB()
        {
            try
            {
                var lstCMB = new List<CatCompanyCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCompanyCMB().ToList();
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

        public JsonResult GetSitesCMB()
        {
            try
            {
                var lstCMB = new List<CatLocationCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatLocationCMB().ToList();
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

        public JsonResult GetClientesCMB()
        {
            try
            {
                var lstCMB = new List<CatClientCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatClientCMB().ToList();
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

        public JsonResult GetProgramasCMB()
        {
            try
            {
                var lstCMB = new List<CatProgramCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatProgramCMB().ToList();
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

        public JsonResult GetTiposContratoCMB()
        {
            try
            {
                var lstCMB = new List<CatContractTypeCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatContractTypeCMB().ToList();
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

        public JsonResult GetConceptosCMB()
        {
            try
            {
                var lstCMB = new List<CatConceptosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatConceptosCMB().ToList();
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

        public JsonResult GetTiposAccesoCMB()
        {
            try
            {
                var lstCMB = new List<CatTiposAccesoCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatTiposAccesoCMB().ToList();
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
        public ActionResult GetPerfilEmpleados([DataSourceRequest] DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var list2 = context.CatPerfilEmpleadosSel().ToList();

                    DataSourceResult ok = list2.ToDataSourceResult(request);

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

        [HttpPost]
        public ActionResult CreatePerfilEmpleados([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPerfilEmpleadosSel_Result> profiles)
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

                        foreach (var obj in profiles)
                        {
                            context.CatPerfilEmpleadosSi(obj.NombrePerfilEmpleados, obj.Country_Ident, obj.City_Ident, obj.Company_Ident, obj.Location_Ident, obj.Client_Ident, obj.Program_Ident, obj.Contract_Type_Ident, obj.ConceptoId, obj.TipoAccesoId, ccmsidAdmin, resultado);
                        }

                        int.TryParse(resultado.Value.ToString(), out res);

                        if (res == -1)
                        {
                            ModelState.AddModelError("error", "Ya existe un Perfil de Empleados con la misma descripción.");
                        }

                        if (res == -2)
                        {
                            ModelState.AddModelError("error", "Ya existe un Perfil de Empleados con la misma clave.");
                        }

                        if (res == -3)
                        {
                            ModelState.AddModelError("error", "Ya existe un Perfil de Empleados con la misma clave y/o descripción.");
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
                return Json(profiles.ToDataSourceResult(request, ModelState));
            }
        }

        [HttpPost]
        public ActionResult UpdatePerfilEmpleados([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPerfilEmpleadosSel_Result> profiles)
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

                        foreach (var obj in profiles)
                        {
                            context.CatPerfilEmpleadosSu(obj.Perfil_Ident, obj.NombrePerfilEmpleados, ccmsidAdmin, obj.Active, resultado);
                        }

                        int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe un Perfil de Empleados con la misma descripción.");
                    }

                    if (res == -2)
                    {
                        ModelState.AddModelError("error", "Ya existe un Perfil de Empleados con la misma clave.");
                    }

                    if (res == -3)
                    {
                        ModelState.AddModelError("error", "Ya existe un Perfil de Empleados con la misma clave y descripción.");
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
                return Json(profiles.ToDataSourceResult(request, ModelState));
            }
        }

    }
}