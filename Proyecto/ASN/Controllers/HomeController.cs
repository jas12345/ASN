using ASN.Models;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Configuration;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace GAPP.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Login()
        {
            var ctx = System.Web.HttpContext.Current;
            if (ctx.Request.IsAuthenticated)
            {
                return redirecciona(User.Identity.Name);
            }
            return this.View();
        }

        [HttpPost]
        [AntiForgeryHandleError]
        [ValidateAntiForgeryToken]
        public ActionResult Login(string userName, string password, string returnUrl)
        {
            try
            {
                Regex regex = new Regex(@"^[a-z A-Z]+(\.)?\d*$");
                Match matchUser = regex.Match(userName);
                //Match matchPass = regex.Match(password);

                if ((userName.Length <= 100 || password.Length <= 100) && matchUser.Success)
                {
                    //var ctx = new InformationSecurityEntities();

                    //var user = ctx.GetUserInfo(userName).ToList().Count > 0 ? true : false ;

                    UserViewModel user = Authentication.CCMSLogin(userName, password);

                    if (user.ident > 0 && user != null)
                    {
                        FormsAuthentication.SetAuthCookie(user.ident.ToString(), false);

                        //var xd = FormsAuthentication.Timeout;

                        //string decodedUrl = "";

                        //System.Web.HttpContext.Current.Items.Add("UserInfo",user);

                        //if (string.IsNullOrEmpty(returnUrl) && Request.UrlReferrer != null)
                        //{
                        //    returnUrl = Server.UrlEncode(Request.UrlReferrer.PathAndQuery);
                        //    decodedUrl = Server.UrlDecode(returnUrl);
                        //}

                        return redirecciona(user.ident.ToString());

                        //return redireccion();

                        //return RedirectToAction("Index", "ProDepro");

                        //if (returnUrl != null && Url.IsLocalUrl(decodedUrl))
                        //{
                        //    //return Redirect(decodedUrl);
                        //    //return Redirect("Login");
                        //    redirecciona();
                        //}
                        //else
                        //{
                        //    //return RedirectToAction("Login");
                        //    redirecciona();
                        //}
                    }

                    ModelState.AddModelError("x", "El usuario o el password son incorrectos.");
                    return View();
                }
                else
                {
                    ModelState.AddModelError("x", "El usuario o el password son incorrectos.");
                    return View();
                }
            }
            catch (Exception ex)
            {
                ModelState.AddModelError("x", ex.Message);
                //MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, 0);
                return View();
            }
        }

        public ActionResult redirecciona(string ccms)
        {
            if (User.IsInRole("Desarrollo"))
            {
                return RedirectToAction("Index", "Inicio");
            }
            else
            {
                //return Logout();
                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    int ccmsid = 0;
                    if (int.TryParse(ccms, out ccmsid))
                    {
                        if (ctx.CatRelUserRoleSel(ccmsid).ToList().Count() <= 0)
                        {
                            return Logout();
                        }
                        else
                        {
                            return RedirectToAction("Login");
                        }
                    }
                    else
                    {
                        return Logout();
                    }
                }
            }
        }

        /// <summary>
        /// Deslogeo
        /// </summary>
        /// <returns></returns>
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Login");
        }

        public ActionResult AlreadySignIn()
        {
            return View();
        }
    }
}