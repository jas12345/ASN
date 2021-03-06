﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using ASN.Models;
using System.Configuration;
using System.IO;
using System.Reflection;
using System.Diagnostics;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace ASN.Controllers
{
    [Authorize(Roles = "Responsable")]
    public class ReporteParaCognosController : Controller
    {
        // GET: EnviaArchivoNomina
        public ActionResult Index()
        {
            ViewBag.MostrarPais = 0;
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            using (ASNContext ctx = new ASNContext())
            {
                ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                var lista = ctx.CatCountryByTipoAccesoCMB(usuario.UserInfo.Ident.Value, 3).ToList();
                if (lista.Count > 1)
                {
                    ViewBag.MostrarPais = 1;
                }
            }
            return View();
        }

        /// <summary>
        /// Método que devuelve periodos de nomina para un ComboBox
        /// </summary>
        /// <returns></returns>
        public JsonResult GetPeriodoNominaCMB(int? active, int? PaisId)
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var listPeriodoNomina = new List<CatPeriodosNominaCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listPeriodoNomina = context.CatPeriodosNominaCMB(active,usuario.UserInfo.Ident.Value, PaisId).ToList();
                }

                return Json(listPeriodoNomina, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public JsonResult GetEmpresaCMB()
        {
            try
            {
                var listEmpresa = new List<CatEmpresaByResponsableCMB_Result>();
                using (ASNContext context = new ASNContext())
                {
                    MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;

                    context.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    listEmpresa = context.CatEmpresaByResponsableCMB(usuario.UserInfo.Ident.Value).ToList();
                }
                return Json(listEmpresa, JsonRequestBehavior.AllowGet);

            }
            catch (Exception ex)
            {

                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }

        public FileContentResult EnviaArchivo(int? PeriodoNominaIdSelected, string periodoNominaNombre, int EmpresaId)
        {
            var estado          = string.Empty;
            var mensajeAccion   = string.Empty;
            string IP           = Request.UserHostAddress;
            string empresa      = string.Empty;

            try
            {
                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                var contador = 1;
                var FechaDeCreacion = DateTime.Now.ToString("yyyyMMdd");
                var unidad = ConfigurationManager.AppSettings["Unidad"] + ":";
                var extension = ".csv";
                var Resultado = new List<ReporteParaCognos_Result>();
                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    Resultado = ctx.ReporteParaCognos(PeriodoNominaIdSelected,EmpresaId).ToList();
                }

                var bonosArchivo = new List<RafToolObj1>();

                var p1 = new RafToolObj1();

                p1.Payroll_Processed = "Payroll_Processed";
                p1.Payroll_Period = "Payroll_Period";
                p1.CCMSID = "CCMSID";
                p1.Type = "Type";
                p1.Amount = "Amount";
                p1.Detail = "Detail";
                p1.Concept = "Concept";
                p1.Error = "Error";
                p1.Responsible_of_requests_name = "Responsible_of_requests_name";
                p1.Responsible_of_requests_Department = "Responsible_of_requests_Department";
                p1.Responsible_of_requests_Position = "Responsible_of_requests_Position";
                p1.Descripcion = "Descripcion";
                p1.Manger_ID = "Manger_ID";
                p1.Nombre = "Nombre";
               

                bonosArchivo.Add(p1);

                if (Resultado.Count > 0)
                {

                    foreach (var obj in Resultado)
                    {
                        //string numeroDeSemana = obj.T_EX_DOB_SEM.ToString() == "1" ? "1" : "";
                        
                        var bono = new RafToolObj1();

                        bono.Payroll_Processed                  = obj.Payroll_Processed;
                        bono.Payroll_Period                     = obj.Payroll_Period;
                        bono.CCMSID                             = obj.CCMSID.ToString();
                        bono.Type                               = obj.Type;
                        bono.Amount                             = obj.Amount;
                        bono.Detail                             = obj.Detail;
                        bono.Concept                            = obj.Concept;
                        bono.Error                              = obj.Error;
                        bono.Responsible_of_requests_name       = obj.Responsible_of_requests_name;
                        bono.Responsible_of_requests_Department = obj.Responsible_of_requests_Department;
                        bono.Responsible_of_requests_Position   = obj.Responsible_of_requests_Position;
                        bono.Descripcion                        = obj.Descripcion;
                        bono.Manger_ID                          = obj.Manger_ID.ToString();
                        bono.Nombre                             = obj.Nombre;
                        empresa                                 = obj.Empresa;

                        bonosArchivo.Add(bono);

                        //Estos dos siempre van juntos cuando se ponga el concepto de “T EX DOB SEM” siempre 
                        //debe ir acompañado de “T EXTRA EXEN” además de que en la columna de semana siempre va 
                        //el número 1 en ambos conceptos. Para el concepto “T EXTRA EXEN” la columna unidad va vacia.
                        //-Mireya Cavazos  Diciembre 2019
                        //if (obj.T_EX_DOB_SEM.ToString() == "1")
                        //{
                        //    var bonoTExtra = new RafToolObj();

                        //    bonoTExtra.Empleado = obj.EMPLEADO.ToString();
                        //    bonoTExtra.Reg = obj.REG;
                        //    bonoTExtra.Concepto = obj.T_EXTRA_EXEN;
                        //    bonoTExtra.Accion = obj.ACCION;
                        //    bonoTExtra.Unidad = "";
                        //    bonoTExtra.Importe = obj.IMPORTE;
                        //    bonoTExtra.Porcentaje = obj.PORCENTAJE;
                        //    bonoTExtra.Fecha = obj.FECHA;
                        //    bonoTExtra.Semana = numeroDeSemana;
                        //    bonoTExtra.Fecha_Ini = obj.FECHA_INI;
                        //    bonoTExtra.Fecha_Fin = obj.FECHA_FIN;
                        //    bonoTExtra.Duracion = obj.DURACION;
                        //    bonoTExtra.Folio = obj.FOLIO;
                        //    bonoTExtra.Consecuencia = obj.CONSECUENCIA;
                        //    bonoTExtra.Control = obj.CONTROL;

                        //    bonosArchivo.Add(bonoTExtra);
                        //}
                    }

                    var result = WriteCsvToMemory(bonosArchivo);
                    var memoryStream = new MemoryStream(result);
                    

                    /// El numero 10 es simbolicos, solo es para comprobar que tegno registros, tratandose de Miles
                    /// deberia tener mas de 10 registros pues es segun los empleados que hay en la compañia con Miles.
                    /// 
                     // 10.156.42.40 =  mty - cvo - cgn03.tpnsn.com
                    //var server = @"\\10.156.42.40\Payroll_Analysis";
                    var server = @"\\10.152.32.164\tp";
                    //var IdentificadorArchivo = "TP_INCID";
                    //var TipoNominas = "N"+ periodoNominaNombre.Substring(periodoNominaNombre.Length -1,1);
                    //var Compania = lstBonos[0].Compania.ToUpper();
                    //var ID_REP = lstBonos[0].ID_REP;
                    //var Ciudad = "ALL";
                    //var TipoIncidencia = "IMA";
                    //var folder = "//TP/INCID/013/CONTACT";
                    var FolderPath = string.Format(@" \Temp\files\{0}", periodoNominaNombre.Substring(0, 4)); // "\\files\\2021";    //lstBonos[0].Folder.ToUpper();
                    //var FolderPathSubtring = folder.Substring(4, folder.Length - 4);
                    var nombreArchivo = string.Format("MO_{2}_{0}{1}", periodoNominaNombre,extension,empresa);     //IdentificadorArchivo + "_" + TipoNominas + "_" + Compania + "_" + ID_REP + "_" + Ciudad + "_" + TipoIncidencia + "_" + FechaDeCreacion + extension;
                   
                    var serverPath = server + FolderPath + "\\" + nombreArchivo;
                    var filePath = "z:" + FolderPath + "/" + nombreArchivo;
                    //ExecuteCommand(command, 5000);
                    
                

                    NetworkDrive1 oNetDrive = new NetworkDrive1();
                    oNetDrive.Force = true;
                    oNetDrive.Persistent = true;
                    oNetDrive.LocalDrive = "z";
                    oNetDrive.PromptForCredentials = false;
                    oNetDrive.ShareName = server; //@"\\10.156.42.40\\Payroll_Analysis";
                    oNetDrive.SaveCredentials = false;
                    oNetDrive.MapDrive("tpmty\\peoplesoft.web", "Renovacion2016");


                    //using (FileStream fs = new FileStream("Z:\\MILES\\ML_Miles_" + FechaDeCreacion + ".csv", FileMode.Create))
                    //using (FileStream fs = new FileStream("C:" + "//RafArchivo/basura/basuron" + "/" + nombreArchivo, FileMode.Create))
                    using (FileStream fs = new FileStream(filePath, FileMode.Create))
                    {
                        //numerin++;
                        memoryStream.Seek(0, SeekOrigin.Begin);
                        memoryStream.CopyTo(fs);
                        fs.Flush();

                    }
                   
                    oNetDrive.UnMapDrive();

                    estado = "Exitoso";
                    mensajeAccion = string.Format("Archivo {0} enviado con éxito", nombreArchivo);

                    return File(memoryStream.ToArray(), "application/csv", nombreArchivo);
                }
                else
                {
                    return null;
                }
            }
            catch (Exception ex)
            {

                MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                mensajeAccion = ex.Message;
                estado = "-1";
                return null;
            }
            //return Json(new { status = estado, mensaje = mensajeAccion }, JsonRequestBehavior.AllowGet);

        }
        public byte[] WriteCsvToMemory(IEnumerable<RafToolObj1> records)
        {


            using (var memoryStream = new MemoryStream())
            using (var streamWriter = new StreamWriter(memoryStream,System.Text.Encoding.Default))
            //using (var csvWriter = new CsvWriter(streamWriter))
            {
                Type itemType = typeof(RafToolObj1);
                var props = itemType.GetProperties(BindingFlags.Public | BindingFlags.Instance);
                //.OrderBy(p => p.Name);

                //streamWriter.WriteLine(string.Join(", ", props.Select(p => p.Name)));

                foreach (var item in records)
                {
                    streamWriter.WriteLine(string.Join(",", props.Select(p => p.GetValue(item, null))));
                }

                //csvWriter.WriteRecords(records);
                //streamWriter.WriteLine(records);
                streamWriter.Flush();
                return memoryStream.ToArray();
            }
        }
        public static int ExecuteCommand(string command, int timeout)
        {
            var processInfo = new ProcessStartInfo("net.exe", "/C " + command)
            {
                CreateNoWindow = true,
                UseShellExecute = false,
                WorkingDirectory = "C:\\",
            };

            var process = Process.Start(processInfo);
            process.WaitForExit(timeout);
            var exitCode = process.ExitCode;
            process.Close();
            return exitCode;
        }
        public static void SaveACopyfileToServer(string filePath, string savePath)
        {
            var directory = Path.GetDirectoryName(savePath).Trim();
            var username = "tpmty\\peoplesoft.web";
            var password = "Renovacion2016";
            var filenameToSave = Path.GetFileName(savePath);
            //var filenameToSave = Path.GetFileName(@"C:\INCID\008\HTG_CEN\Test.txt"); 
            if (!directory.EndsWith("\\"))
                filenameToSave = "\\" + filenameToSave;

            var command = "NET USE " + directory + " /user:" + username + " " + password;
            ExecuteCommand(command, 5000);

            command = " copy \"" + filePath + "\"  \"" + directory + filenameToSave + "\"";

            ExecuteCommand(command, 5000);
        }

        public JsonResult GetCountryByTipoAccesoCMB()
        {
            MyCustomIdentity usuario = (MyCustomIdentity)User.Identity;
            try
            {
                var lstCMB = new List<CatCountryByTipoAccesoCMB_Result>();

                using (ASNContext ctx = new ASNContext())
                {
                    ctx.Database.CommandTimeout = int.Parse(ConfigurationManager.AppSettings["TimeOutMinutes"]);
                    lstCMB = ctx.CatCountryByTipoAccesoCMB(usuario.UserInfo.Ident.Value, 3).ToList();
                }

                return Json(lstCMB, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {

                LogError log = new LogError();
                log.RecordError(ex, usuario.UserInfo.Ident.Value);
                return Json("");
            }
        }
    }
   
    
    public class RafToolObj1
    {
        public string Payroll_Processed { get; set; }
        public string Payroll_Period { get; set; }
        public string CCMSID { get; set; }
        public string Type { get; set; }
        public string Amount { get; set; }
        public string Detail { get; set; }
        public string Concept { get; set; }
        public string Error { get; set; }
        public string Responsible_of_requests_name { get; set; }
        public string Responsible_of_requests_Department { get; set; }
        public string Responsible_of_requests_Position { get; set; }
        public string Descripcion { get; set; }
        public string Manger_ID { get; set; }
        public string Nombre { get; set; }
       
    }

    public class NetworkDrive1
    {

        #region API
        [DllImport("mpr.dll")] private static extern int WNetAddConnection2A(ref structNetResource pstNetRes, string psPassword, string psUsername, int piFlags);
        [DllImport("mpr.dll")] private static extern int WNetCancelConnection2A(string psName, int piFlags, int pfForce);
        [DllImport("mpr.dll")] private static extern int WNetConnectionDialog(int phWnd, int piType);
        [DllImport("mpr.dll")] private static extern int WNetDisconnectDialog(int phWnd, int piType);
        [DllImport("mpr.dll")] private static extern int WNetRestoreConnectionW(int phWnd, string psLocalDrive);

        [StructLayout(LayoutKind.Sequential)]
        private struct structNetResource
        {
            public int iScope;
            public int iType;
            public int iDisplayType;
            public int iUsage;
            public string sLocalName;
            public string sRemoteName;
            public string sComment;
            public string sProvider;
        }

        private const int RESOURCETYPE_DISK = 0x1;

        //Standard	
        private const int CONNECT_INTERACTIVE = 0x00000008;
        private const int CONNECT_PROMPT = 0x00000010;
        private const int CONNECT_UPDATE_PROFILE = 0x00000001;
        //IE4+
        private const int CONNECT_REDIRECT = 0x00000080;
        //NT5 only
        private const int CONNECT_COMMANDLINE = 0x00000800;
        private const int CONNECT_CMD_SAVECRED = 0x00001000;

        #endregion

        #region Propertys and options
        private bool lf_SaveCredentials = false;
        /// <summary>
        /// Option to save credentials are reconnection...
        /// </summary>
        public bool SaveCredentials
        {
            get { return (lf_SaveCredentials); }
            set { lf_SaveCredentials = value; }
        }
        private bool lf_Persistent = false;
        /// <summary>
        /// Option to reconnect drive after log off / reboot ...
        /// </summary>
        public bool Persistent
        {
            get { return (lf_Persistent); }
            set { lf_Persistent = value; }
        }
        private bool lf_Force = false;
        /// <summary>
        /// Option to force connection if drive is already mapped...
        /// or force disconnection if network path is not responding...
        /// </summary>
        public bool Force
        {
            get { return (lf_Force); }
            set { lf_Force = value; }
        }
        private bool ls_PromptForCredentials = false;
        /// <summary>
        /// Option to prompt for user credintals when mapping a drive
        /// </summary>
        public bool PromptForCredentials
        {
            get { return (ls_PromptForCredentials); }
            set { ls_PromptForCredentials = value; }
        }

        private string ls_Drive = "s:";
        /// <summary>
        /// Drive to be used in mapping / unmapping...
        /// </summary>
        public string LocalDrive
        {
            get { return (ls_Drive); }
            set
            {
                if (value.Length >= 1)
                {
                    ls_Drive = value.Substring(0, 1) + ":";
                }
                else
                {
                    ls_Drive = "";
                }
            }
        }
        private string ls_ShareName = "\\\\Computer\\C$";
        /// <summary>
        /// Share address to map drive to.
        /// </summary>
        public string ShareName
        {
            get { return (ls_ShareName); }
            set { ls_ShareName = value; }
        }
        #endregion

        #region Function mapping
        /// <summary>
        /// Map network drive
        /// </summary>
        public void MapDrive() { zMapDrive(null, null); }
        /// <summary>
        /// Map network drive (using supplied Password)
        /// </summary>
        public void MapDrive(string Password) { zMapDrive(null, Password); }
        /// <summary>
        /// Map network drive (using supplied Username and Password)
        /// </summary>
        public void MapDrive(string Username, string Password) { zMapDrive(Username, Password); }
        /// <summary>
        /// Unmap network drive
        /// </summary>
        public void UnMapDrive() { zUnMapDrive(this.lf_Force); }
        /// <summary>
        /// Check / restore persistent network drive
        /// </summary>
        public void RestoreDrives() { zRestoreDrive(); }
        /// <summary>
        /// Display windows dialog for mapping a network drive
        /// </summary>
        public void ShowConnectDialog(Form ParentForm) { zDisplayDialog(ParentForm, 1); }
        /// <summary>
        /// Display windows dialog for disconnecting a network drive
        /// </summary>
        public void ShowDisconnectDialog(Form ParentForm) { zDisplayDialog(ParentForm, 2); }


        #endregion

        #region Core functions

        // Map network drive
        private void zMapDrive(string psUsername, string psPassword)
        {
            //create struct data
            structNetResource stNetRes = new structNetResource();
            stNetRes.iScope = 2;
            stNetRes.iType = RESOURCETYPE_DISK;
            stNetRes.iDisplayType = 3;
            stNetRes.iUsage = 1;
            stNetRes.sRemoteName = ls_ShareName;
            stNetRes.sLocalName = ls_Drive;
            //prepare params
            int iFlags = 0;
            if (lf_SaveCredentials) { iFlags += CONNECT_CMD_SAVECRED; }
            if (lf_Persistent) { iFlags += CONNECT_UPDATE_PROFILE; }
            if (ls_PromptForCredentials) { iFlags += CONNECT_INTERACTIVE + CONNECT_PROMPT; }
            if (psUsername == "") { psUsername = null; }
            if (psPassword == "") { psPassword = null; }
            //if force, unmap ready for new connection
            if (lf_Force) { try { zUnMapDrive(true); } catch { } }
            //call and return
            int i = WNetAddConnection2A(ref stNetRes, psPassword, psUsername, iFlags);
            if (i > 0) { throw new System.ComponentModel.Win32Exception(i); }
        }

        // Unmap network drive
        private void zUnMapDrive(bool pfForce)
        {
            //call unmap and return
            int iFlags = 0;
            if (lf_Persistent) { iFlags += CONNECT_UPDATE_PROFILE; }
            int i = WNetCancelConnection2A(ls_Drive, iFlags, Convert.ToInt32(pfForce));
            if (i > 0) { throw new System.ComponentModel.Win32Exception(i); }
        }
        // Check / Restore a network drive
        private void zRestoreDrive()
        {
            //call restore and return
            int i = WNetRestoreConnectionW(0, null);
            if (i > 0) { throw new System.ComponentModel.Win32Exception(i); }
        }
        // Display windows dialog
        private void zDisplayDialog(Form poParentForm, int piDialog)
        {
            int i = -1;
            int iHandle = 0;
            //get parent handle
            if (poParentForm != null)
            {
                iHandle = poParentForm.Handle.ToInt32();
            }
            //show dialog
            if (piDialog == 1)
            {
                i = WNetConnectionDialog(iHandle, RESOURCETYPE_DISK);
            }
            else if (piDialog == 2)
            {
                i = WNetDisconnectDialog(iHandle, RESOURCETYPE_DISK);
            }
            if (i > 0) { throw new System.ComponentModel.Win32Exception(i); }
            //set focus on parent form
            poParentForm.BringToFront();
        }


        #endregion

    }
}