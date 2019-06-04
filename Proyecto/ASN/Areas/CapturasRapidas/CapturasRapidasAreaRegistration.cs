using System.Web.Mvc;

namespace ASN.Areas.CapturasRapidas
{
    public class CapturasRapidasAreaRegistration : AreaRegistration 
    {
        public override string AreaName 
        {
            get 
            {
                return "CapturasRapidas";
            }
        }

        public override void RegisterArea(AreaRegistrationContext context) 
        {
            context.MapRoute(
                "CapturasRapidas_default",
                "CapturasRapidas/{controller}/{action}/{id}",
                new { action = "Index", id = UrlParameter.Optional }
            );
        }
    }
}