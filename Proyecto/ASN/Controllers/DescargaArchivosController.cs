﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASN.Models;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using CsvHelper;
using System.IO.Compression;
using System.IO;

namespace ASN.Controllers
{
    [Authorize(Roles = "Responsable")]
    public class DescargaArchivosController : Controller
    {
        // GET: DescargaArchivos
        public ActionResult Index()
        {
            return View();
        }    

        public FileContentResult DownloadCSV(FormCollection form)
        {
            try
            {
                var lstActivos = new List<DescargaArchivoSolicitud_Result>();
                var lstInactivos = new List<DescargaArchivoSolicitud_Result>();
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                string strPeriodo = "";
                
                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstActivos = ctx.DescargaArchivoSolicitud(usuario.UserInfo.Ident.Value,1).ToList();
                    lstInactivos = ctx.DescargaArchivoSolicitud(usuario.UserInfo.Ident.Value, 0).ToList();
                    listPeriodoNomina = ctx.CatPeriodosNominaCMB(1).ToList();
                }

                if (listPeriodoNomina.Count > 0)
                {
                    strPeriodo = string.Format("_{0}", listPeriodoNomina[0].Valor);
                }

                if (lstInactivos.Count > 1)
                {
                    using (var memoryStream = new MemoryStream())
                    {
                        using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
                        {
                            var file1 = archive.CreateEntry(string.Format("NominaManual_Activos{0}.csv",strPeriodo));
                            using (var streamWriter = new StreamWriter(file1.Open()))
                            {
                                //streamWriter.Write("content1");
                                Type itemType = typeof(DescargaArchivoSolicitud_Result);
                                var props = itemType.GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);

                                foreach (var item in lstActivos)
                                {
                                    streamWriter.WriteLine(string.Join(",", props.Select(p => string.Format("\"{0}\"", p.GetValue(item, null)))));
                                }
                                streamWriter.Flush();
                            }

                            var file2 = archive.CreateEntry(string.Format("NominaManual_Inactivos{0}.csv",strPeriodo));
                            using (var streamWriter = new StreamWriter(file2.Open()))
                            {
                                //streamWriter.Write("content2");
                                Type itemType = typeof(DescargaArchivoSolicitud_Result);
                                var props = itemType.GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);

                                foreach (var item in lstInactivos)
                                {
                                    streamWriter.WriteLine(string.Join(",", props.Select(p => string.Format("\"{0}\"", p.GetValue(item, null)))));
                                }
                                streamWriter.Flush();
                            }
                        }

                        return File(memoryStream.ToArray(), "application/zip", string.Format("NominaManual{0}.zip",strPeriodo));
                    }


                }
                else
                {
                    var memo = new System.IO.MemoryStream();
                    using (var sw = new System.IO.StreamWriter(memo))
                    {
                        Type itemType = typeof(DescargaArchivoSolicitud_Result);
                        var props = itemType.GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);

                        foreach (var item in lstActivos)
                        {
                            sw.WriteLine(string.Join(",", props.Select(p => string.Format("\"{0}\"", p.GetValue(item, null)))));
                        }
                        sw.Flush();
                    }
                    return File(memo.ToArray(), "text/csv", string.Format("NominaManual{0}.csv",strPeriodo));
                }
            }
            catch (Exception ex)
            {

                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return null;
            }            
        }

        /// <summary>
        /// Método que devuelve todos los periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPeriodoNominaCMB()
        {
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(1).ToList();
                }

                return Json(listPeriodoNomina, JsonRequestBehavior.AllowGet);
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