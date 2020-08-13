USE [ASN]
GO

/****** Object:  StoredProcedure [app620].[ReporteSolcitudSel]    Script Date: 13/08/2020 11:54:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [app620].[ReporteSolcitudSel] --42, null
--@FechaIni varchar(15) --= '2019-09-28'
--,@FechaFin varchar(15) --= '2019-10-29'
--,@City int --= 'Monterrey'
--,@Site int --= 317
--,@Solicitante int --= 1286941
--,@Estatus varchar(10) --= 'CE'
@PeriodoNomina int = NULL,
@TipoContrato int = NULL
AS
BEGIN
	--DECLARE
	--@FechaIni varchar(15) --= '2019-09-28'
	--,@FechaFin varchar(15) --= '2019-10-29'
	--,@City varchar(20) --= 'Monterrey'
	--,@Site int --= 317
	--,@Solicitante int --= 1286941
	--,@Estatus varchar(5) = 'CE'
	SET @TipoContrato = ISNULL(@TipoContrato,'-1');
	SELECT
	c.city AS Ciudad, 
	b.Location_Name AS Site, 
	a.Solicitante_Ident AS SolicitanteCCMSID, 
	convert(nvarchar(19),a.Fecha_Solicitud,120) As Fecha, 
	a.FolioSolicitud AS Folio, 
	d.Descripcion AS Estatus	
	FROM app620.CatSolicitudes a
	INNER JOIN [app620].[CatEmployeeCCMSVw] b on a.Solicitante_Ident = b.Ident
	INNER JOIN [app620].[CatRelLocationBiosCCMSVw] c on b.Location_Ident = c.location_ccms
	INNER JOIN [app620].[CatEstatusSolicitudes] d on a.EstatusSolicitudId = d.EstatusSolicitudId
	INNER JOIN [app620].[CatPeriodosNomina] e on a.PeriodoNominaId = e.PeriodoNominaId
	INNER JOIN [app620].[CatContractTypeVw] f on b.Contract_Type_Ident = f.Contract_Type_Ident
	WHERE 
	--a.Solicitante_Ident = isnull(@Solicitante,a.Solicitante_Ident)
	--AND
	--c.location_bios = isnull(@City,c.location_bios)
	--AND
	--b.Location_Ident = isnull(@Site,b.Location_Ident)
	--AND
	--d.EstatusSolicitudId = isnull(@Estatus,d.EstatusSolicitudId)
	--AND
	--a.Fecha_Solicitud between isnull(@FechaIni,a.Fecha_Solicitud) and isnull(@FechaFin,a.Fecha_Solicitud)
	a.PeriodoNominaId = @PeriodoNomina 
	and (b.Contract_Type_Ident = @TipoContrato or @TipoContrato = '-1')
	--ORDER BY a.CreatedDate DESC
END


GO

