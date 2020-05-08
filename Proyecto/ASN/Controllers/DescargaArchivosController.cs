using System;
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

        public FileContentResult DownloadCSV(int IdPeriodoNominaSelected, string PeriodoNominaSelected) //, KendoDropDownListSelectedViewModel kddListSelectedView )
        {
            try
            {
                var lstActivos = new List<DescargaArchivoSolicitud_Result>();
                var lstInactivos = new List<DescargaArchivoSolicitud_Result>();
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                string strPeriodo = "";
                KendoDropDownListSelectedViewModel kddslv = new KendoDropDownListSelectedViewModel();

                string PeriodoNomina = "";
                int IdPeriodoNomina = 0;

                kddslv.IdPeriodoNomina = IdPeriodoNomina;
                kddslv.PeriodoNomina = PeriodoNomina;

                kddslv.IdPeriodoNomina = IdPeriodoNominaSelected;
                kddslv.PeriodoNomina = PeriodoNominaSelected;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = ctx.CatPeriodosNominaCMB(4).ToList();

                    if (kddslv.IdPeriodoNomina == 0)
                    {
                        //strPeriodo = string.Format("_{0}", listPeriodoNomina[0].Valor);
                        kddslv.IdPeriodoNomina = listPeriodoNomina[0].Ident;
                        kddslv.PeriodoNomina = string.Format("{0}", listPeriodoNomina[0].Valor); ;
                    }

                    //lstActivos = ctx.DescargaArchivoSolicitud(usuario.UserInfo.Ident.Value, 1, IdPeriodoNomina).ToList();
                    lstActivos = ctx.DescargaArchivoSolicitud(usuario.UserInfo.Ident.Value, 1, kddslv.IdPeriodoNomina).ToList();
                    //lstInactivos = ctx.DescargaArchivoSolicitud(usuario.UserInfo.Ident.Value, 0, IdPeriodoNomina).ToList();
                    lstInactivos = ctx.DescargaArchivoSolicitud(usuario.UserInfo.Ident.Value, 0, kddslv.IdPeriodoNomina).ToList();
                }


                using (var memoryStream = new MemoryStream())
                {
                    using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
                    {
                        var file1 = archive.CreateEntry(string.Format("NominaManual_Activos_{0}.csv", kddslv.PeriodoNomina));
                        using (var streamWriter = new StreamWriter(file1.Open()))
                        {
                            Type itemType = typeof(DescargaArchivoSolicitud_Result);
                            var props = itemType.GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);

                            foreach (var item in lstActivos)
                            {
                                streamWriter.WriteLine(string.Join(",", props.Select(p => string.Format("\"{0}\"", p.GetValue(item, null)))));
                            }
                            streamWriter.Flush();
                        }

                        var file2 = archive.CreateEntry(string.Format("NominaManual_Inactivos_{0}.csv", kddslv.PeriodoNomina));
                        using (var streamWriter = new StreamWriter(file2.Open()))
                        {
                            Type itemType = typeof(DescargaArchivoSolicitud_Result);
                            var props = itemType.GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);

                            foreach (var item in lstInactivos)
                            {
                                streamWriter.WriteLine(string.Join(",", props.Select(p => string.Format("\"{0}\"", p.GetValue(item, null)))));
                            }
                            streamWriter.Flush();
                        }
                    }

                    return File(memoryStream.ToArray(), "application/zip", string.Format("NominaManual_{0}.zip", kddslv.PeriodoNomina));
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
        /// Método que devuelve periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPeriodoNominaCMB(int? active)
        {
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(active).ToList();
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