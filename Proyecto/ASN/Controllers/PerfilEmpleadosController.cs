using ASN.Models;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web.Mvc;
using System.IO;
using CsvHelper;
using System.Web;
using System.Reflection;
using System.IO.Compression;
using System.Text;

namespace ASN.Controllers
{
    [Authorize(Roles = "Administrador")]
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
                //var lstCMB = new List<CatCountryByCascadeCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCountryTodosCMB().ToList();
                    //lstCMB = ctx.CatCountryByCascadeCMB(country, city, site, client, program, contract).ToList();
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

        public JsonResult GetCiudadesCMB(int? country)
        {
            try
            {

                //var lstCMB = new List<CatCityTodosCMB_Result>();
                var lstCMB = new List<CatCityByCountryCMB_Result>();                

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    //lstCMB = ctx.CatCityTodosCMB().ToList();
                    lstCMB = ctx.CatCityByCountryCMB(country).ToList();
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

        public JsonResult GetSitesCMB(int? country, int? city)
        {
            try
            {
                //var lstCMB = new List<CatLocationTodosCMB_Result>();
                var lstCMB = new List<CatLocationByCityCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    //lstCMB = ctx.CatLocationTodosCMB().ToList();
                    lstCMB = ctx.CatLocationByCityCMB(country, city).ToList();
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

        public JsonResult GetClientesCMB(int? country, int? city, int? site)
        {
            try
            {
                //var lstCMB = new List<CatClientTodosCMB_Result>();
                var lstCMB = new List<CatClientBySiteCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    //lstCMB = ctx.CatClientTodosCMB().ToList();
                    lstCMB = ctx.CatClientBySiteCMB(country, city, site).ToList();
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

        public JsonResult GetProgramasCMB(int? country, int? city, int? site, string client)
        {
            try
            {
                //var lstCMB = new List<CatProgramTodosCMB_Result>();
                var lstCMB = new List<CatProgramByClientCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    //lstCMB = ctx.CatProgramTodosCMB().ToList();
                    lstCMB = ctx.CatProgramByClientCMB(country, city, site, client).ToList();
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

        public JsonResult GetTiposContratoCMB(int? country, int? city, int? site, string client, int? program)
        {
            try
            {
                //var lstCMB = new List<CatContractTypeTodosCMB_Result>();
                var lstCMB = new List<CatContractTypeByProgramCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    //lstCMB = ctx.CatContractTypeTodosCMB().ToList();
                    lstCMB = ctx.CatContractTypeByProgramCMB(country, city, site, client, program).ToList();
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

        public JsonResult GetConceptosCMB(string country = "0", string client = "0")
        {
            try
            {
                //var lstCMB = new List<CatConceptosCMB_Result>();
                var lstCMB = new List<CatConceptosPaisClienteCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    int.TryParse(country, out int pais);
                    //client;
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    //lstCMB = ctx.CatConceptosCMB(0).ToList();
                    lstCMB = ctx.CatConceptosPaisClienteCMB(0, pais, client).ToList();
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
        public ActionResult GetPerfilEmpleados([DataSourceRequest] DataSourceRequest request,string perfil)
        {
            try
            {
                if (!string.IsNullOrEmpty(perfil))
                {
                   
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        var list2 = context.CatPerfilEmpleadosSel(Convert.ToInt32(perfil)).ToList();
                        List<CatPerfilEmpleadosViewModel> listado = new List<CatPerfilEmpleadosViewModel>();
                        foreach (var item in list2)
                        {
                            CatPerfilEmpleadosViewModel element = new CatPerfilEmpleadosViewModel()
                            {
                                Perfil_Ident = item.Perfil_Ident,
                                Country_Ident = (item.Country_Ident != null ? item.Country_Ident.ToString() : "-1"),
                                NombrePerfilEmpleados = item.NombrePerfilEmpleados,
                                Country_Full_Name = item.Country_Full_Name,
                                City_Ident = item.City_Ident,
                                City_Name = item.City_Name,
                                Location_Ident = (item.Location_Ident != null ? item.Location_Ident.ToString() : "-1"),
                                Location_Name = item.Location_Name,
                                Client_Ident = item.Client_Ident,
                                Client_Name = item.Client_Name,
                                Program_Ident = (item.Program_Ident != null ? item.Program_Ident.ToString() : "-1"),
                                Program_Name = item.Program_Name,
                                Contract_Type_Ident = (item.Contract_Type_Ident != null ? item.Contract_Type_Ident.ToString() : "-1"),
                                Contract_Type = item.Contract_Type,
                                ConceptoId = (item.ConceptoId != null ? item.ConceptoId.ToString() : "-1"),
                                ConceptoNombre = item.ConceptoNombre,
                                TipoAccesoId = item.TipoAccesoId,
                                TipoAcceso = item.TipoAcceso,
                                Active = item.Active
                            };
                            listado.Add(element);
                        }
                        DataSourceResult ok = listado.ToDataSourceResult(request);

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
        public ActionResult CreatePerfilEmpleados([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPerfilEmpleadosViewModel> profiles, string client_Ident, string conceptoId, string contract_Type_Ident)
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
                            obj.Client_Ident = client_Ident;
                            obj.ConceptoId = conceptoId;
                            obj.Contract_Type_Ident = contract_Type_Ident;
                        context.CatPerfilEmpleadosSi(
                                obj.NombrePerfilEmpleados,
                                (string.IsNullOrEmpty(obj.Country_Ident)?-1:int.Parse(obj.Country_Ident)),
                                //obj.City_Ident,
                                obj.City_Ident,
                                (string.IsNullOrEmpty(obj.Location_Ident) ?-1:int.Parse(obj.Location_Ident)),
                                //(string.IsNullOrEmpty(obj.Client_Ident) ? -1 : int.Parse(obj.Client_Ident)),
                                obj.Client_Ident,
                                (string.IsNullOrEmpty(obj.Program_Ident)?-1:int.Parse(obj.Program_Ident)),
                                //(string.IsNullOrEmpty(obj.Contract_Type_Ident) ?-1:int.Parse(obj.Contract_Type_Ident)),
                                obj.Contract_Type_Ident,
                                //((Int32.TryParse(obj.ConceptoId, out i) ? i : (int?)null)),
                                obj.ConceptoId,
                                obj.TipoAccesoId, ccmsidAdmin, resultado
                            );
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
        public ActionResult UpdatePerfilEmpleados([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatPerfilEmpleadosViewModel> profiles, string client_Ident, string conceptoId, string contract_Type_Ident, string city_Ident)
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
                        obj.Client_Ident = client_Ident;
                        obj.ConceptoId = conceptoId;
                        obj.Contract_Type_Ident = contract_Type_Ident;

                        context.CatPerfilEmpleadosSu(
                                obj.Perfil_Ident, 
                                obj.NombrePerfilEmpleados,

                                (string.IsNullOrEmpty(obj.Country_Ident) ? -1 : int.Parse(obj.Country_Ident)),
                                obj.City_Ident,
                                (string.IsNullOrEmpty(obj.Location_Ident) ? -1 : int.Parse(obj.Location_Ident)),
                                //(string.IsNullOrEmpty(obj.Client_Ident) ? -1 : int.Parse(obj.Client_Ident)),
                                obj.Client_Ident,
                                (string.IsNullOrEmpty(obj.Program_Ident) ? -1 : int.Parse(obj.Program_Ident)),
                                //(string.IsNullOrEmpty(obj.Contract_Type_Ident) ? -1 : int.Parse(obj.Contract_Type_Ident)),
                                obj.Contract_Type_Ident,
                                obj.ConceptoId,
                                obj.TipoAccesoId, 

                                ccmsidAdmin, 
                                obj.Active, 
                                resultado
                            );
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

        [HttpPost]
        public ActionResult CopyPerfilEmpleados([DataSourceRequest]DataSourceRequest request, Nullable<int> Perfil_Ident, string NombrePerfilEmpleados)
        {
            try
            {
                int res = 0;
                var result = new object();
                int ccmsidAdmin = 0;
                string mensaje = "";

                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);

                    ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                    resultado.Value = 0;

                    int.TryParse(User.Identity.Name, out ccmsidAdmin);

                    context.CatPerfilEmpleadosCopy(
                            Perfil_Ident,
                            NombrePerfilEmpleados,

                            ccmsidAdmin,
                            resultado
                        );

                    int.TryParse(resultado.Value.ToString(), out res);

                    switch (res)
                    {
                        case -1:
                            mensaje = "Ya existe un Perfil de Empleados copiado con la misma descripción.";
                            break;
                        //case -2:
                        //    mensaje = "El empleado no existe en CCMS o no está activo.";
                        //    break;
                        //case -3:
                        //    mensaje = "El puesto del empleado no es válido para este perfil.";
                        //    break;
                        //case -4:
                        //    mensaje = "El nivel ya está asignado a otro empleado";
                        //    break;
                    }

                    //return Json(profiles.ToDataSourceResult(request, ModelState));
                    //return Json(ModelState);

                    return Json(mensaje);
                }
            }
            catch (Exception ex)
            {
                string mensaje = "Ocurrió un error al procesar la solicitud.";
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(mensaje);
            }
            //        if (res == -1)
            //        {
            //            resultadoAccion = "Ya existe un Perfil de Empleados copiado con la misma descripción.";
            //            Error = new { Errors = resultadoAccion };
            //            ModelState.AddModelError("error", "Ya existe un Perfil de Empleados copiado con la misma descripción.");
            //        }

            //    result = new { Id = Perfil_Ident, responseError = Error, status = res.ToString() };

            //    }
            //    return Json(result, JsonRequestBehavior.AllowGet);
            //}
            //catch (Exception ex)
            //{
            //    ModelState.AddModelError("error", "Ocurrió un error al procesar la solicitud.");
            //    MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            //    LogError log = new LogError();
            //    log.RecordError(ex, usuario.UserInfo.Ident.Value);
            //    var resultadoAccion = "Ocurrió un error al procesar la solicitud.";
            //    return Json(new { Id = 0, responseError = new { Errors = resultadoAccion }, status = "-1" }, JsonRequestBehavior.AllowGet);
            //}
        }

        public ActionResult Async_CreaPerfilEmpleadosMasiva(IEnumerable<HttpPostedFileBase>filesPE)
        {

            try
            {
                int solicitudIdActual = -1;
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                int.TryParse(User.Identity.Name, out int userEmployeeId);               

                string Perfil = string.Empty;
                string Pais = string.Empty;
                string Ciudad = string.Empty;
                string Cliente = string.Empty;
                string Site = string.Empty;
                string Programa = string.Empty;
                string Contrato = string.Empty;
                string Concepto = string.Empty;
                string TpoAcceso = string.Empty;

                ObjectParameter resultado = new ObjectParameter("Estatus", typeof(int));
                ObjectParameter solicitudId = new ObjectParameter("FolioSolicitudOut", typeof(int));
                resultado.Value = -1;

                var lista = new List<CargaMasivaPerfilEmpleado>();
                var listaRetorno = new List<CargaMasivaRetorno>();
                listaRetorno.Add(new CargaMasivaRetorno() { NombrePerfil = "Nombre del Perfil", Campo = "Campo", Texto = "Error" });
                byte[] result= null;

                if (filesPE != null)
                {
                    foreach (var file in filesPE)
                    {
                        if (file != null)
                        {
                            var fileName = Path.GetFileName(file.FileName);
                            var ext = Path.GetExtension(fileName);

                            if (ext.ToUpper() == ".CSV")
                            {
                                var postedFile = file;

                                if (postedFile.ContentLength > 0)
                                {

                                    using (var csvReader = new StreamReader(postedFile.InputStream, Encoding.Default,true))
                                    {

                                        using (var csv = new CsvReader(csvReader))
                                        {

                                            while (csv.Read())
                                            {
                                                var objeton = new CargaMasivaPerfilEmpleado();

                                                if (csv.TryGetField(0, out Perfil) && csv.TryGetField(1, out Pais) && csv.TryGetField(2, out Ciudad) && csv.TryGetField(3, out Cliente)
                                                    && csv.TryGetField(4, out Site) && csv.TryGetField(5, out Programa) && csv.TryGetField(6, out Contrato) && csv.TryGetField(7, out Concepto) && csv.TryGetField(8, out TpoAcceso))
                                                {
                                                    objeton.perfil = Perfil;
                                                    objeton.pais = Pais;
                                                    objeton.ciudad = Ciudad;
                                                    objeton.cliente = Cliente;
                                                    objeton.site = Site;
                                                    objeton.programa = Programa;
                                                    objeton.contrato = Contrato;
                                                    objeton.concepto = Concepto;  //convertTOUTF8(Concepto);
                                                    objeton.tpoAcceso = TpoAcceso;
                                                    objeton.userEmployeeId = userEmployeeId;
                                                    //objeton.catEmployeeId = 0;//ccmsId;

                                                    if (Perfil != "Perfil" && Perfil != "")
                                                    {
                                                        lista.Add(objeton);
                                                    }

                                                }
                                            }
                                        }
                                    }
                                }


                                using (ASNContext context = new ASNContext())
                                {


                                    foreach (var obj in lista)
                                    {
                                        var parameters = new List<System.Data.SqlClient.SqlParameter>();
                                        var p1 = new System.Data.SqlClient.SqlParameter("@P1", obj.perfil);
                                        var p2 = new System.Data.SqlClient.SqlParameter("@P2", obj.pais);
                                        var p3 = new System.Data.SqlClient.SqlParameter("@P3", obj.ciudad);
                                        var p4 = new System.Data.SqlClient.SqlParameter("@P4", obj.cliente);
                                        var p5 = new System.Data.SqlClient.SqlParameter("@P5", obj.site);
                                        var p6 = new System.Data.SqlClient.SqlParameter("@P6", obj.programa);
                                        var p7 = new System.Data.SqlClient.SqlParameter("@P7", obj.contrato);
                                        var p8 = new System.Data.SqlClient.SqlParameter("@P8", obj.concepto);
                                        var p9 = new System.Data.SqlClient.SqlParameter("@P9", obj.tpoAcceso);
                                        var p10 = new System.Data.SqlClient.SqlParameter("@P10", obj.catEmployeeId) { DbType = System.Data.DbType.Int32 };
                                        var p11 = new System.Data.SqlClient.SqlParameter("@P11", "") { DbType = System.Data.DbType.Int32, Direction = System.Data.ParameterDirection.Output };

                                        parameters.Add(p1);
                                        parameters.Add(p2);
                                        parameters.Add(p3);
                                        parameters.Add(p4);
                                        parameters.Add(p5);
                                        parameters.Add(p6);
                                        parameters.Add(p7);
                                        parameters.Add(p8);
                                        parameters.Add(p9);
                                        parameters.Add(p10);
                                        //parameters.Add(p11);


                                        var retorno = context.Database.SqlQuery<CargaMasivaRetorno>("EXEC app620.CatPerfilEmpleadosMasivo @P1, @P2, @P3, @P4, @P5, @P6, @P7, @P8, @P9, @P10", parameters.ToArray()).ToList<CargaMasivaRetorno>();
                                        if (retorno.Count > 0)
                                        {
                                            listaRetorno.Add(retorno[0]);
                                        }
                                    }
                                }                               

                                return Json(listaRetorno, JsonRequestBehavior.AllowGet);
                            
                            }
                        }
                    }
                }
                
                return null;
                //return Json(new { res = 1 }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception e)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(e, usuario.UserInfo.Ident.Value);

                return Json(new { res = -1 }, JsonRequestBehavior.AllowGet);
            }





            // Return an empty string to signify success
            //return Content("");
        }

        public JsonResult GetPerfilAllCMB()
        {
            try
            {
                var lstCMB = new List<CatPerfilEmpleadosAllCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatPerfilEmpleadosAllCMB().ToList(); ;
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

    }
}