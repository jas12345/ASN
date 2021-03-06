/****** Object:  StoredProcedure [app620].[ReporteAuditoriasDetalleHistorialSel]    Script Date: 02/09/2019 07:41:46 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [app620].[ReporteAuditoriasDetalleHistorialSel]
	@FolioId INT = 0,
	@EID INT = 0,
	@ConceptoId INT = 0
AS
BEGIN
	--DECLARE @FolioId INT = 88
	--DECLARE @EID INT = 3160115
	--DECLARE @ConceptoId INT = 6

	--SELECT
	--CASE WHEN y.ParametroConceptoId = 3 THEN CONVERT(VARCHAR(22), a.ParametroConceptoMonto) + ' ' + TM.TipoDeMoneda
	--		   ELSE CONVERT(VARCHAR(22), a.ParametroConceptoMonto) + ' ' + y.Descripcion 
	--	  END AS Monto,
	--a.EstatusSolicitudId,
	--a.MotivosSolicitudId,
	--f.Descripcion As MotivoSolicitudDesc,
	--b.ConceptoMotivoId,
	--d.Descripcion As ConceptoMotivoDesc,
	--b.ResponsableId,
	----c.Nombre As NombreResponsable, 
	----convert(date,a.LastModifiedDate) As FechaModificacion,
	----convert(nvarchar(19),h.LastModifiedDate,120) As FechaModificacion,
	--convert(nvarchar(19),a.LastModifiedDate,120) As FechaModificacion,
	--h.Autorizador_Ident,
	--i.Nombre As NombreAutorizador
	--,h.Accion
	--,h.NivelAutorizacion
	--FROM [app620].[CatEmpleadosSolicitudesLog] a
	--INNER JOIN [app620].[CatSolicitudEmpleadosDetalleLog] b ON a.FolioSolicitud = b.FolioSolicitud AND a.Empleado_Ident = b.Empleado_Ident AND a.ConceptoId = b.ConceptoId AND a.LastModifiedDate = b.LastModifiedDate
	--LEFT JOIN [app620].[CatEmployeeCCMSVw] c ON b.ResponsableId = c.Ident
	--INNER JOIN [app620].[CatConceptosMotivos] d ON b.ConceptoMotivoId = d.ConceptoMotivoId
	--INNER JOIN [app620].[CatMotivosSolicitud] f ON a.MotivosSolicitudId = f.MotivosSolicitudId
	--INNER JOIN [app620].[CatConceptos] x ON a.ConceptoId = x.ConceptoId
	--INNER JOIN [app620].[CatParametroConceptos] y ON x.ParametroConceptoId = y.ParametroConceptoId
	--LEFT JOIN [app620].[CatEmployeeCCMSVw] g ON a.Empleado_Ident = g.Ident
	--INNER JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = g.country_ident
	--INNER JOIN (
	--	SELECT  DISTINCT 
	--		[Autorizador_Ident]
	--		,[FolioSolicitud]
	--		,[Empleado_Ident]
	--		,[ConceptoId]
	--		,NivelAutorizacion
	--		--,LastModifiedDate
	--		,CASE 
	--			WHEN Pendiente = 1 THEN 'Pendiente'
	--			WHEN Autorizado = 1 THEN 'Autorizado'
	--			WHEN Rechazado = 1 THEN 'Rechazado'
	--			WHEN Cancelado = 1 THEN 'Cancelado'
	--			ELSE 'Ninguna'
	--		END AS Accion
	--	FROM [ASN2].[app620].[CatSolicitudEmpleadosAutorizantesLog]
	--	where FolioSolicitud = @FolioId
	--	AND ConceptoId= @ConceptoId
	--	AND Empleado_Ident = @EID
	--	AND Autorizador_Ident IS NOT NULL
	--) h ON @FolioId = h.FolioSolicitud AND @EID = h.Empleado_Ident AND @ConceptoId = h.ConceptoId
	--INNER JOIN [app620].[CatEmployeeCCMSVw] i ON h.Autorizador_Ident = i.Ident
	--WHERE a.FolioSolicitud = @FolioId
	--AND a.Empleado_Ident = @EID
	--AND a.ConceptoId = @ConceptoId
	--ORDER BY FechaModificacion DESC
	----ORDER BY h.LastModifiedDate DESC


	SELECT
	CASE WHEN y.ParametroConceptoId = 3 THEN CONVERT(VARCHAR(22), a.ParametroConceptoMonto) + ' ' + TM.TipoDeMoneda
			   ELSE CONVERT(VARCHAR(22), a.ParametroConceptoMonto) + ' ' + y.Descripcion 
		  END AS Monto,
	a.EstatusSolicitudId,
	a.MotivosSolicitudId,
	f.Descripcion As MotivoSolicitudDesc,
	b.ConceptoMotivoId,
	d.Descripcion As ConceptoMotivoDesc,
	--b.ResponsableId,
	--c.Nombre As NombreResponsable, 
	--convert(date,a.LastModifiedDate) As FechaModificacion
	convert(nvarchar(19),a.LastModifiedDate,120) As FechaModificacion
	FROM [app620].[CatEmpleadosSolicitudesLog] a
	INNER JOIN [app620].[CatSolicitudEmpleadosDetalleLog] b ON a.FolioSolicitud = b.FolioSolicitud AND a.Empleado_Ident = b.Empleado_Ident AND a.ConceptoId = b.ConceptoId AND a.LastModifiedDate = b.LastModifiedDate
	LEFT JOIN [app620].[CatEmployeeCCMSVw] c ON b.ResponsableId = c.Ident
	INNER JOIN [app620].[CatConceptosMotivos] d ON b.ConceptoMotivoId = d.ConceptoMotivoId
	INNER JOIN [app620].[CatMotivosSolicitud] f ON a.MotivosSolicitudId = f.MotivosSolicitudId
	INNER JOIN [app620].[CatConceptos] x ON a.ConceptoId = x.ConceptoId
	INNER JOIN [app620].[CatParametroConceptos] y ON x.ParametroConceptoId = y.ParametroConceptoId
	LEFT JOIN [app620].[CatEmployeeCCMSVw] g ON a.Empleado_Ident = g.Ident
	INNER JOIN [app620].[CatTipoDeMoneda] TM ON TM.Pais = g.country_ident
	WHERE a.FolioSolicitud = @FolioId
	AND a.Empleado_Ident = @EID
	AND a.ConceptoId = @ConceptoId
	ORDER BY FechaModificacion DESC
END