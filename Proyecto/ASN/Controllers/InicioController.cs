using ASN.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASN.Controllers
{
    [Authorize]
    public class InicioController : Controller
    {
        // GET: Inicio
        public ActionResult Index()
        {
            try
            {
                if (User.Identity.IsAuthenticated)
                {
                    MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                    //using (ITALEntities ctx = new ITALEntities())
                    //{
                    //    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    //    var urlimg = ctx.CatImagePromotionByCityId(usuario.UserInfo.CityIdBIOS.Value).SingleOrDefault();
                    //    ViewBag.URLImagen = urlimg == null ? string.Empty : urlimg.ImageView;
                    //}

                    return View(usuario);
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
    }
}