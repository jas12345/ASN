USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[ReporteSolicitudXEstatusSel]    Script Date: 05/06/2020 05:25:33 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[ReporteSolicitudXEstatusSel]
--@FechaIni varchar(15) --= '2019-09-28'
--,@FechaFin varchar(15) --= '2019-10-29'
--,@City int --= 1
--,@Site int --= 317
 @Responsable_Ident int = 0--= 1286941
,@PeriodoNomina int = 0
,@EstatusSolicitud varchar(50) = '0' --= 'A'
,@EstatusConcepto varchar(50) = '0' --= 'A'

AS
BEGIN
	--DECLARE
	--@FechaIni varchar(15) --= '2019-09-28'
	--,@FechaFin varchar(15) --= '2019-10-29'
	--,@City varchar(20) --= 'Monterrey'
	--,@Site int --= 317
	--,@Solicitante int --= 1286941
	--,@EstatusSolicitud varchar(5) = 'A'
	--,@EstatusConcepto varchar(5) = 'A'

	SELECT
		 @PeriodoNomina = ISNULL(@PeriodoNomina, 0)
		,@EstatusSolicitud = ISNULL(@EstatusSolicitud, '')
		,@EstatusConcepto = ISNULL(@EstatusConcepto, '')

	SELECT
		S.FolioSolicitud As Folio,
		C.Descripcion Concepto,
		CASE
			WHEN C.ParametroConceptoId IN (3)
		--	THEN sum(EMS.ParametroConceptoMonto)
			THEN CAST(sum(EMS.ParametroConceptoMonto) AS VARCHAR(50))
			ELSE CAST(0 AS VARCHAR(50))
		END Total
		--CASE
		--	WHEN C.ParametroConceptoId IN (3)
		--	THEN --Format(sum(EMS.ParametroConceptoMonto),'##,##0')
		--	'$'+ FORMAT(sum(EMS.ParametroConceptoMonto),'##########,0.00')
		--	ELSE '$'+ FORMAT(0,'#,0.00')
		--END Total
		,r.city As Ciudad
		,b.Location_Name As Site
		,PN.NombrePeriodo Periodo
		--,convert(nvarchar(19),S.Fecha_Solicitud,120) As Fecha
		,d.Descripcion AS EstatusSol
		,CASE WHEN EMS.EstatusSolicitudId IS NOT NULL THEN
				(SELECT Descripcion FROM  [app620].[CatEstatusSolicitudes] WHERE EstatusSolicitudId = EMS.EstatusSolicitudId)
			ELSE 
				''
			END
		 AS EstatusCon
		,S.Solicitante_Ident AS SolicitanteCCMSID
	FROM [app620].[CatSolicitudes] S
		JOIN [app620].[CatEmpleadosSolicitudes] EMS ON 
			S.FolioSolicitud = EMS.FolioSolicitud
		AND 
			(S.PeriodoNominaId = @PeriodoNomina OR @PeriodoNomina = 0)
		AND
			(
				S.EstatusSolicitudId = @EstatusSolicitud 
			OR 
				@EstatusSolicitud = '' 
			)
		AND 
			(
				EMS.EstatusSolicitudId = @EstatusConcepto 
			OR 
				@EstatusConcepto = '' 
		)
		--EMS.EstatusSolicitudId = isnull(IIF(LEN(@EstatusConcepto) = 0,NULL,@EstatusConcepto),EMS.EstatusSolicitudId)

		JOIN app620.CatEmployeeCCMSVw EMP ON 
			EMP.Ident = EMS.Empleado_Ident

		--S.EstatusSolicitudId = isnull(IIF(LEN(@EstatusSolicitud) = 0,NULL,@EstatusSolicitud),S.EstatusSolicitudId)

		INNER JOIN [app620].[CatConceptos] C ON C.ConceptoId = EMS.ConceptoId
		INNER JOIN [app620].[CatConceptosPeopleSoft] PS ON PS.ConceptoId = C.PeopleSoftId
		INNER JOIN [app620].[CatPeriodosNomina] PN ON PN.PeriodoNominaId = S.PeriodoNominaId
		INNER JOIN [app620].[CatEmployeeCCMSVw] b on S.Solicitante_Ident = b.Ident
		INNER JOIN [app620].[CatRelLocationBiosCCMSVw] r on b.Location_Ident = r.location_ccms
		INNER JOIN [app620].[CatEstatusSolicitudes] d on S.EstatusSolicitudId = d.EstatusSolicitudId
		--INNER JOIN [app620].[CatEstatusSolicitudes] e on EMS.EstatusSolicitudId = d.EstatusSolicitudId
		INNER JOIN [app620].[CatPeriodosNomina] e on S.PeriodoNominaId = e.PeriodoNominaId
		
		JOIN app620.CatPerfilEmpleadosAccesos PEA ON PEA.EmpleadoId = @Responsable_Ident
		JOIN app620.CatPerfilEmpleados PE ON 
			PE.Perfil_Ident = PEA.Perfil_Ident 
		AND 
			PE.TipoAccesoId = 3 
		AND 
			PE.Active = 1
		--JOIN [app620].[CatEmployeeCCMSVw] Emp on  = b.Ident
		------JOIN [app620].[CatEmployeeCCMSVw] Emp ON 
		
		AND	(EMP.Country_Ident			= PE.Country_Ident			OR PE.Country_Ident = -1)
		AND	(EMP.Location_Ident			= PE.Location_Ident			OR PE.Location_Ident = -1)
		AND	(EMP.Client_Ident			= PE.Client_Ident			OR PE.Client_Ident = -1)
		AND	(EMP.Program_Ident			= PE.Program_Ident			OR PE.Program_Ident = -1)
		AND (EMP.Contract_Type_Ident	= PE.Contract_Type_Ident	OR PE.Contract_Type_Ident = -1)
		------AND (Emp.Ident					= EMS.Empleado_Ident)
		
		JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity
		ON 
			(
				BiosCity.location_bios		= PE.City_Ident				
			OR
				PE.City_Ident = -1
			)

		AND (BiosCity.location_ccms		= EMP.Location_Ident)

	WHERE	
		------	(S.PeriodoNominaId = @PeriodoNomina OR @PeriodoNomina = 0)
		------AND
		------	(S.EstatusSolicitudId = @EstatusSolicitud OR @EstatusSolicitud = '' OR @EstatusSolicitud = '' )
		--------S.EstatusSolicitudId = isnull(IIF(LEN(@EstatusSolicitud) = 0,NULL,@EstatusSolicitud),S.EstatusSolicitudId)
		------AND 
		------	(EMS.EstatusSolicitudId = @EstatusConcepto OR @EstatusConcepto = '' OR @EstatusConcepto = '' )
		--------EMS.EstatusSolicitudId = isnull(IIF(LEN(@EstatusConcepto) = 0,NULL,@EstatusConcepto),EMS.EstatusSolicitudId)
		------AND 
		C.ParametroConceptoId = 3 -- Montos
	GROUP BY 
		 S.FolioSolicitud, EMS.ConceptoId, C.Descripcion, C.ParametroConceptoId, r.city, b.Location_Name, PN.NombrePeriodo--, S.Fecha_Solicitud
		,d.Descripcion, S.Solicitante_Ident, EMS.EstatusSolicitudId
	ORDER BY 
		S.FolioSolicitud
		,C.Descripcion
END