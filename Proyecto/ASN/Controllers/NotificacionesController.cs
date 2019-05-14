using ASN.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASN.Controllers
{
    public class NotificacionesController : Controller
    {
        // GET: Notificaciones
        public JsonResult Index()
        {
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
                        mail.Body = RenderPartialView.RenderPartialViewToString(this, "~\\Views\\Shared\\Mail\\NoticacionSolicitud.cshtml", null);
                        mail.Body = mail.Body.Replace("#cuerpo#", "Existen solicitudes pendientes por finalizar. Ingrese a la sección de Mis Solicitudes para darles seguimiento.");
                        mail.Send();
                    }

                    //if (!string.IsNullOrEmpty(correosAutorizantes))
                    //{
                    //    MailHelper mail = new MailHelper();
                    //    mail.IsBodyHtml = true;
                    //    mail.RecipientCCO = correosAutorizantes;
                    //    mail.Subject = "Solicitudes Pendientes por Autorizar";
                    //    mail.AttachmentFile = Server.MapPath("~/Content/images/logo.png");
                    //    mail.Body = RenderPartialView.RenderPartialViewToString(this, "~\\Views\\Shared\\Mail\\NoticacionSolicitud.cshtml", null);
                    //    mail.Body = mail.Body.Replace("#cuerpo#", "Existen solicitudes asignadas para su revisión. Ingrese a la sección de Administrador de solicitudes para darle seguimiento a la solicitud.");
                    //    mail.Send();
                    //}
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
            }
            return Json(new { status = "", mensaje = "" }, JsonRequestBehavior.AllowGet);
        }
    }
}