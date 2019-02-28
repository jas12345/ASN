using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace ASN.Controllers
{
    public class SeguridadController : Controller
    {
        // GET: Seguridad
        public ActionResult Index()
        {
            return View();
        }

        // GET: Seguridad/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: Seguridad/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Seguridad/Create
        [HttpPost]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Seguridad/Edit/5
        public ActionResult Edit(int id)
        {
            return View();
        }

        // POST: Seguridad/Edit/5
        [HttpPost]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        // GET: Seguridad/Delete/5
        public ActionResult Delete(int id)
        {
            return View();
        }

        // POST: Seguridad/Delete/5
        [HttpPost]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
