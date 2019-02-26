using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using ASN.Models;
using System.Security.Principal;
using System.Threading;
using System.Web.Security;
using System.Configuration;

namespace ASN
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
        }

        void Session_End(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
        }

        void Application_PostAuthenticateRequest(object sender, EventArgs e)
        {
            //string[] ok = LookupRolesForUser("Javier");
            var ctx = HttpContext.Current;
            int ccmsid = 0;
            int.TryParse(ctx.User.Identity.Name, out ccmsid);

            if (ctx.Request.IsAuthenticated)
            {
                string[] roles = LookupRolesForUser(ccmsid);

                var objIdentity = new MyCustomIdentity(ctx.User.Identity.Name, b: "");
                objIdentity.UserRoles = roles;
                objIdentity.UserNumerito = ctx.User.Identity.Name;

                if (objIdentity.UserInfo == null)
                {
                    using (InformationSecurityEntities ctxx = new InformationSecurityEntities())
                    {
                        ctxx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        var user = new CatUserInfoSel_Result();

                        user = ctxx.CatUserInfoSel(ccmsid).SingleOrDefault();
                        if (user != null)
                        {
                            objIdentity.UserInfo = user;
                        }
                    }
                }

                var newUser = new GenericPrincipal(objIdentity, roles);
                ctx.User = Thread.CurrentPrincipal = newUser;
            }
        }

        private string[] LookupRolesForUser(int name)
        {
            //var repo = new AccountRepository(); // In the real world, you would probably use service locator pattern and call DependencyResolver here
            //var user = repo.FindByName(name);

            using (InformationSecurityEntities ctx = new InformationSecurityEntities())
            {
                ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                var lstUserRoles = new List<CatRelUserRoleSel_Result>();

                lstUserRoles = ctx.CatRelUserRoleSel(name).ToList();

                var lstRoles = new List<string>();

                //var user = ctx.GetUserInfo(name);

                if (lstUserRoles != null && lstUserRoles.Count > 0)
                {
                    foreach (CatRelUserRoleSel_Result obj in lstUserRoles)
                    {
                        lstRoles.Add(obj.Role);//user.Roles;
                    }

                    return lstRoles.ToArray();
                }
            }

            return new string[0];  // Alternatively throw an exception
        }
    }
}
