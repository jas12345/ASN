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

            bundles.Add(new ScriptBundle("~/bundles/ConsecutivosPeriodos").Include(
            "~/Scripts/ConsecutivosPeriodos.js"));


            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*",
                        "~/Scripts/general.js",
                        "~/Scripts/jquery.unobtrusive-ajax.min.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-2.6.2"));

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

            bundles.Add(new ScriptBundle("~/bundles/ConceptosPeopleSoft").Include(
            "~/Scripts/ConceptosPeopleSoft.js"));

            bundles.Add(new ScriptBundle("~/bundles/ConceptosMotivos").Include(
            "~/Scripts/ConceptosMotivos.js"));

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

            bundles.Add(new ScriptBundle("~/bundles/PeriodoNomina").Include(
            "~/Scripts/PeriodoNomina.js"));

            bundles.Add(new ScriptBundle("~/bundles/PerfilEmpleados").Include(
            "~/Scripts/PerfilEmpleados.js"));

            bundles.Add(new ScriptBundle("~/bundles/Solicitudes").Include(
            "~/Scripts/Solicitudes.js"));
            bundles.Add(new ScriptBundle("~/bundles/CrearSolicitud").Include(
            "~/Scripts/CrearSolicitud.js"));
            bundles.Add(new ScriptBundle("~/bundles/EditarSolicitud").Include(
            "~/Scripts/SolicitudEditar.js"));

            bundles.Add(new ScriptBundle("~/bundles/PerfilEmpleadosAccesos").Include(
            "~/Scripts/PerfilEmpleadosAccesos.js"));

            bundles.Add(new ScriptBundle("~/bundles/EmpleadosSolicitudes").Include(
            "~/Scripts/EmpleadosSolicitudes.js"));

            bundles.Add(new ScriptBundle("~/bundles/ToDo").Include(
            "~/Scripts/ToDo.js"));

            bundles.Add(new ScriptBundle("~/bundles/MisSolicitudes").Include(
            "~/Scripts/MisSolicitudes.js"));

            bundles.Add(new ScriptBundle("~/bundles/MisAutorizaciones").Include(
            "~/Scripts/MisAutorizaciones.js"));

            bundles.Add(new ScriptBundle("~/bundles/MisResponsabilidades").Include(
            "~/Scripts/MisResponsabilidades.js"));

            bundles.Add(new ScriptBundle("~/bundles/CapturaSolicitud").Include(
            "~/Scripts/CapturaSolicitud.js"));

            bundles.Add(new ScriptBundle("~/bundles/AutorizaSolicitud").Include(
            "~/Scripts/AutorizaSolicitud.js"));

            bundles.Add(new ScriptBundle("~/bundles/ResponsableAutoriza").Include(
            "~/Scripts/ResponsableAutoriza.js"));

            bundles.Add(new ScriptBundle("~/bundles/SolicitudesTodas").Include(
            "~/Scripts/SolicitudesTodas.js"));

            bundles.Add(new ScriptBundle("~/bundles/BusquedasVarias").Include(
            "~/Scripts/BusquedasVarias.js"));

            //Comentarios
            bundles.Add(new ScriptBundle("~/bundles/Comentarios").Include("~/Scripts/Comentarios.js"));

            //Notificaciones
            bundles.Add(new ScriptBundle("~/bundles/Notificaciones").Include(
            "~/Scripts/Notificaciones.js"));

            //ReporteAuditoria
            bundles.Add(new ScriptBundle("~/bundles/ReporteAuditoria").Include(
            "~/Scripts/ReporteAuditoria.js"));

            //ReporteGeneral
            bundles.Add(new ScriptBundle("~/bundles/ReporteGeneral").Include(
            "~/Scripts/ReporteGeneral.js"));

            //ReporteIndividual
            bundles.Add(new ScriptBundle("~/bundles/ReporteIndividual").Include(
            "~/Scripts/ReporteIndividual.js"));

            //Administradores
            bundles.Add(new ScriptBundle("~/bundles/Administradores").Include(
            "~/Scripts/Administradores.js"));
        }
    }
}
