﻿//------------------------------------------------------------------------------
// <auto-generated>
//     Este código se generó a partir de una plantilla.
//
//     Los cambios manuales en este archivo pueden causar un comportamiento inesperado de la aplicación.
//     Los cambios manuales en este archivo se sobrescribirán si se regenera el código.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ASN.Models
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.Core.Objects;
    using System.Linq;
    
    public partial class ASNContext : DbContext
    {
        public ASNContext()
            : base("name=ASNContext")
        {
        }
    
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            throw new UnintentionalCodeFirstException();
        }
    
        public virtual DbSet<CatConcepto> CatConceptos { get; set; }
        public virtual DbSet<RelConceptoPai> RelConceptoPais { get; set; }
        public virtual DbSet<sysdiagram> sysdiagrams { get; set; }
        public virtual DbSet<CatEstatusConceptos> CatEstatusConceptos { get; set; }
        public virtual DbSet<CatParametroConceptos> CatParametroConceptos { get; set; }
        public virtual DbSet<CatPeriodicidadNomina> CatPeriodicidadNomina { get; set; }
        public virtual DbSet<CatTipoConceptos> CatTipoConceptos { get; set; }
        public virtual DbSet<CatTiposPeriodo> CatTiposPeriodo { get; set; }
        public virtual DbSet<RelUserRole> RelUserRole { get; set; }
        public virtual DbSet<CatEmployeeCCMSVw> CatEmployeeCCMSVw { get; set; }
        public virtual DbSet<CatRole> CatRole { get; set; }
        public virtual DbSet<CatPeriodosNomina> CatPeriodosNomina { get; set; }
        public virtual DbSet<CatConcecutivoPeriodicidad> CatConcecutivoPeriodicidad { get; set; }
        public virtual DbSet<CatConcecutivoPeriodos> CatConcecutivoPeriodos { get; set; }
        public virtual DbSet<CatMeses> CatMeses { get; set; }
        public virtual DbSet<CatAniosNomina> CatAniosNomina { get; set; }
        public virtual DbSet<CatMesesNomina> CatMesesNomina { get; set; }
        public virtual DbSet<CatLogError> CatLogError { get; set; }
    
        public virtual ObjectResult<CatClientCMB_Result> CatClientCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatClientCMB_Result>("CatClientCMB");
        }
    
        public virtual ObjectResult<CatConceptosCMB_Result> CatConceptosCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatConceptosCMB_Result>("CatConceptosCMB");
        }
    
        public virtual ObjectResult<CatConceptosSel_Result> CatConceptosSel()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatConceptosSel_Result>("CatConceptosSel");
        }
    
        public virtual int CatConceptosSi(string descripcion, Nullable<int> tipoConcepto, Nullable<int> userEmployeeId, ObjectParameter estatus)
        {
            var descripcionParameter = descripcion != null ?
                new ObjectParameter("Descripcion", descripcion) :
                new ObjectParameter("Descripcion", typeof(string));
    
            var tipoConceptoParameter = tipoConcepto.HasValue ?
                new ObjectParameter("TipoConcepto", tipoConcepto) :
                new ObjectParameter("TipoConcepto", typeof(int));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatConceptosSi", descripcionParameter, tipoConceptoParameter, userEmployeeIdParameter, estatus);
        }
    
        public virtual int CatConceptosSu(Nullable<int> conceptoId, string descripcion, Nullable<int> tipoConcepto, Nullable<int> userEmployeeId, Nullable<bool> active, ObjectParameter estatus)
        {
            var conceptoIdParameter = conceptoId.HasValue ?
                new ObjectParameter("ConceptoId", conceptoId) :
                new ObjectParameter("ConceptoId", typeof(int));
    
            var descripcionParameter = descripcion != null ?
                new ObjectParameter("Descripcion", descripcion) :
                new ObjectParameter("Descripcion", typeof(string));
    
            var tipoConceptoParameter = tipoConcepto.HasValue ?
                new ObjectParameter("TipoConcepto", tipoConcepto) :
                new ObjectParameter("TipoConcepto", typeof(int));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            var activeParameter = active.HasValue ?
                new ObjectParameter("Active", active) :
                new ObjectParameter("Active", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatConceptosSu", conceptoIdParameter, descripcionParameter, tipoConceptoParameter, userEmployeeIdParameter, activeParameter, estatus);
        }
    
        public virtual ObjectResult<CatCountryCMB_Result> CatCountryCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatCountryCMB_Result>("CatCountryCMB");
        }
    
        public virtual ObjectResult<CatParametroConceptosCMB_Result> CatParametroConceptosCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatParametroConceptosCMB_Result>("CatParametroConceptosCMB");
        }
    
        public virtual ObjectResult<CatPeriodicidadNominaCMB_Result> CatPeriodicidadNominaCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatPeriodicidadNominaCMB_Result>("CatPeriodicidadNominaCMB");
        }
    
        public virtual ObjectResult<CatPeriodicidadNominaSel_Result> CatPeriodicidadNominaSel()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatPeriodicidadNominaSel_Result>("CatPeriodicidadNominaSel");
        }
    
        public virtual int CatPeriodicidadNominaSi(string periodicidadNominaId, string descripcion, Nullable<int> userEmployeeId, ObjectParameter estatus)
        {
            var periodicidadNominaIdParameter = periodicidadNominaId != null ?
                new ObjectParameter("PeriodicidadNominaId", periodicidadNominaId) :
                new ObjectParameter("PeriodicidadNominaId", typeof(string));
    
            var descripcionParameter = descripcion != null ?
                new ObjectParameter("Descripcion", descripcion) :
                new ObjectParameter("Descripcion", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatPeriodicidadNominaSi", periodicidadNominaIdParameter, descripcionParameter, userEmployeeIdParameter, estatus);
        }
    
        public virtual int CatPeriodicidadNominaSu(string periodicidadNominaId, string descripcion, Nullable<int> userEmployeeId, Nullable<bool> active, ObjectParameter estatus)
        {
            var periodicidadNominaIdParameter = periodicidadNominaId != null ?
                new ObjectParameter("PeriodicidadNominaId", periodicidadNominaId) :
                new ObjectParameter("PeriodicidadNominaId", typeof(string));
    
            var descripcionParameter = descripcion != null ?
                new ObjectParameter("Descripcion", descripcion) :
                new ObjectParameter("Descripcion", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            var activeParameter = active.HasValue ?
                new ObjectParameter("Active", active) :
                new ObjectParameter("Active", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatPeriodicidadNominaSu", periodicidadNominaIdParameter, descripcionParameter, userEmployeeIdParameter, activeParameter, estatus);
        }
    
        public virtual ObjectResult<CatProgramCMB_Result> CatProgramCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatProgramCMB_Result>("CatProgramCMB");
        }
    
        public virtual ObjectResult<CatRelUserRoleSel_Result> CatRelUserRoleSel(Nullable<int> cCMSID)
        {
            var cCMSIDParameter = cCMSID.HasValue ?
                new ObjectParameter("CCMSID", cCMSID) :
                new ObjectParameter("CCMSID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatRelUserRoleSel_Result>("CatRelUserRoleSel", cCMSIDParameter);
        }
    
        public virtual ObjectResult<CatTipoConceptosCMB_Result> CatTipoConceptosCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatTipoConceptosCMB_Result>("CatTipoConceptosCMB");
        }
    
        public virtual ObjectResult<CatTiposPeriodoCMB_Result> CatTiposPeriodoCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatTiposPeriodoCMB_Result>("CatTiposPeriodoCMB");
        }
    
        public virtual ObjectResult<CatTiposPeriodoSel_Result> CatTiposPeriodoSel()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatTiposPeriodoSel_Result>("CatTiposPeriodoSel");
        }
    
        public virtual int CatTiposPeriodoSi(string tipoPeriodoId, string descripcion, Nullable<int> userEmployeeId, ObjectParameter estatus)
        {
            var tipoPeriodoIdParameter = tipoPeriodoId != null ?
                new ObjectParameter("TipoPeriodoId", tipoPeriodoId) :
                new ObjectParameter("TipoPeriodoId", typeof(string));
    
            var descripcionParameter = descripcion != null ?
                new ObjectParameter("Descripcion", descripcion) :
                new ObjectParameter("Descripcion", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatTiposPeriodoSi", tipoPeriodoIdParameter, descripcionParameter, userEmployeeIdParameter, estatus);
        }
    
        public virtual int CatTiposPeriodoSu(string tipoPeriodoId, string descripcion, Nullable<int> userEmployeeId, Nullable<bool> active, ObjectParameter estatus)
        {
            var tipoPeriodoIdParameter = tipoPeriodoId != null ?
                new ObjectParameter("TipoPeriodoId", tipoPeriodoId) :
                new ObjectParameter("TipoPeriodoId", typeof(string));
    
            var descripcionParameter = descripcion != null ?
                new ObjectParameter("Descripcion", descripcion) :
                new ObjectParameter("Descripcion", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            var activeParameter = active.HasValue ?
                new ObjectParameter("Active", active) :
                new ObjectParameter("Active", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatTiposPeriodoSu", tipoPeriodoIdParameter, descripcionParameter, userEmployeeIdParameter, activeParameter, estatus);
        }
    
        public virtual ObjectResult<CatUserInfoSel_Result> CatUserInfoSel(Nullable<int> cCMSID)
        {
            var cCMSIDParameter = cCMSID.HasValue ?
                new ObjectParameter("CCMSID", cCMSID) :
                new ObjectParameter("CCMSID", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatUserInfoSel_Result>("CatUserInfoSel", cCMSIDParameter);
        }
    
        public virtual int CatLogErrorSi(string logErrorMessage, string stackTrace, string ipAddress, string browser, Nullable<int> createdBy)
        {
            var logErrorMessageParameter = logErrorMessage != null ?
                new ObjectParameter("LogErrorMessage", logErrorMessage) :
                new ObjectParameter("LogErrorMessage", typeof(string));
    
            var stackTraceParameter = stackTrace != null ?
                new ObjectParameter("StackTrace", stackTrace) :
                new ObjectParameter("StackTrace", typeof(string));
    
            var ipAddressParameter = ipAddress != null ?
                new ObjectParameter("IpAddress", ipAddress) :
                new ObjectParameter("IpAddress", typeof(string));
    
            var browserParameter = browser != null ?
                new ObjectParameter("Browser", browser) :
                new ObjectParameter("Browser", typeof(string));
    
            var createdByParameter = createdBy.HasValue ?
                new ObjectParameter("CreatedBy", createdBy) :
                new ObjectParameter("CreatedBy", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatLogErrorSi", logErrorMessageParameter, stackTraceParameter, ipAddressParameter, browserParameter, createdByParameter);
        }
    
        public virtual int CatAñosNominaSel()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatAñosNominaSel");
        }
    
        public virtual int CatAñosNominaSi(Nullable<int> añoId, Nullable<System.DateTime> fechaInicio, Nullable<System.DateTime> fechaCierre, Nullable<int> userEmployeeId, ObjectParameter estatus)
        {
            var añoIdParameter = añoId.HasValue ?
                new ObjectParameter("AñoId", añoId) :
                new ObjectParameter("AñoId", typeof(int));
    
            var fechaInicioParameter = fechaInicio.HasValue ?
                new ObjectParameter("FechaInicio", fechaInicio) :
                new ObjectParameter("FechaInicio", typeof(System.DateTime));
    
            var fechaCierreParameter = fechaCierre.HasValue ?
                new ObjectParameter("FechaCierre", fechaCierre) :
                new ObjectParameter("FechaCierre", typeof(System.DateTime));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatAñosNominaSi", añoIdParameter, fechaInicioParameter, fechaCierreParameter, userEmployeeIdParameter, estatus);
        }
    
        public virtual int CatAñosNominaSu(Nullable<int> anioId, string fechaInicio, string fechaCierre, Nullable<int> userEmployeeId, Nullable<bool> active, ObjectParameter estatus)
        {
            var anioIdParameter = anioId.HasValue ?
                new ObjectParameter("AnioId", anioId) :
                new ObjectParameter("AnioId", typeof(int));
    
            var fechaInicioParameter = fechaInicio != null ?
                new ObjectParameter("FechaInicio", fechaInicio) :
                new ObjectParameter("FechaInicio", typeof(string));
    
            var fechaCierreParameter = fechaCierre != null ?
                new ObjectParameter("FechaCierre", fechaCierre) :
                new ObjectParameter("FechaCierre", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            var activeParameter = active.HasValue ?
                new ObjectParameter("Active", active) :
                new ObjectParameter("Active", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatAñosNominaSu", anioIdParameter, fechaInicioParameter, fechaCierreParameter, userEmployeeIdParameter, activeParameter, estatus);
        }
    
        public virtual ObjectResult<CatMesesNominaSel_Result> CatMesesNominaSel()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatMesesNominaSel_Result>("CatMesesNominaSel");
        }
    
        public virtual int CatPeriodosNominaSel(Nullable<int> año, Nullable<int> mes, string periodicidad, Nullable<int> consecutivo, string tipoPeriodo)
        {
            var añoParameter = año.HasValue ?
                new ObjectParameter("Año", año) :
                new ObjectParameter("Año", typeof(int));
    
            var mesParameter = mes.HasValue ?
                new ObjectParameter("Mes", mes) :
                new ObjectParameter("Mes", typeof(int));
    
            var periodicidadParameter = periodicidad != null ?
                new ObjectParameter("Periodicidad", periodicidad) :
                new ObjectParameter("Periodicidad", typeof(string));
    
            var consecutivoParameter = consecutivo.HasValue ?
                new ObjectParameter("Consecutivo", consecutivo) :
                new ObjectParameter("Consecutivo", typeof(int));
    
            var tipoPeriodoParameter = tipoPeriodo != null ?
                new ObjectParameter("TipoPeriodo", tipoPeriodo) :
                new ObjectParameter("TipoPeriodo", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatPeriodosNominaSel", añoParameter, mesParameter, periodicidadParameter, consecutivoParameter, tipoPeriodoParameter);
        }
    
        public virtual int CatPeriodosNominaSi(Nullable<int> año, Nullable<int> mes, string periodicidad, string consecutivo, string tipoPeriodo, Nullable<System.DateTime> fechaInicio, Nullable<System.DateTime> fechaFin, Nullable<System.DateTime> fechaCaptura, Nullable<System.DateTime> fechaCierre, string countryIdents, string nombrePeriodo, Nullable<int> userEmployeeId)
        {
            var añoParameter = año.HasValue ?
                new ObjectParameter("Año", año) :
                new ObjectParameter("Año", typeof(int));
    
            var mesParameter = mes.HasValue ?
                new ObjectParameter("Mes", mes) :
                new ObjectParameter("Mes", typeof(int));
    
            var periodicidadParameter = periodicidad != null ?
                new ObjectParameter("Periodicidad", periodicidad) :
                new ObjectParameter("Periodicidad", typeof(string));
    
            var consecutivoParameter = consecutivo != null ?
                new ObjectParameter("Consecutivo", consecutivo) :
                new ObjectParameter("Consecutivo", typeof(string));
    
            var tipoPeriodoParameter = tipoPeriodo != null ?
                new ObjectParameter("TipoPeriodo", tipoPeriodo) :
                new ObjectParameter("TipoPeriodo", typeof(string));
    
            var fechaInicioParameter = fechaInicio.HasValue ?
                new ObjectParameter("FechaInicio", fechaInicio) :
                new ObjectParameter("FechaInicio", typeof(System.DateTime));
    
            var fechaFinParameter = fechaFin.HasValue ?
                new ObjectParameter("FechaFin", fechaFin) :
                new ObjectParameter("FechaFin", typeof(System.DateTime));
    
            var fechaCapturaParameter = fechaCaptura.HasValue ?
                new ObjectParameter("FechaCaptura", fechaCaptura) :
                new ObjectParameter("FechaCaptura", typeof(System.DateTime));
    
            var fechaCierreParameter = fechaCierre.HasValue ?
                new ObjectParameter("FechaCierre", fechaCierre) :
                new ObjectParameter("FechaCierre", typeof(System.DateTime));
    
            var countryIdentsParameter = countryIdents != null ?
                new ObjectParameter("CountryIdents", countryIdents) :
                new ObjectParameter("CountryIdents", typeof(string));
    
            var nombrePeriodoParameter = nombrePeriodo != null ?
                new ObjectParameter("NombrePeriodo", nombrePeriodo) :
                new ObjectParameter("NombrePeriodo", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatPeriodosNominaSi", añoParameter, mesParameter, periodicidadParameter, consecutivoParameter, tipoPeriodoParameter, fechaInicioParameter, fechaFinParameter, fechaCapturaParameter, fechaCierreParameter, countryIdentsParameter, nombrePeriodoParameter, userEmployeeIdParameter);
        }
    
        public virtual ObjectResult<CatAniosNominaSel_Result> CatAniosNominaSel()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatAniosNominaSel_Result>("CatAniosNominaSel");
        }
    
        public virtual int CatAniosNominaSi(Nullable<int> anioId, string fechaInicio, string fechaCierre, Nullable<int> userEmployeeId, ObjectParameter estatus)
        {
            var anioIdParameter = anioId.HasValue ?
                new ObjectParameter("AnioId", anioId) :
                new ObjectParameter("AnioId", typeof(int));
    
            var fechaInicioParameter = fechaInicio != null ?
                new ObjectParameter("FechaInicio", fechaInicio) :
                new ObjectParameter("FechaInicio", typeof(string));
    
            var fechaCierreParameter = fechaCierre != null ?
                new ObjectParameter("FechaCierre", fechaCierre) :
                new ObjectParameter("FechaCierre", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatAniosNominaSi", anioIdParameter, fechaInicioParameter, fechaCierreParameter, userEmployeeIdParameter, estatus);
        }
    
        public virtual int CatAniosNominaSu(Nullable<int> anioId, string fechaInicio, string fechaCierre, Nullable<int> userEmployeeId, Nullable<bool> active, ObjectParameter estatus)
        {
            var anioIdParameter = anioId.HasValue ?
                new ObjectParameter("AnioId", anioId) :
                new ObjectParameter("AnioId", typeof(int));
    
            var fechaInicioParameter = fechaInicio != null ?
                new ObjectParameter("FechaInicio", fechaInicio) :
                new ObjectParameter("FechaInicio", typeof(string));
    
            var fechaCierreParameter = fechaCierre != null ?
                new ObjectParameter("FechaCierre", fechaCierre) :
                new ObjectParameter("FechaCierre", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            var activeParameter = active.HasValue ?
                new ObjectParameter("Active", active) :
                new ObjectParameter("Active", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatAniosNominaSu", anioIdParameter, fechaInicioParameter, fechaCierreParameter, userEmployeeIdParameter, activeParameter, estatus);
        }
    
        public virtual int sp_alterdiagram(string diagramname, Nullable<int> owner_id, Nullable<int> version, byte[] definition)
        {
            var diagramnameParameter = diagramname != null ?
                new ObjectParameter("diagramname", diagramname) :
                new ObjectParameter("diagramname", typeof(string));
    
            var owner_idParameter = owner_id.HasValue ?
                new ObjectParameter("owner_id", owner_id) :
                new ObjectParameter("owner_id", typeof(int));
    
            var versionParameter = version.HasValue ?
                new ObjectParameter("version", version) :
                new ObjectParameter("version", typeof(int));
    
            var definitionParameter = definition != null ?
                new ObjectParameter("definition", definition) :
                new ObjectParameter("definition", typeof(byte[]));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_alterdiagram", diagramnameParameter, owner_idParameter, versionParameter, definitionParameter);
        }
    
        public virtual int sp_creatediagram(string diagramname, Nullable<int> owner_id, Nullable<int> version, byte[] definition)
        {
            var diagramnameParameter = diagramname != null ?
                new ObjectParameter("diagramname", diagramname) :
                new ObjectParameter("diagramname", typeof(string));
    
            var owner_idParameter = owner_id.HasValue ?
                new ObjectParameter("owner_id", owner_id) :
                new ObjectParameter("owner_id", typeof(int));
    
            var versionParameter = version.HasValue ?
                new ObjectParameter("version", version) :
                new ObjectParameter("version", typeof(int));
    
            var definitionParameter = definition != null ?
                new ObjectParameter("definition", definition) :
                new ObjectParameter("definition", typeof(byte[]));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_creatediagram", diagramnameParameter, owner_idParameter, versionParameter, definitionParameter);
        }
    
        public virtual int sp_dropdiagram(string diagramname, Nullable<int> owner_id)
        {
            var diagramnameParameter = diagramname != null ?
                new ObjectParameter("diagramname", diagramname) :
                new ObjectParameter("diagramname", typeof(string));
    
            var owner_idParameter = owner_id.HasValue ?
                new ObjectParameter("owner_id", owner_id) :
                new ObjectParameter("owner_id", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_dropdiagram", diagramnameParameter, owner_idParameter);
        }
    
        public virtual ObjectResult<sp_helpdiagramdefinition_Result> sp_helpdiagramdefinition(string diagramname, Nullable<int> owner_id)
        {
            var diagramnameParameter = diagramname != null ?
                new ObjectParameter("diagramname", diagramname) :
                new ObjectParameter("diagramname", typeof(string));
    
            var owner_idParameter = owner_id.HasValue ?
                new ObjectParameter("owner_id", owner_id) :
                new ObjectParameter("owner_id", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_helpdiagramdefinition_Result>("sp_helpdiagramdefinition", diagramnameParameter, owner_idParameter);
        }
    
        public virtual ObjectResult<sp_helpdiagrams_Result> sp_helpdiagrams(string diagramname, Nullable<int> owner_id)
        {
            var diagramnameParameter = diagramname != null ?
                new ObjectParameter("diagramname", diagramname) :
                new ObjectParameter("diagramname", typeof(string));
    
            var owner_idParameter = owner_id.HasValue ?
                new ObjectParameter("owner_id", owner_id) :
                new ObjectParameter("owner_id", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<sp_helpdiagrams_Result>("sp_helpdiagrams", diagramnameParameter, owner_idParameter);
        }
    
        public virtual int sp_renamediagram(string diagramname, Nullable<int> owner_id, string new_diagramname)
        {
            var diagramnameParameter = diagramname != null ?
                new ObjectParameter("diagramname", diagramname) :
                new ObjectParameter("diagramname", typeof(string));
    
            var owner_idParameter = owner_id.HasValue ?
                new ObjectParameter("owner_id", owner_id) :
                new ObjectParameter("owner_id", typeof(int));
    
            var new_diagramnameParameter = new_diagramname != null ?
                new ObjectParameter("new_diagramname", new_diagramname) :
                new ObjectParameter("new_diagramname", typeof(string));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_renamediagram", diagramnameParameter, owner_idParameter, new_diagramnameParameter);
        }
    
        public virtual int sp_upgraddiagrams()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("sp_upgraddiagrams");
        }
    
        public virtual ObjectResult<CatConcecutivoPeriodicidadSel_Result> CatConcecutivoPeriodicidadSel()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatConcecutivoPeriodicidadSel_Result>("CatConcecutivoPeriodicidadSel");
        }
    
        public virtual int CatMesesNominaSi(Nullable<int> anioId, Nullable<int> mesId, string fechaInicio, string fechaCierre, Nullable<int> userEmployeeId, ObjectParameter estatus)
        {
            var anioIdParameter = anioId.HasValue ?
                new ObjectParameter("AnioId", anioId) :
                new ObjectParameter("AnioId", typeof(int));
    
            var mesIdParameter = mesId.HasValue ?
                new ObjectParameter("MesId", mesId) :
                new ObjectParameter("MesId", typeof(int));
    
            var fechaInicioParameter = fechaInicio != null ?
                new ObjectParameter("FechaInicio", fechaInicio) :
                new ObjectParameter("FechaInicio", typeof(string));
    
            var fechaCierreParameter = fechaCierre != null ?
                new ObjectParameter("FechaCierre", fechaCierre) :
                new ObjectParameter("FechaCierre", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatMesesNominaSi", anioIdParameter, mesIdParameter, fechaInicioParameter, fechaCierreParameter, userEmployeeIdParameter, estatus);
        }
    
        public virtual int CatMesesNominaSu(Nullable<int> anioId, Nullable<int> mesId, string fechaInicio, string fechaCierre, Nullable<int> userEmployeeId, Nullable<bool> active, ObjectParameter estatus)
        {
            var anioIdParameter = anioId.HasValue ?
                new ObjectParameter("AnioId", anioId) :
                new ObjectParameter("AnioId", typeof(int));
    
            var mesIdParameter = mesId.HasValue ?
                new ObjectParameter("MesId", mesId) :
                new ObjectParameter("MesId", typeof(int));
    
            var fechaInicioParameter = fechaInicio != null ?
                new ObjectParameter("FechaInicio", fechaInicio) :
                new ObjectParameter("FechaInicio", typeof(string));
    
            var fechaCierreParameter = fechaCierre != null ?
                new ObjectParameter("FechaCierre", fechaCierre) :
                new ObjectParameter("FechaCierre", typeof(string));
    
            var userEmployeeIdParameter = userEmployeeId.HasValue ?
                new ObjectParameter("UserEmployeeId", userEmployeeId) :
                new ObjectParameter("UserEmployeeId", typeof(int));
    
            var activeParameter = active.HasValue ?
                new ObjectParameter("Active", active) :
                new ObjectParameter("Active", typeof(bool));
    
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction("CatMesesNominaSu", anioIdParameter, mesIdParameter, fechaInicioParameter, fechaCierreParameter, userEmployeeIdParameter, activeParameter, estatus);
        }
    
        public virtual ObjectResult<CatAniosNominaCMB_Result> CatAniosNominaCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatAniosNominaCMB_Result>("CatAniosNominaCMB");
        }
    
        public virtual ObjectResult<CatMesesCMB_Result> CatMesesCMB()
        {
            return ((IObjectContextAdapter)this).ObjectContext.ExecuteFunction<CatMesesCMB_Result>("CatMesesCMB");
        }
    }
}
