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
        public ActionResult CreateAnioNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatAniosNominaSel_Result> profiles)
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
                         context.CatAniosNominaSi(obj.AnioId,obj.FechaInicio,obj.FechaCierre, ccmsidAdmin, resultado);
                    }

                    int.TryParse(resultado.Value.ToString(), out res);

                    if(res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe un registro con el mismo año.");
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
        public ActionResult UpdateAnioNomina ([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatAniosNominaSel_Result> profiles)
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
                         context.CatAniosNominaSu(obj.AnioId, obj.FechaInicio, obj.FechaCierre,ccmsidAdmin,obj.Active,resultado);
                    }

                    int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -4)
                    {
                        ModelState.AddModelError("error", "No existe el registro de año.");
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