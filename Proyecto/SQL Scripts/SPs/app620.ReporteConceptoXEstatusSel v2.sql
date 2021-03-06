USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[ReporteConceptoXEstatusSel]    Script Date: 10/5/2020 12:53:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[ReporteConceptoXEstatusSel]
--@FechaIni varchar(15) --= '2019-09-28'
--,@FechaFin varchar(15) --= '2019-10-29'
--,@City int --= 'Monterrey'
--,@Site int --= 317
--,@Solicitante int --= 1286941
--DECLARE
@PeriodoNomina int NULL
,@EstatusSolicitud varchar(5) --= 'A'
,@EstatusConcepto varchar(5) --= 'A'
AS
BEGIN
	--DECLARE
	--@FechaIni varchar(15) --= '2019-09-28'
	--,@FechaFin varchar(15) --= '2019-10-29'
	--,@City varchar(20) --= 'Monterrey'
	--,@Site int --= 317
	--,@Solicitante int --= 1286941
	--,@EstatusSolicitud varchar(5) --= 'A'
	--,@EstatusConcepto varchar(5) --= 'A'

	SELECT
	Ciudad,
	Site,
	Concepto,
	'$'+FORMAT(SUM(Total),'##########,0.00') AS Total,
	EstatusSol,
	EstatusCon,
	Contrato
	FROM
	(SELECT
		r.city As Ciudad,
		b.Location_Name As Site,
		C.Descripcion Concepto,
		CASE
			WHEN C.ParametroConceptoId IN (3)
			THEN sum(EMS.ParametroConceptoMonto)
			ELSE 0
		END Total
		--,convert(nvarchar(19),S.Fecha_Solicitud,120) As Fecha
		,d.Descripcion AS EstatusSol
		,CASE WHEN EMS.EstatusSolicitudId IS NOT NULL THEN
				(SELECT Descripcion FROM  [app620].[CatEstatusSolicitudes] WHERE EstatusSolicitudId = EMS.EstatusSolicitudId)
			ELSE 
				''
			END
		 AS EstatusCon,
		 ccv.CIA_IDReporteo AS Contrato
	FROM [app620].[CatSolicitudes] S
		JOIN [app620].[CatEmpleadosSolicitudes] EMS ON S.FolioSolicitud = EMS.FolioSolicitud
		INNER JOIN [app620].[CatConceptos] C ON C.ConceptoId = EMS.ConceptoId
		INNER JOIN [app620].[CatConceptosPeopleSoft] PS ON PS.ConceptoId = C.PeopleSoftId
		INNER JOIN [app620].[CatPeriodosNomina] PN ON PN.PeriodoNominaId = S.PeriodoNominaId
		INNER JOIN [app620].[CatEmployeeCCMSVw] b on S.Solicitante_Ident = b.Ident
		INNER JOIN [app620].[CatRelLocationBiosCCMSVw] r on b.Location_Ident = r.location_ccms
		INNER JOIN [app620].[CatEstatusSolicitudes] d on S.EstatusSolicitudId = d.EstatusSolicitudId
		INNER JOIN [app620].[CatPeriodosNomina] e on S.PeriodoNominaId = e.PeriodoNominaId 
		INNER JOIN [app620].[CatEmployeeCCMSVw] emp with (nolock) ON  EMS.Empleado_Ident =  emp.Ident
		INNER JOIN [app620].[CatIdEmpresaXCCMSContractVw] ccv WITH (NOLOCK) ON ccv.Contract_Type_Ident=emp.Contract_Type_Ident
	WHERE	
		--S.Solicitante_Ident = isnull(@Solicitante,S.Solicitante_Ident)
		--AND
		--r.location_bios = isnull(@City,r.location_bios)
		--AND
		--b.Location_Ident = isnull(@Site,b.Location_Ident)
		--AND
		--S.Fecha_Solicitud between isnull(@FechaIni,S.Fecha_Solicitud) and isnull(@FechaFin,S.Fecha_Solicitud)
		S.PeriodoNominaId = @PeriodoNomina
		AND
		S.EstatusSolicitudId = isnull(IIF(LEN(@EstatusSolicitud) = 0,NULL,@EstatusSolicitud),S.EstatusSolicitudId)
		AND 
		EMS.EstatusSolicitudId = isnull(IIF(LEN(@EstatusConcepto) = 0,NULL,@EstatusConcepto),EMS.EstatusSolicitudId)
		--AND 
		--C.ParametroConceptoId = 3 -- Montos
	GROUP BY r.city, b.Location_Name, C.Descripcion, C.ParametroConceptoId, S.Fecha_Solicitud, d.Descripcion, EMS.EstatusSolicitudId,ccv.CIA_IDReporteo
	) X
	GROUP BY Concepto, Ciudad, Site, EstatusSol, EstatusCon,Contrato
	order by Concepto
END