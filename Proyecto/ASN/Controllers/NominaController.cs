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
    public class NominaController : Controller
    {
        // GET: AniosNomina
        public ActionResult AniosNomina()
        {
            try
            {
                if (User.Identity.IsAuthenticated)
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        //ViewData["CatAniosNomina"] = context.CatAniosNominaSel().ToList();
                    }

                    return View();
                    //return View("Nomina/CatAniosNomina");
                    //return RedirectToAction("AniosNomina", "Nomina");
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

        // GET: MesesNomina
        public ActionResult MesesNomina()
        {
            try
            {
                //if (ctx.Request.IsAuthenticated)
                //{
                //    return redirecciona(User.Identity.Name);
                //}
                //return this.View();

                if (User.Identity.IsAuthenticated)
                {

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

        public JsonResult GetAniosNominaCMB()
        {
            try
            {
                var lstCMB = new List<CatAniosNominaCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatAniosNominaCMB().ToList();
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

        public JsonResult GetMesesCMB()
        {
            try
            {
                var lstCMB = new List<CatMesesCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatMesesCMB(0).ToList();
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
        /// Obtiene las registros actuales
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult GetAniosNomina([DataSourceRequest]DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var list2 = context.CatAniosNominaSel().ToList();
                    
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
        public ActionResult CreateAnioNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatAniosNominaSel_Result> profiles, string fechaInicio, string fechaCierre)
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

                    if (string.IsNullOrEmpty(fechaInicio) || string .IsNullOrEmpty(fechaCierre))
                    {
                        ModelState.AddModelError("error", "Las fechas de Inicio y de cierre no deben estar vacias.");
                    }

                    else { 
                        int.TryParse(User.Identity.Name, out ccmsidAdmin);

                        foreach (var obj in profiles)
                        {
                            context.CatAniosNominaSi(obj.AnioId, fechaInicio, fechaCierre, ccmsidAdmin, resultado);
                        }

                        int.TryParse(resultado.Value.ToString(), out res);

                        if (res == -1)
                        {
                            ModelState.AddModelError("error", "Ya existe un registro con el mismo año.");
                        }
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
        public ActionResult UpdateAnioNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatAniosNominaSel_Result> profiles, string fechaInicio, string fechaCierre)
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

                    if (string.IsNullOrEmpty(fechaInicio) || string.IsNullOrEmpty(fechaCierre))
                    {
                        ModelState.AddModelError("error", "Las fechas de Inicio y de cierre no deben estar vacias.");
                    }

                    else
                    {
                        int.TryParse(User.Identity.Name, out ccmsidAdmin);

                        foreach (var obj in profiles)
                        {
                            context.CatAniosNominaSu(obj.AnioId, fechaInicio, fechaCierre, ccmsidAdmin, obj.Active, resultado);
                        }

                        int.TryParse(resultado.Value.ToString(), out res);

                        if (res == -4)
                        {
                            ModelState.AddModelError("error", "No existe el registro de año.");
                        }
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
        public ActionResult GetMesesNomina([DataSourceRequest] DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var list2 = context.CatMesesNominaSel().ToList();

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
        public ActionResult CreateMesNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatMesesNominaSel_Result> profiles, string fechaInicio, string fechaCierre)
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

                    if (string.IsNullOrEmpty(fechaInicio) || string.IsNullOrEmpty(fechaCierre))
                    {
                        ModelState.AddModelError("error", "Las fechas de Inicio y de cierre no deben estar vacias.");
                    }

                    else
                    {
                        int.TryParse(User.Identity.Name, out ccmsidAdmin);

                        foreach (var obj in profiles)
                        {
                            context.CatMesesNominaSi(obj.AnioId, obj.MesId, fechaInicio, fechaCierre, ccmsidAdmin, resultado);
                        }

                        int.TryParse(resultado.Value.ToString(), out res);

                        if (res == -1)
                        {
                            ModelState.AddModelError("error", "Ya existe un registro con el mismo año y mes.");
                        }
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
        public ActionResult UpdateMesNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatMesesNominaSel_Result> profiles, string fechaInicio, string fechaCierre)
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

                    if (string.IsNullOrEmpty(fechaInicio) || string.IsNullOrEmpty(fechaCierre))
                    {
                        ModelState.AddModelError("error", "Las fechas de Inicio y de cierre no deben estar vacias.");
                    }

                    else
                    {
                        int.TryParse(User.Identity.Name, out ccmsidAdmin);

                        foreach (var obj in profiles)
                        {
                            context.CatMesesNominaSu(obj.AnioId, obj.MesId, fechaInicio, fechaCierre, ccmsidAdmin, obj.Active, resultado);
                        }

                        int.TryParse(resultado.Value.ToString(), out res);

                        if (res == -4)
                        {
                            ModelState.AddModelError("error", "No existe el registro de año y mes.");
                        }
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