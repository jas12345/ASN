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
    public class TiposPeriodoNominaController : Controller
    {
        // GET: TipoPeriodoNomina
        public ActionResult Index()
        {
            try
            {
                if (User.Identity.IsAuthenticated)
                {
                    using (ASNContext context = new ASNContext())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
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

        [HttpPost]
        public ActionResult GetTiposPeriodoNomina([DataSourceRequest] DataSourceRequest request)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var list2 = context.CatTiposPeriodoNominaSel().ToList();

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
        public ActionResult CreateTiposPeriodoNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatTiposPeriodoNominaSel_Result> profiles)
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
                            context.CatTiposPeriodoNominaSi(obj.TipoPeriodoId, obj.Descripcion, ccmsidAdmin, resultado);
                        }

                        int.TryParse(resultado.Value.ToString(), out res);

                        if (res == -1)
                        {
                            ModelState.AddModelError("error", "Ya existe un Tipo de Período de Nómina con la misma descripción.");
                        }

                        if (res == -2)
                        {
                            ModelState.AddModelError("error", "Ya existe un Tipo de Período de Nómina con la misma clave.");
                        }

                        if (res == -3)
                        {
                            ModelState.AddModelError("error", "Ya existe un Tipo de Período de Nómina con la misma clave y descripción.");
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
        public ActionResult UpdateTiposPeriodoNomina([DataSourceRequest]DataSourceRequest request, [Bind(Prefix = "models")]IEnumerable<CatTiposPeriodoNominaSel_Result> profiles)
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
                            context.CatTiposPeriodoNominaSu(obj.TipoPeriodoId, obj.Descripcion, ccmsidAdmin, obj.Active, resultado);
                        }

                        int.TryParse(resultado.Value.ToString(), out res);

                    if (res == -1)
                    {
                        ModelState.AddModelError("error", "Ya existe un Tipo de Período de Nómina con la misma descripción.");
                    }

                    if (res == -2)
                    {
                        ModelState.AddModelError("error", "Ya existe un Tipo de Período de Nómina con la misma clave.");
                    }

                    if (res == -3)
                    {
                        ModelState.AddModelError("error", "Ya existe un Tipo de Período de Nómina con la misma clave y descripción.");
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