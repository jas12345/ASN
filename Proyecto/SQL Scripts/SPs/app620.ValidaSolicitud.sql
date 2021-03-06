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
		,@PeriodoAnio INT =0
		,@PeriodoMes INT =0
		,@PeriodoConsecutivo VARCHAR(5)
		,@PeriodoPeriodicidad VARCHAR(5)
		,@PeriodoTipoPeriodo VARCHAR(5)
		,@EstatusPeriodo VARCHAR(10)
		,@EstatusSolicitud VARCHAR(10)


	SELECT 
		@PeriodoAnio = DSE.PeriodoOriginalAnio_Id
		,@PeriodoMes = DSE.PeriodoOriginalMes_Id
		,@PeriodoConsecutivo = DSE.PeriodoOriginalConsecutivoid
		,@PeriodoPeriodicidad = DSE.PeriodoOriginalPeriodicidadNomina_Id
		,@PeriodoTipoPeriodo = DSE.PeriodoOriginalTipoPeriodo_Id
		,@EstatusSolicitud = CS.EstatusSolicitudId
		,@ConceptoMotivo = CS.ConceptoMotivoId
	 FROM [app620].[CatSolicitudEmpleadosDetalle] DSE 
	 JOIN [app620].CatSolicitudes CS ON DSE.FolioSolicitud = CS.FolioSolicitud
	WHERE DSE.FolioSolicitud = @FolioSolicitud

 SET @EstatusPeriodo = (SELECT (CASE 
								WHEN (PN.FechaInicio >= GETDATE() AND PN.FechaFin<= GETDATE()) THEN 'En Curso' 
								WHEN (PN.FechaInicio < GETDATE() OR PN.FechaFin< GETDATE()) THEN 'Cerrado'
								WHEN (PN.FechaInicio > GETDATE() AND PN.FechaFin> GETDATE()) THEN 'Futuro'  
								END) AS Estatus 
							FROM [app620].[CatPeriodosNomina] PN
							WHERE AnioId = @PeriodoAnio
								AND MesId = @PeriodoMes
								AND ConsecutivoId = @PeriodoConsecutivo
								AND PeriodicidadNominaId = @PeriodoPeriodicidad 
								AND TipoPeriodo = @PeriodoTipoPeriodo)

 IF((@EstatusPeriodo = 'En Curso'  OR  @EstatusPeriodo = 'Futuro') AND @EstatusSolicitud <> 'EB')
 BEGIN
	SELECT 
		CSED.Empleado_Ident 	
		,count(CatConceptoMotivoId) as totalSolicitud
	FROM  [app620].[CatSolicitudes] CS
	left JOIN [app620].[CatSolicitudEmpleadosDetalle] CSED ON CS.FolioSolicitud = CSED.FolioSolicitud --AND CSED.FolioSolicitud <> 89 --
	WHERE
		CSED.CatConceptoMotivoId = @ConceptoMotivo
		and CSED.Active = 1		
		AND ( CS.PeriodoNominaAnio_Id = CSED.PeriodoOriginalAnio_Id 
		AND CS.PeriodoNominaMes_Id = CSED.PeriodoOriginalMes_Id 
		AND CS.PeriodoNominaConsecutivoid = CSED.PeriodoOriginalConsecutivoid 
		AND CS.PeriodoNominaTipoPeriodo_Id = CSED.PeriodoOriginalTipoPeriodo_Id)
		--AND CSED.Empleado_Ident = 117253--AND CS.EstatusSolicitudId <> 'EB' --AND CSED.Empleado_Ident = 117253 	
		AND CSED.FolioSolicitud <> @FolioSolicitud AND CS.EstatusSolicitudId <> 'EB'
	GROUP BY CSED.Empleado_Ident, CatConceptoMotivoId,CS.FolioSolicitud, CSED.FolioSolicitud  
 END

 END
--having count(CatConceptoMotivoId) > 1