﻿using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
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

    }
}