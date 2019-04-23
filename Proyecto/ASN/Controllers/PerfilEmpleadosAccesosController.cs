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
                        listPerfilEmpleadosAccesos = context.CatPerfilEmpleadosAccesosSel(int.Parse(perfil)).ToList();
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
        public ActionResult CreatePerfilEmpleadosAccesos([DataSourceRequest]DataSourceRequest request, string Perfil_Ident, string selectedKeyNames)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int idAdmin = 0, res = 0;
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out idAdmin);

                    context.CatPerfilEmpleadosAccesosSi(
                        int.Parse(Perfil_Ident),
                        selectedKeyNames,
                        idAdmin, 
                        true,
                        resultado);

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

                    return Json(Perfil_Ident);
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

        //public ActionResult Selection_Read([DataSourceRequest] DataSourceRequest request)
        //{
        //    return Json(productService.Read().ToDataSourceResult(request));
        //}
    }
}