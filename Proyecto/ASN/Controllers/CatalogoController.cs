using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Kendo.Mvc.Extensions;
using Kendo.Mvc.UI;
using ASN.Models;
using System.IO;
using System.Configuration;

namespace ASN.Controllers
{
    //[Authorize]
    [Authorize(Roles = "Desarrollo,Security,RH,ProDeproManager,Information Security")]  //hrcv
    public class CatalogoController : Controller
    {
        // GET: ProDepro
        public ActionResult Index()
        {
            try
            {
                if (User.Identity.IsAuthenticated)
                {
                    using (InformationSecurityEntities context = new InformationSecurityEntities())
                    {
                        context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                        ViewData["Action"] = context.CatActionGRIDCMB().ToList();
                        ViewData["SubAction"] = context.CatSubActionGRIDCMB().ToList();
                    }
                    return View();
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

        /// <summary>
        /// Obtiene los registros actuales por medio del accountId del usuario
        /// </summary>
        /// <param name="request"></param>
        /// <param name="aci">accountID</param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult GetProDepro([DataSourceRequest]DataSourceRequest request, int aci)
        {
            try
            {
                //int accountid = 0;

                //int.TryParse(aci, out accountid);

                using (InformationSecurityEntities context = new InformationSecurityEntities())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var list2 = context.CatProDeproSel(aci).ToList();
                    DataSourceResult ok = list2.ToDataSourceResult(request);
                    return Json(ok);
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

        /// <summary>
        /// Obtiene los registros para el combo de action
        /// </summary>
        /// <returns></returns>
        public JsonResult GetActionsCMB(int monito)
        {
            try
            {
                var lstCMB = new List<CatActionCMB_Result>();
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                //int locIdUser = usuario.UserInfo.Location_Ident.Value;

                using (InformationSecurityEntities ctx = new InformationSecurityEntities())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatActionCMB(monito).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        /// <summary>
        /// Obtiene los registros para el combo de SubActions del ELA
        /// </summary>
        /// <param name="accion"> Accion id seleccionada</param>
        /// <returns></returns>
        public JsonResult GetSubActionsCMB(int accion)
        {
            try
            {
                var lstCMB = new List<CatSubActionCMB_Result>();
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                //int locIdUser = usuario.UserInfo.Location_Ident.Value;

                using (InformationSecurityEntities ctx = new InformationSecurityEntities())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatSubActionCMB(accion).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        /// <summary>
        /// Obtiene los registros para el combo de fechas NCNS
        /// </summary>
        /// <returns></returns>
        public JsonResult GetDatesNCNSCMB(int CCMSNumber)
        {
            try
            {
                var lstCMB = new List<CatScheduleEmployeeCMB_Result>();

                using (InformationSecurityEntities ctx = new InformationSecurityEntities())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatScheduleEmployeeCMB(CCMSNumber).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        /// <summary>
        /// Obtiene los registros para el combo de fechas R2OPS
        /// </summary>
        /// <returns></returns>
        public JsonResult GetDatesR2OPSCMB()
        {
            try
            {
                var lstCMB = new List<CatDaysYearR2OPSCMB_Result>();

                using (InformationSecurityEntities ctx = new InformationSecurityEntities())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatDaysYearR2OPSCMB().ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        /// <summary>
        /// Obtiene los registros para el combo de managers
        /// </summary>
        /// <returns></returns>
        public JsonResult GetManagerCMB()
        {
            try
            {
                var lstCMB = new List<CatEmployeeManagerByEIdSel_Result>();
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                using (InformationSecurityEntities ctx = new InformationSecurityEntities())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatEmployeeManagerByEIdSel(usuario.UserInfo.Ident).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        /// <summary>
        /// Obtiene los registros para el combo de accounts ESTE SP tambien se usa en APBajasController
        /// </summary>
        /// <returns></returns>
        public JsonResult GetManagerEmployeesCMB(int manager)
        {
            try
            {
                var lstCMB = new List<CatAccountIdByManagerIdSel_Result>();

                using (InformationSecurityEntities ctx = new InformationSecurityEntities())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                    lstCMB = ctx.CatAccountIdByManagerIdSel(manager, usuario.UserInfo.Ident.Value).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        // GET: /Controller/MyGrid/{id}
        [HttpPost]
        public ActionResult MyGrid(string selectedID, int aci)
        {
            try
            {
                switch (selectedID.ToString())
                {
                    case "1": //NCNS

                        var NCNS = new NCNSViewModel();

                        NCNS.ccmsid = aci;

                        return PartialView("NCNS", NCNS);
                    case "2": //ELA

                        var ELA = new ELAViewModel();

                        ELA.ccmsid = aci;
                        ELA.accion = int.Parse(selectedID);

                        return PartialView("ELA", ELA);
                    case "3":// Return To OPS

                        var R2W = new R2WViewModel();

                        return PartialView("R2W", R2W);
                    default:
                        return View();
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return View();
            }
        }

        /// <summary>
        /// Conversion para renderizar una vista parcial
        /// </summary>
        /// <param name="viewName"></param>
        /// <param name="model"></param>
        /// <returns></returns>
        protected string RenderPartialViewToString(string viewName, object model)
        {
            try
            {
                if (string.IsNullOrEmpty(viewName))
                    viewName = ControllerContext.RouteData.GetRequiredString("action");

                ViewData.Model = model;

                using (StringWriter sw = new StringWriter())
                {
                    ViewEngineResult viewResult = ViewEngines.Engines.FindPartialView(ControllerContext, viewName);
                    ViewContext viewContext = new ViewContext(ControllerContext, viewResult.View, ViewData, TempData, sw);
                    viewResult.View.Render(viewContext, sw);

                    return sw.GetStringBuilder().ToString();
                }
            }
            catch(Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return "";
            }
        }

        public JsonResult getImagesUploadedByCatProDeproIdAsJson(int CatProDeproId, int ActionId, string nombreFile)
        {
            try
            {
                string dirToSaveFilesView = (ConfigurationManager.AppSettings["PathImageView"]).ToString() + nombreFile;
                var anyUrl = String.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content(dirToSaveFilesView));
                var imageUrl = anyUrl;
                return Json(imageUrl, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        /// <summary>
        /// Returns partial view named partUserInfoView
        /// </summary>
        /// <param name="user">The user.</param>
        /// <returns></returns>
        // public PartialViewResult SubirFotoPopup(List<TraClericalImages> fotos)
        public PartialViewResult SubirFotoPopup(/*TraClericalImages fotos*/int catId, int actId)
        {
            //pass user info to Partial View and return it to client. The partial view will be rendered into modal popup.
            TraClericalImages fotos = new TraClericalImages();

            fotos.CatProDeproId = catId;
            fotos.ActionId = actId;

            return PartialView(fotos);
        }

        // Saves a file in a Physical File System
        public void Save(IEnumerable<HttpPostedFileBase> files, int catId, int actId)
        {
            try
            {
                string dirToSaveFiles = (ConfigurationManager.AppSettings["PathImage"]).ToString();//"~/Content/images/Clerical/";
                // The Name of the Upload component is "files"
                if (files != null)
                {
                    foreach (var file in files)
                    {
                        // get only the fileName and not the full filePath
                        var fileName = Path.GetFileName(file.FileName);
                        var ext = Path.GetExtension(fileName);
                        if (ext.ToUpper() == ".PNG" || ext.ToUpper() == ".JPG" || ext.ToUpper() == ".JPEG")
                        {
                            fileName = fileName.Replace(ext, "") + "_" + DateTime.Now.ToString("yyyy-MM-dd_HHmmss") + "_" + catId + "_" + actId + ext;
                            //var physicalPath = Path.Combine(Server.MapPath("~/"), fileName /*fileName.Replace(ext, "") + "_" + DateTime.Now.ToString("yyyy-MM-dd") + ext*/);
                            var physicalPath = Path.Combine(Server.MapPath(dirToSaveFiles), fileName);
                            file.SaveAs(physicalPath);

                            saveImageUploadedInDB(catId, actId, fileName);
                        }
                    }
                }
            }
            catch(Exception e)
            {
                MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;
                LogError log = new LogError();
                log.RecordError(e, usuario.UserInfo.Ident.Value);
                //return Content(e.Message);
                //return Content( e.ToString() );
                //return Content( Json(e.ToString()).ToString() );
            }
        }

        public ActionResult saveImageUploadedInDB(int CatProDeproId, int ActionId, string imageName/*, string userName*/)
        {
            try
            {
                MyCustomIdentity usuarioadmin = (MyCustomIdentity) User.Identity;

                string dirToSaveFiles = (ConfigurationManager.AppSettings["PathImage"]).ToString();//"~/Content/images/Clerical/";
                string dirToSaveFilesView = (ConfigurationManager.AppSettings["PathImageView"]).ToString();
                TraClericalImages file = new TraClericalImages();

                var request_current = HttpContext.Request;
                var urlBase = string.Format("{0}://{1}{2}", request_current.Url.Scheme, request_current.Url.Authority, (new System.Web.Mvc.UrlHelper(request_current.RequestContext)).Content(dirToSaveFiles));
                var dns = Request.Url.Authority;
                var anyUrl = String.Format("{0}://{1}{2}", Request.Url.Scheme, Request.Url.Authority, Url.Content(dirToSaveFilesView));

                file.Active = true;
                file.CatProDeproId = CatProDeproId;
                file.ActionId = ActionId;
                //file.CreatedByUserName = userName;
                //file.CreatedDate = 
                //file.CreatedFromPCName = 
                file.Description = imageName;
                //file.EmployeeId = CCMSID;
                file.FileName = imageName;
                //file.ImageId = 
                file.ImagePlaceHolder = true;
                //file.ImageUrl = VirtualPathUtility.ToAbsolute("~/App_Data/" + imageName);
                file.ImageUrl = anyUrl + imageName; //dns + imageName; //urlBase + imageName; //relative physical path
                file.ImageUrlGrid = Url.Content(dirToSaveFiles) + imageName; //absolute physical path
                file.Path = Server.MapPath(dirToSaveFiles + imageName);

                using (InformationSecurityEntities context = new InformationSecurityEntities())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    var resultInt = context.TraClericalImagesIns(
                        //file.EmployeeId,
                        file.CatProDeproId,
                        file.ActionId,
                        //file.CreatedByUserName,
                        usuarioadmin.UserInfo.Ident.Value,
                        file.Description,
                        file.ImagePlaceHolder,
                        file.Path,
                        file.FileName,
                        file.Active,
                        file.ImageUrl,
                        file.ImageUrlGrid
                        );
                    //DataSourceResult ok = list.ToDataSourceResult(request);
                    return Json(resultInt);
                }
            }
            catch (Exception ex)
            {
                MyCustomIdentity usuario = (MyCustomIdentity) User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }
    }
}