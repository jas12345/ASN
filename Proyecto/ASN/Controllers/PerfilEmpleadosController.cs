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
                        ViewData["Pais"] = context.CatCountryTodosCMB().ToList();
                        ViewData["Ciudad"] = context.CatCityTodosCMB().ToList();
                        ViewData["Mercado"] = context.CatCompanyTodosCMB().ToList();
                        ViewData["Site"] = context.CatLocationTodosCMB().ToList();
                        ViewData["Cliente"] = context.CatClientTodosCMB().ToList();
                        ViewData["Programa"] = context.CatProgramTodosCMB().ToList();
                        ViewData["TipoContrato"] = context.CatContractTypeTodosCMB().ToList();
                        ViewData["Concepto"] = context.CatConceptosCMB(0).ToList();
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
                var lstCMB = new List<CatCountryTodosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCountryTodosCMB().ToList();
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
                var lstCMB = new List<CatCityTodosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCityTodosCMB().ToList();
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
                var lstCMB = new List<CatCompanyTodosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCompanyTodosCMB().ToList();
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
                var lstCMB = new List<CatLocationTodosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatLocationTodosCMB().ToList();
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
                var lstCMB = new List<CatClientTodosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatClientTodosCMB().ToList();
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
                var lstCMB = new List<CatProgramTodosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatProgramTodosCMB().ToList();
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
                var lstCMB = new List<CatContractTypeTodosCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatContractTypeTodosCMB().ToList();
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
                    lstCMB = ctx.CatConceptosCMB(0).ToList();
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
                    var list2 = context.CatPerfilEmpleadosSel(0).ToList();
                    List<CatPerfilEmpleadosViewModel> listado = new List<CatPerfilEmpleadosViewModel>();
                    foreach (var item in list2)
                    {
                        CatPerfilEmpleadosViewModel element = new CatPerfilEmpleadosViewModel() {
                            Perfil_Ident = item.Perfil_Ident,
                            Country_Ident = (item.Country_Ident != null ? item.Country_Ident.ToString():"-1"),
                            NombrePerfilEmpleados = item.NombrePerfilEmpleados,
                            Country_Full_Name = item.Country_Full_Name,
                            City_Ident = item.City_Ident,
                            City_Name = item.City_Name,
                            Company_Ident = (item.Company_Ident !=null ? item.Company_Ident.ToString(): "-1"),
                            Company_Name = item.Company_Name,
                            Location_Ident = (item.Location_Ident != null? item.Location_Ident.ToString():"-1"),
                            Location_Name = item.Location_Name,
                            Client_Ident = (item.Client_Ident != null ? item.Client_Ident.ToString():"-1"),
                            Client_Name = item.Client_Name,
                            Program_Ident = (item.Program_Ident != null ? item.Program_Ident.ToString():"-1"),
                            Program_Name = item.Program_Name,
                            Contract_Type_Ident = (item.Contract_Type_Ident != null ? item.Contract_Type_Ident.ToString():"-1"),
                            Contract_Type = item.Contract_Type,
                            ConceptoId = (item.ConceptoId != null ? item.ConceptoId.ToString():"-1"),
                            Concepto = item.Concepto,
                            TipoAccesoId = item.TipoAccesoId,
                            TipoAcceso =item.TipoAcceso,
                            Active = item.Active
                        };
                        listado.Add(element);
                    }
                    DataSourceResult ok = listado.ToDataSourceResult(request);

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
        public ActionResult CreatePerfilEmpleados([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPerfilEmpleadosViewModel> profiles)
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
                            int i = 0;
                            context.CatPerfilEmpleadosSi(
                                obj.NombrePerfilEmpleados,
                                (string.IsNullOrEmpty(obj.Country_Ident)?-1:int.Parse(obj.Country_Ident)),
                                //obj.City_Ident,
                                obj.City_Ident,
                                (string.IsNullOrEmpty(obj.Company_Ident) ? -1 : int.Parse(obj.Company_Ident)),
                                (string.IsNullOrEmpty(obj.Location_Ident) ?-1:int.Parse(obj.Location_Ident)),
                                (string.IsNullOrEmpty(obj.Client_Ident)?-1:int.Parse(obj.Client_Ident)),
                                (string.IsNullOrEmpty(obj.Program_Ident)?-1:int.Parse(obj.Program_Ident)),
                                (string.IsNullOrEmpty(obj.Contract_Type_Ident) ?-1:int.Parse(obj.Contract_Type_Ident)), 
                                ((Int32.TryParse(obj.ConceptoId, out i) ? i : (int?)null)),
                                obj.TipoAccesoId, ccmsidAdmin, resultado);
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
        public ActionResult UpdatePerfilEmpleados([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPerfilEmpleadosViewModel> profiles)
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