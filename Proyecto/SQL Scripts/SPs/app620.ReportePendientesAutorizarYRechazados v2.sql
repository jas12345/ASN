USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[ReportePendientesAutorizarYRechazados]    Script Date: 11/9/2020 3:13:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Victor Montes
-- Create date: 06-11-2020
-- Description:	reporte pendientes de autorizar y rechazados
-- =============================================
ALTER PROCEDURE [app620].[ReportePendientesAutorizarYRechazados]
	@PeriodoNominaId INT = NULL,
	@Empresa INT =NULL
AS
BEGIN
	set @PeriodoNominaId = ISNULL(@PeriodoNominaId, '-1')
	set @Empresa = ISNULL(@Empresa,'-1')

	SELECT
		CONCAT((
		 CONVERT(date,pn.fechainicio)),' al ',
		 (CONVERT(date,pn.fechafin)))AS PeriodoNomina,
		 cs.FolioSolicitud,
		 count(cs.Empleado_Ident)as Incidencias,
		 vw.Location_Name,
		 cc.Descripcion as Concepto,
		 CASE WHEN cs.EstatusSolicitudId='PA'
				THEN 'Pendiente Autorizar'
			 WHEN cs.EstatusSolicitudId='R'
				THEN 'Rechazado'
		 END AS Estatus,
		 CASE WHEN cs.EstatusSolicitudId='PA'
				THEN 
		 	 (SELECT 
			 sum(ses.ParametroConceptoMonto)
			   from [app620].[CatEmpleadosSolicitudes] ses
			  inner join app620.CatEmployeeCCMSAllVw ss
			  on ses.Empleado_Ident = ss.Ident
			  inner join app620.CatConceptos cmm
			  on ses.ConceptoId=cmm.ConceptoId
			  where ses.FolioSolicitud=cs.FolioSolicitud
			  AND ss.Location_Name=vw.Location_Name
			  AND cmm.ConceptoId=cs.ConceptoId
			  AND cs.EstatusSolicitudId='PA')
			WHEN cs.EstatusSolicitudId='R'
			THEN
			(SELECT 
			 sum(ses.ParametroConceptoMonto)
			   from [app620].[CatEmpleadosSolicitudes] ses
			  inner join app620.CatEmployeeCCMSAllVw ss
			  on ses.Empleado_Ident = ss.Ident
			  inner join app620.CatConceptos cmm
			  on ses.ConceptoId=cmm.ConceptoId
			  where ses.FolioSolicitud=cs.FolioSolicitud
			  AND ss.Location_Name=vw.Location_Name
			  AND cmm.ConceptoId=cs.ConceptoId
			  AND ses.EstatusSolicitudId ='R')
		 END as Importe,
		 CASE WHEN cs.EstatusSolicitudId='PA'
			THEN
			 (SELECT 
			 Convert(varchar,Count (ea.FolioSolicitud),5)+' '+evw.Nombre + ', '
			  from [app620].[CatSolicitudEmpleadosAutorizantes]ea
			  INNER JOIN [app620].[CatEmployeeCCMSAllVw] evw
			  on ea.Autorizador_Ident=evw.Ident
			 where ea.Pendiente=1 and ea.FolioSolicitud=cs.FolioSolicitud
			 ANd ea.Active=1
			 group by ea.FolioSolicitud, evw.Nombre
			 FOR XML PATH(''))	 
		 END as 'Autorizaciones Pendientes',
		 CASE WHEN cs.EstatusSolicitudId='R'
			THEN
			(SELECT 
			 Convert(varchar,Count (ea.FolioSolicitud),5)+' '+evw.Nombre + ', '
			  from [app620].[CatSolicitudEmpleadosAutorizantes]ea
			  INNER JOIN [app620].[CatEmployeeCCMSAllVw] evw
			  on ea.Autorizador_Ident=evw.Ident
			 where ea.Rechazado=1 and ea.FolioSolicitud=cs.FolioSolicitud
			 ANd ea.Active=1
			 group by ea.FolioSolicitud, evw.Nombre
			 FOR XML PATH(''))
		 END AS 'Autorizador Que Rechaza',
		 CASE WHEN cs.EstatusSolicitudId='R'
		 THEN
		 ((SELECT 
			 ea.MotivoRechazo from [app620].[CatSolicitudEmpleadosAutorizantes]ea
			  INNER JOIN [app620].[CatEmployeeCCMSVw] evw
			  on ea.Autorizador_Ident=evw.Ident
			 where Rechazado=1 and ea.FolioSolicitud=cs.FolioSolicitud
			 FOR XML PATH('')))
		 END AS 'Motivo Del Rechazo'
		 FROM app620.CatEmpleadosSolicitudes cs
		 inner join app620.CatEmployeeCCMSAllVw vw 
		 ON cs.Empleado_Ident=vw.Ident
		 INNER JOIN [app620].[CatIdEmpresaXCCMSContractVw] c WITH (NOLOCK) 
		 on vw.Contract_Type_Ident = c.Contract_Type_Ident AND c.SiteId IS NULL
	     INNER JOIN [app620].[CatCompaniaXIdEmpresaVw] d WITH (NOLOCK) 
		 on c.CIA_IDReporteo = d.CIA_IDReporteo AND c.ID_Empresa = d.ID_Empresa
		 INNER JOIN app620.CatSolicitudes ss
		 on cs.FolioSolicitud = ss.FolioSolicitud
		 inner join app620.CatPeriodosNomina pn
		 ON ss.PeriodoNominaId = pn.PeriodoNominaId
		 INNER JOIN [app620].CatConceptos cc
		 ON cs.ConceptoId =cc.ConceptoId
		 WHERE cs.Active=1 AND cs.EstatusSolicitudId in('PA','R')
		 AND (ss.PeriodoNominaId=@PeriodoNominaId OR @PeriodoNominaId='-1')
		 AND (d.CompañiaXIdEmpresaId =@Empresa OR @Empresa='-1')
		  -- and cs.FolioSolicitud=51
		 group by vw.Location_Name
		 ,pn.FechaInicio
		 ,pn.FechaFin
		 ,cc.Descripcion
		 ,cs.FolioSolicitud
		 ,cs.EstatusSolicitudId
		 ,cs.ConceptoId
		 Order by cs.FolioSolicitud
END
