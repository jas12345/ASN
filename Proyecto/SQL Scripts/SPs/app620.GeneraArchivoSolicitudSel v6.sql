USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[GeneraArchivoSolicitudSel]    Script Date: 03/07/2020 08:54:39 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[GeneraArchivoSolicitudSel]
@Activos bit = 0
AS
BEGIN
	DECLARE @TablaDeSolicitudes TABLE (EMPLEADO int, CONCEPTO nvarchar(50), UNIDAD nvarchar(10), IMPORTE nvarchar(10), PORCENTAJE nvarchar(10))
	DECLARE @T_EX_DOB_SEM nvarchar(20) = 'T EX DOB SEM'

	INSERT INTO @TablaDeSolicitudes
	EXEC [app620].[ArchivoSolicitud] 1

	--SELECT * FROM @TablaDeSolicitudes order by EMPLEADO desc

	IF 1 = 2 BEGIN
		SELECT
			cast(null as int)				as EMPLEADO
			,cast(null as nvarchar(MAX))    as REG
			,cast(null as nvarchar(MAX))    as CONCEPTO
			,cast(null as nvarchar(MAX))    as ACCION
			,cast(null as nvarchar(MAX))	as UNIDAD
			,cast(null as int)			    as IMPORTE
			,cast(null as nvarchar(MAX))    as PORCENTAJE
			,cast(null as nvarchar(MAX))    as FECHA
			,cast(null as nvarchar(MAX))	as SEMANA
			,cast(null as nvarchar(MAX))    as FECHA_INI
			,cast(null as nvarchar(MAX))	as FECHA_FIN
			,cast(null as nvarchar(MAX))    as DURACION
			,cast(null as nvarchar(MAX))	as FOLIO
			,cast(null as nvarchar(MAX))    as CONSECUENCIA
			,cast(null as nvarchar(MAX))    as CONTROL
			,cast(null as nvarchar(MAX))	as ID_Empresa
			,cast(null as nvarchar(MAX))	as CIA_IDReporteo
			,cast(null as nvarchar(MAX))	as Folder
			,cast(null as nvarchar(MAX)) 	as Compania
			,cast(null as nvarchar(MAX)) 	as ID_REP
			,cast(null as int) 				as T_EX_DOB_SEM
			,cast(null as nvarchar(MAX)) 	as T_EXTRA_EXEN
		WHERE
			1 = 2  
	END

	SELECT
	EMPLEADO,
	REG,
	Concepto,
	ACCION,
	UNIDAD,
	CASE WHEN IMPORTE = 0 THEN '' ELSE CONVERT(nvarchar(10),IMPORTE) END IMPORTE,
	PORCENTAJE,
	FECHA,
	SEMANA,
	FECHA_INI,
	FECHA_FIN,
	DURACION,
	FOLIO,
	CONSECUENCIA,
	CONTROL,
	ID_Empresa,
	CIA_IDReporteo,
	Folder,
	Compania,
	ID_REP,
	T_EX_DOB_SEM,
	T_EXTRA_EXEN
	FROM
	(SELECT
	r.EMPLEADO,
	r.REG,
	r.Concepto,
	r.ACCION,
	r.UNIDAD,
	--SUM(r.IMPORTE) IMPORTE,
	r.Importe,
	r.PORCENTAJE,
	r.FECHA,
	r.SEMANA,
	r.FECHA_INI,
	r.FECHA_FIN,
	r.DURACION,
	r.FOLIO,
	r.CONSECUENCIA,
	r.CONTROL,
	r.ID_Empresa,
	r.CIA_IDReporteo,
	r.Folder,
	r.Compania,
	r.ID_REP,
	r.T_EX_DOB_SEM,
	r.T_EXTRA_EXEN
	FROM
	(
	SELECT 
	EMPLEADO,
	'0' REG,
	CONCEPTO,
	'' ACCION,
	UNIDAD,
	--IMPORTE,
	--LEN(IMPORTE),
	CASE WHEN Isnumeric(IMPORTE) != 1  THEN 0 ELSE 
		--convert(decimal(18,2), IMPORTE) 
		CAST(IMPORTE AS DECIMAL(12,2))
	END IMPORTE,
	PORCENTAJE,
	'' FECHA,
	''	SEMANA,
	''	FECHA_INI,
	''	FECHA_FIN,
	''	DURACION,
	''	FOLIO,
	''	CONSECUENCIA,
	''	CONTROL,
	c.ID_Empresa,
	c.CIA_IDReporteo,
	c.Folder,
	d.Compania,
	d.ID_REP,
	CASE WHEN Concepto = @T_EX_DOB_SEM THEN 1 ELSE 0 END AS T_EX_DOB_SEM,
	CASE WHEN Concepto = @T_EX_DOB_SEM THEN 'T EXTRA EXEN' ELSE '' END AS T_EXTRA_EXEN
	FROM @TablaDeSolicitudes a
	--INNER JOIN [app620].[CatEmployeeCCMSVw] b on a.EMPLEADO = b.Ident
	INNER JOIN [app620].[CatEmployeeCCMSAllVw] b on a.EMPLEADO = b.Ident
	INNER JOIN [app620].[CatIdEmpresaXCCMSContractVw] c WITH (NOLOCK) on b.Contract_Type_Ident = c.Contract_Type_Ident AND c.SiteId IS NULL
	INNER JOIN [app620].[CatCompaniaXIdEmpresaVw] d WITH (NOLOCK) on c.CIA_IDReporteo = d.CIA_IDReporteo AND c.ID_Empresa = d.ID_Empresa
	WHERE 
	b.Location_Ident not in (SELECT x.SiteId FROM [app620].[CatIdEmpresaXCCMSContractVw] x WHERE x.SiteId IS NOT NULL)

	UNION ALL

	SELECT 
	EMPLEADO,
	'0' REG,
	CONCEPTO,
	'' ACCION,
	UNIDAD,
	--IMPORTE,
	--LEN(IMPORTE),
	CASE WHEN Isnumeric(IMPORTE) != 1 THEN 0 ELSE 
		--convert(decimal(18,2), IMPORTE) 
		CAST(IMPORTE AS DECIMAL(12,2))
	END IMPORTE,
	PORCENTAJE,
	'' FECHA,
	''	SEMANA,
	''	FECHA_INI,
	''	FECHA_FIN,
	''	DURACION,
	''	FOLIO,
	''	CONSECUENCIA,
	''	CONTROL,
	c.ID_Empresa,
	c.CIA_IDReporteo,
	c.Folder,
	d.Compania,
	d.ID_REP,
	CASE WHEN Concepto = @T_EX_DOB_SEM THEN 1 ELSE 0 END AS T_EX_DOB_SEM,
	CASE WHEN Concepto = @T_EX_DOB_SEM THEN 'T EXTRA EXEN' ELSE '' END AS T_EXTRA_EXEN
	FROM @TablaDeSolicitudes a
	--INNER JOIN [app620].[CatEmployeeCCMSVw] b on a.EMPLEADO = b.Ident
	INNER JOIN [app620].[CatEmployeeCCMSAllVw] b on a.EMPLEADO = b.Ident
	INNER JOIN [app620].[CatIdEmpresaXCCMSContractVw] c WITH (NOLOCK) on b.Contract_Type_Ident = c.Contract_Type_Ident AND c.SiteId = b.Location_Ident
	INNER JOIN [app620].[CatCompaniaXIdEmpresaVw] d WITH (NOLOCK) on c.CIA_IDReporteo = d.CIA_IDReporteo AND c.ID_Empresa = d.ID_Empresa
	WHERE 
	b.Location_Ident in (SELECT x.SiteId FROM [app620].[CatIdEmpresaXCCMSContractVw] x WHERE x.SiteId IS NOT NULL)
	) r
	--------group by r.EMPLEADO,
	--------r.Concepto,
	--------r.Reg,	
	--------r.Accion,
	--------r.Unidad,
	----------Importe,
	--------r.importe,
	--------r.Porcentaje,
	--------r.Fecha,
	--------r.Semana,
	--------r.Fecha_Ini,
	--------r.Fecha_Fin,
	--------r.Duracion,
	--------r.Folio,
	--------r.Consecuencia,
	--------r.Control,
	--------r.ID_Empresa,
	--------r.CIA_IDReporteo,
	--------r.Folder,
	--------r.Compania,
	--------r.ID_REP,
	--------r.T_EX_DOB_SEM,
	--------r.T_EXTRA_EXEN
	) rr
	order by rr.EMPLEADO desc
END