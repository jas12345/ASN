USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[ValidaSolicitud]    Script Date: 27/06/2019 07:29:10 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[ValidaSolicitud]
(
@FolioSolicitud INT
,@Estatus INT = 0 OUTPUT
) AS
BEGIN

DECLARE @ConceptoMotivo INT = 0
		,@PeriodoOriginalId INT =0
		,@EstatusPeriodo VARCHAR(10)
		,@EstatusSolicitud VARCHAR(10)


	SELECT 
		@PeriodoOriginalId = DSE.PeriodoOriginalId
		,@EstatusSolicitud = CS.EstatusSolicitudId
		--,@ConceptoMotivo = CS.ConceptoMotivoId
	 FROM [app620].[CatSolicitudEmpleadosDetalle] DSE 
	 JOIN [app620].CatSolicitudes CS ON DSE.FolioSolicitud = CS.FolioSolicitud
	WHERE DSE.FolioSolicitud = @FolioSolicitud

 SET @EstatusPeriodo = (SELECT (CASE 
								WHEN (PN.FechaInicio >= GETDATE() AND PN.FechaFin<= GETDATE()) THEN 'En Curso' 
								WHEN (PN.FechaInicio < GETDATE() OR PN.FechaFin< GETDATE()) THEN 'Cerrado'
								WHEN (PN.FechaInicio > GETDATE() AND PN.FechaFin> GETDATE()) THEN 'Futuro'  
								END) AS Estatus 
							FROM [app620].[CatPeriodosNomina] PN
							WHERE PeriodoNominaId = @PeriodoOriginalId)

 IF((@EstatusPeriodo = 'En Curso'  OR  @EstatusPeriodo = 'Futuro') AND @EstatusSolicitud <> 'EB')
 BEGIN
	SELECT 
		CSED.Empleado_Ident 	
		,count(ConceptoMotivoId) as totalSolicitud
	FROM  [app620].[CatSolicitudes] CS
	left JOIN [app620].[CatSolicitudEmpleadosDetalle] CSED ON CS.FolioSolicitud = CSED.FolioSolicitud --AND CSED.FolioSolicitud <> 89 --
	WHERE
		CSED.ConceptoMotivoId = @ConceptoMotivo
		and CSED.Active = 1		
		AND ( CS.PeriodoNominaId = CSED.PeriodoOriginalId)
		--AND CSED.Empleado_Ident = 117253--AND CS.EstatusSolicitudId <> 'EB' --AND CSED.Empleado_Ident = 117253 	
		AND CSED.FolioSolicitud <> @FolioSolicitud AND CS.EstatusSolicitudId <> 'EB'
	GROUP BY CSED.Empleado_Ident, ConceptoMotivoId,CS.FolioSolicitud, CSED.FolioSolicitud  
 END

 END
--having count(CatConceptoMotivoId) > 1