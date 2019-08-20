using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using ASN.Models;

namespace ASN.Controllers
{
    public class ComentariosController : Controller
    {
        // GET: Comentarios
        public ActionResult Comments()
        {
            return View();
        }


        [HttpPost]
        public ActionResult CreateComment(int folioId, int eid, int conceptoId, string comment)
        {
            try
            {
                Regex reg = new Regex("^[a-zA-Z0-9 áéíóúñ -.,?¿¡!\n]+$");
                Regex regSpa = new Regex("^ *$");

                Match isOK = reg.Match(comment);
                Match noSpa = regSpa.Match(comment);

                int ccmsUser = 0;

                if (isOK.Success && int.TryParse(User.Identity.Name, out ccmsUser) && !noSpa.Success && comment.Length <= 150 && !string.IsNullOrWhiteSpace(comment) && !string.IsNullOrEmpty(comment))
                {
                    using (ASNContext context = new ASNContext())
                    {
                        int ok = context.TraCommentSi(ccmsUser, folioId, eid, conceptoId, comment);
                        var mail = new MailHelper();
                        var lol = (MyCustomIdentity)User.Identity;

                        if (ok == 1)
                        {
                            return Json(1, JsonRequestBehavior.AllowGet);
                        }
                        else
                        {
                            return Json(0, JsonRequestBehavior.AllowGet);
                        }
                    }
                }
                else
                {
                    return Json(2);
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json(0);
            }
        }

        [HttpGet]
        public ActionResult GetComments(int folioId, int eid, int conceptoId)
        {
            try
            {
                using (ASNContext context = new ASNContext())
                {
                    int ccmsUser = 0;

                    int.TryParse(User.Identity.Name, out ccmsUser);

                    var list2 = context.TraCommentSel(folioId, eid, conceptoId).ToList();

                    TraComment obj = new TraComment();

                    obj.TraCommentId = -1;
                    obj.FolioId = folioId;
                    obj.EmployeeId = eid;
                    obj.ConceptoId = conceptoId;

                    list2.Add(obj);

                    //foreach (var obj in list2)
                    //{
                    //    obj.FolioId = folioId;
                    //    obj.EmployeeId = eid;
                    //    obj.ConceptoId = conceptoId;
                    //}

                    return PartialView("Comments", list2);
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

    }
}