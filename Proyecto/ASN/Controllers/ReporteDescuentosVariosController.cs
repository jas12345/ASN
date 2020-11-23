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
    public class ReporteDescuentosVariosController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public FileContentResult DownloadCSV(int IdPeriodoNominaSelected, string PeriodoNominaSelected, int? EmpresaIdSelected, string EmpresaSelected) //, KendoDropDownListSelectedViewModel kddListSelectedView )
        {
            try
            {
                var lstActivos = new List<ReporteDescuentosVarios_Result>();

                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                string strPeriodo = "";
                KendoDropDownListSelectedViewModel kddslv = new KendoDropDownListSelectedViewModel();

                string PeriodoNomina = "";
                int IdPeriodoNomina = 0;
                int IdEmpresa = 0;
                string Empresa = "";

                kddslv.IdPeriodoNomina = IdPeriodoNomina;
                kddslv.PeriodoNomina = PeriodoNomina;
                kddslv.IdEmpresa = IdEmpresa;
                kddslv.Empresa = Empresa;

                kddslv.IdPeriodoNomina = IdPeriodoNominaSelected;
                kddslv.PeriodoNomina = PeriodoNominaSelected;
                kddslv.IdEmpresa = EmpresaIdSelected;
                kddslv.Empresa = EmpresaSelected;

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = ctx.CatPeriodosNominaCMB(4, usuario.UserInfo.Ident.Value).ToList();

                    if (kddslv.IdPeriodoNomina == 0)
                    {
                        kddslv.IdPeriodoNomina = listPeriodoNomina[0].Ident;
                        kddslv.PeriodoNomina = string.Format("{0}", listPeriodoNomina[0].Valor);
                    }

                    lstActivos = ctx.ReporteDescuentosVarios(kddslv.IdPeriodoNomina, kddslv.IdEmpresa).ToList();
                }


                using (var memoryStream = new MemoryStream())
                {
                    using (var archive = new ZipArchive(memoryStream, ZipArchiveMode.Create, true))
                    {
                        var file1 = archive.CreateEntry(string.Format("Reporte_Descuentos_Varios_{0}.csv", kddslv.PeriodoNomina));
                        using (var streamWriter = new StreamWriter(file1.Open()))
                        {
                            Type itemType = typeof(ReporteDescuentosVarios_Result);
                            var props = itemType.GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);
                            var counterEmpleados = new List<int>();

                            foreach (var item in lstActivos)
                            {
                                if(item.EMPLEADO!="EMPLEADO")
                                {
                                    counterEmpleados.Add(Convert.ToInt32(item.EMPLEADO));
                                }
                                
                            }
                            var counterEmpSin = new List<int>();

                            foreach (var x in counterEmpleados.Distinct())
                            {
                                counterEmpSin.Add(x);
                            }

                            decimal suma = 0;

                            foreach (var item in lstActivos)
                            {
                                if(item.IMPORTE !="IMPORTE")
                                {
                                    suma = suma + Convert.ToDecimal(item.IMPORTE);
                                }
                                
                                streamWriter.WriteLine(string.Join(",", props.Select(p => string.Format("\"{0}\"", p.GetValue(item, null)))));
                            }
                            streamWriter.WriteLine("Empleados: " + counterEmpSin.Count().ToString());
                            streamWriter.WriteLine("Total: " + suma.ToString());
                            streamWriter.Flush();
                        }
                    }

                    return File(memoryStream.ToArray(), "application/zip", string.Format("Reporte_Descuentos_Varios_{0}.zip", kddslv.PeriodoNomina));
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

        public JsonResult GetPeriodoNominaCMB(int? active)
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

            try
            {
                int ccmsidAdmin = 0;
                int.TryParse(User.Identity.Name, out ccmsidAdmin);

                int? ccmsid = ccmsidAdmin;
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(active, usuario.UserInfo.Ident.Value).ToList();
                }

                return Json(listPeriodoNomina, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetEmpresaCMB()
        {
            try
            {
                var listEmpresa = new List<CatEmpresaByResponsableCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listEmpresa = context.CatEmpresaByResponsableCMB(usuario.UserInfo.Ident.Value).ToList();
                }
                return Json(listEmpresa, JsonRequestBehavior.AllowGet);

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