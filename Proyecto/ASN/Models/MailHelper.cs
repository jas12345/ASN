using System;
using System.Configuration;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Web.Mvc;

namespace ASN.Models
{
    [Authorize]
    public class MailHelper
    {
        private const int Timeout = 180000;
        private readonly string _host;
        private readonly int _port;
        private readonly string _user;
        private readonly string _pass;
        private readonly bool _ssl;
        private readonly MailAddress _sender;
        private readonly string testing;
        private readonly string testingMail;
        //private readonly MailAddress testingMail;

        public string Recipient { get; set; }
        public string RecipientCC { get; set; }
        public string RecipientCCO { get; set; }
        public string Subject { get; set; }
        public string Body { get; set; }
        public bool IsBodyHtml { get; set; }
        public string AttachmentFile { get; set; }

        public MailHelper()
        {
            //MailServer - Represents the SMTP Server
            _host = ConfigurationManager.AppSettings["MailServer"];
            //Port- Represents the port number
            _port = int.Parse(ConfigurationManager.AppSettings["Port"]);
            //MailAuthUser and MailAuthPass - Used for Authentication for sending email
            _sender = new MailAddress(ConfigurationManager.AppSettings["EmailFromAddress"]);
            _user = ConfigurationManager.AppSettings["MailAuthUser"];
            _pass = ConfigurationManager.AppSettings["MailAuthPass"];
            _ssl = Convert.ToBoolean(ConfigurationManager.AppSettings["EnableSSL"]);
            testing = ConfigurationManager.AppSettings["testing"];
            //testingMail = new MailAddress(ConfigurationManager.AppSettings["testingMail"]);
            testingMail = ConfigurationManager.AppSettings["testingMail"];
        }

        public void Send()
        {
            try
            {

                Attachment att = null;
                var message = new MailMessage();

                if (testing == "1")
                {
                    foreach (var address in testingMail.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        message.To.Add(new MailAddress(address));
                    }

                    //message.To.Add(testingMail);
                }
                else
                {
                    //Split each email on the field
                    foreach (var address in Recipient.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        message.To.Add(new MailAddress(address));
                    }
                }

                message.Subject = Subject;
                message.From = _sender;
                message.Body = Body;
                message.IsBodyHtml = IsBodyHtml;

                if (testing != "1")
                {
                    if (!String.IsNullOrEmpty(RecipientCC))
                    {
                        foreach (var address in RecipientCC.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            message.CC.Add(address);
                        }
                    }

                    if (!String.IsNullOrEmpty(RecipientCCO))
                    {
                        foreach (var address in RecipientCCO.Split(new[] { ";" }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            message.Bcc.Add(address);
                        }
                    }
                }

                var smtp = new SmtpClient(_host, _port);

                if (!String.IsNullOrEmpty(AttachmentFile))
                {
                    if (File.Exists(AttachmentFile))
                    {
                        att = new Attachment(AttachmentFile);
                        att.ContentId = "imagens";
                        message.Attachments.Add(att);
                    }
                }

                if (_user.Length > 0 && _pass.Length > 0)
                {
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new NetworkCredential(_user, _pass);
                    smtp.EnableSsl = _ssl;
                }

                smtp.Send(message);

                if (att != null)
                    att.Dispose();
                message.Dispose();
                smtp.Dispose();
            }

            catch (Exception ex)
            {
                LogError log = new LogError();
                log.RecordError(ex, 1);
                //TODO: Enviar error a log de bd
            }
        }
    }
}