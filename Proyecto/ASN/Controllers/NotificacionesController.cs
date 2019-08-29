using ASN.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace ASN.Controllers
{
    public class NotificacionesController : Controller
    {
        // GET: Notificaciones
        public ActionResult Index()
        {
            if (User.Identity.IsAuthenticated)
            {
                return View();
            }
            else
            {
                return RedirectToAction("Login", "Home");
            }
        }

        public ActionResult GetNotificaciones()
        {
            try
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                using (ASNContext context = new ASNContext())
                {
                    var listado = new List<CatNotificacionesManualesSel_Result>();
                    var listadoXCCMSID = new List<int>();

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listado = context.CatNotificacionesManualesSel(usuario.UserInfo.Ident.Value).ToList();

                    listadoXCCMSID = listado
                    .GroupBy(p => p.EID.Value)
                    .Select(g => g.First().EID.Value)
                    .ToList();

                    foreach (var ccmsid in listadoXCCMSID)
                    {
                        var liston = listado.Where(morro => morro.EID == ccmsid).ToList();
                        var emailUser = liston.Where(morro => morro.EID == ccmsid).FirstOrDefault().email;
                        var nameUser = liston.Where(morro => morro.EID == ccmsid).FirstOrDefault().Nombre;

                        var email = RenderPartialView.RenderPartialViewToString(this,"NotificacionEmail", liston);

                        MailHelper mail = new MailHelper();
                        mail.IsBodyHtml = true;
                        //mail.RecipientCCO = correosSolicitantes;//emails.EmailTo; mail.RecipientCC = emails.EmailCC;
                        mail.Recipient = emailUser;
                        mail.Subject = "Notificación de Solicitudes pendientes por concluir para " + nameUser;
                        mail.AttachmentFile = Server.MapPath("~/Content/images/logo.png");
                        mail.Body = email;
                        mail.Send();
                    }

                    //var email = renderizar.RenderPartialViewToString("NotificacionEmail", listado);

                }

                return Json(new { status = "0", mensaje = "xD" }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(new { status = "-1", mensaje = "" });
            }
        }
        
        public JsonResult EnviaCorreo()
        {
            var estado = string.Empty;
            var mensajeAccion = string.Empty;
            try
            {                
                using (ASNContext context = new ASNContext())
                {
                    var listado = new List<AvisoSolicitantesManual_Result>();
                    listado = context.AvisoSolicitantesManual().ToList();

                    var correosSolicitantes = string.Empty;
                    var correosAutorizantes = string.Empty;
                    foreach (var item in listado)
                    {
                        if (!string.IsNullOrEmpty(item.eMailSolicitante))
                        {
                            correosSolicitantes += item.eMailSolicitante + ";";
                        }

                        if (!string.IsNullOrEmpty(item.eMailAutorizante))
                        {
                            correosAutorizantes += item.eMailAutorizante + ";";
                        }
                    }

                    correosSolicitantes = correosSolicitantes.Substring(0, correosSolicitantes.Length - 1);
                    correosAutorizantes = correosAutorizantes.Substring(0, correosAutorizantes.Length - 1);

                    if (!string.IsNullOrEmpty(correosSolicitantes))
                    {
                        MailHelper mail = new MailHelper();
                        mail.IsBodyHtml = true;
                        mail.RecipientCCO = correosSolicitantes;//emails.EmailTo; mail.RecipientCC = emails.EmailCC;
                        mail.Subject = "Notificación de Solicitudes pendientes por concluir";
                        mail.AttachmentFile = Server.MapPath("~/Content/images/logo.png");
                        //mail.Body = RenderPartialView.RenderPartialViewToString(this, "~\\Views\\Shared\\Mail\\NoticacionSolicitud.cshtml", null);
                        mail.Body = mail.Body.Replace("#cuerpo#", "Existen solicitudes pendientes por finalizar. Ingrese a la sección de Mis Solicitudes para darles seguimiento.");
                        mail.Send();
                    }

                    if (!string.IsNullOrEmpty(correosAutorizantes))
                    {
                        MailHelper mail = new MailHelper();
                        mail.IsBodyHtml = true;
                        mail.RecipientCCO = correosAutorizantes;
                        mail.Subject = "Solicitudes Pendientes por Autorizar";
                        mail.AttachmentFile = Server.MapPath("~/Content/images/logo.png");
                       // mail.Body = RenderPartialView.RenderPartialViewToString(this, "~\\Views\\Shared\\Mail\\NoticacionSolicitud.cshtml", null);
                        mail.Body = mail.Body.Replace("#cuerpo#", "Existen solicitudes asignadas para su revisión. Ingrese a la sección de Administrador de solicitudes para darle seguimiento a la solicitud.");
                        mail.Send();
                    }
                    estado = "0";
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                estado = "-1";
                mensajeAccion = ex.Message;
            }
            return Json(new { status = estado, mensaje = mensajeAccion }, JsonRequestBehavior.AllowGet);
        }
    }
}