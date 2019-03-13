using System.Web;
using System.Web.Optimization;

namespace ASN
{
    public class BundleConfig
    {
        // Para obtener más información sobre las uniones, visite https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            BundleTable.EnableOptimizations = false;

            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*",
                        "~/Scripts/general.js",
                        "~/Scripts/jquery.unobtrusive-ajax.min.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/DisableRMC.js",
                      "~/Scripts/respond.js"));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
                      "~/Content/animate.css",
                      "~/Content/font-awesome.css",
                      "~/Content/simple-sidebar.css",
                      "~/Content/site.css"));

            //Kendo Blundes
            bundles.Add(new ScriptBundle("~/bundles/kendo").Include(
            "~/Scripts/kendo.all.min.js",
            "~/Scripts/kendo.aspnetmvc.min.js",
            "~/Scripts/jquery.blockUI.js",
            "~/Scripts/jszip.min.js"));


            bundles.Add(new StyleBundle("~/Content/kendo/css").Include(
            //"~/Content/kendo.common-material.css", 
            "~/Content/kendo.common.min.css",
            "~/Content/kendo.default.min.css",
            //"~/Content/kendo.dataviz.min.css",
            //"~/Content/kendo.dataviz.default.min.css",
            //"~/Content/kendo.mobile.all.min.css",
            //"~/Content/kendo.material.css"
            "~/Content/kendo.custom.css"
            ));

            bundles.Add(new ScriptBundle("~/bundles/Conceptos").Include(
            "~/Scripts/Conceptos.js"));

            bundles.Add(new ScriptBundle("~/bundles/Nomina").Include(
            "~/Scripts/Nominas.js"));

            bundles.Add(new ScriptBundle("~/bundles/AniosNomina").Include(
            "~/Scripts/AniosNomina.js"));

            bundles.Add(new ScriptBundle("~/bundles/MesesNomina").Include(
            "~/Scripts/MesesNomina.js"));

            bundles.Add(new ScriptBundle("~/bundles/PeriodicidadNomina").Include(
            "~/Scripts/PeriodicidadNomina.js"));

            bundles.Add(new ScriptBundle("~/bundles/TiposPeriodoNomina").Include(
            "~/Scripts/TiposPeriodoNomina.js"));
        }
    }
}
