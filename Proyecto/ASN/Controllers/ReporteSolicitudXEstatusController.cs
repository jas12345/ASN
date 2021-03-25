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
    [Authorize(Roles = "Consultante,Administrador,Solicitante,Autorizante,Responsable")]
    public class ReporteSolicitudXEstatusController : Controller
    {
        // GET: ReporteSolicitud
        public ActionResult Index()
        {
            
            if (User.Identity.IsAuthenticated)
            {
                ViewBag.MostrarPais = 0;
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lista = ctx.CatCountryByPerfilCMB(usuario.UserInfo.Ident.Value).ToList();
                    if (lista.Count > 1)
                    {
                        ViewBag.MostrarPais = 1;
                    }
                }

                return View();
            }
            else
            {
                return RedirectToAction("Login", "Home");
            }
        }

        public ActionResult GetSolicitudes([DataSourceRequest]DataSourceRequest request,int? periodoNomina, string estatusConcepto, string estatusSolicitud)//, string estatus, int? site, int? solicitanteCCMSID, int? city)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int.TryParse(User.Identity.Name, out int idAdmin);

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var lstSolicitudes = context.ReporteSolicitudXEstatusSel(idAdmin, periodoNomina, estatusSolicitud,estatusConcepto).ToList();//, city,site,solicitanteCCMSID,estatus).ToList();
                    DataSourceResult ok = lstSolicitudes.ToDataSourceResult(request);
                    return Json(ok,JsonRequestBehavior.AllowGet);
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

        //public JsonResult GetCiudadesCMB()
        //{
        //    try
        //    {
        //        var lstCMB = new List<CatCityCMB_Result>();

        //        using (ASNContext ctx = new ASNContext())
        //        {
        //            ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
        //            lstCMB = ctx.CatCityCMB().ToList();
        //        }

        //        return Json(lstCMB, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (Exception ex)
        //    {
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(ex, usuario.UserInfo.Ident.Value);
        //        return Json("");
        //    }
        //}

        //public JsonResult GetSitesCMB()
        //{
        //    try
        //    {
        //        var lstCMB = new List<CatSiteCMB_Result>();

        //        using (ASNContext ctx = new ASNContext())
        //        {
        //            ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
        //            lstCMB = ctx.CatSiteCMB().ToList();
        //        }

        //        return Json(lstCMB, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (Exception ex)
        //    {
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(ex, usuario.UserInfo.Ident.Value);
        //        return Json("");
        //    }
        //}

        //public JsonResult GetEmployeesCMB()
        //{
        //    try
        //    {
        //        var lstCMB = new List<CatEmpleadoSolicitanteCMB_Result>();

        //        using (ASNContext ctx = new ASNContext())
        //        {
        //            ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
        //            lstCMB = ctx.CatEmpleadoSolicitanteCMB().ToList();
        //        }

        //        return Json(lstCMB, JsonRequestBehavior.AllowGet);
        //    }
        //    catch (Exception ex)
        //    {
        //        MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
        //        LogError log = new LogError();
        //        log.RecordError(ex, usuario.UserInfo.Ident.Value);
        //        return Json("");
        //    }
        //}

        public JsonResult GetEstatusCMB()
        {
            try
            {
                var lstCMB = new List<CatEstatusCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatEstatusCMB().ToList();
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

        public ActionResult GetPeriodosNominaCMB(int? PaisId)
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var lstCMB = new List<CatPeriodosNominaCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatPeriodosNominaCMB(4,usuario.UserInfo.Ident.Value,PaisId).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }


        public JsonResult GetCountryByPerfilCMB()
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var lstCMB = new List<CatCountryByPerfilCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCountryByPerfilCMB(usuario.UserInfo.Ident.Value).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

    }
}