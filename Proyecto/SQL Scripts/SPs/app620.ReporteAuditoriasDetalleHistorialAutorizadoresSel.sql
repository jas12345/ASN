/****** Object:  StoredProcedure [app620].[ReporteAuditoriasDetalleHistorialAutorizadoresSel]    Script Date: 02/09/2019 07:42:32 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [app620].[ReporteAuditoriasDetalleHistorialAutorizadoresSel]
	@FolioId INT = 0,
	@EID INT = 0, --Autorizador Ident
	@ConceptoId INT = 0
AS
BEGIN
	--DECLARE @FolioId INT = 89
	--DECLARE @EID INT = 666229--3160115--1796962
	--DECLARE @ConceptoId INT = 44

	SELECT  
		[Autorizador_Ident]
		,[FolioSolicitud]
		,[Empleado_Ident]
		,a.[ConceptoId]
		,x.Descripcion As ConceptoDesc
		--,NivelAutorizacion
		--,LastModifiedDate
		,convert(nvarchar(19),a.LastModifiedDate,120) As FechaModificacion
		,i.Nombre
		,CASE 
			WHEN Pendiente = 1 THEN 'Pendiente'
			WHEN Autorizado = 1 THEN 'Autorizado'
			WHEN Rechazado = 1 THEN 'Rechazado'
			WHEN Cancelado = 1 THEN 'Cancelado'
			ELSE 'En borrador'
		END AS Accion
	FROM [app620].[CatSolicitudEmpleadosAutorizantesLog] a
	INNER JOIN [app620].[CatEmployeeCCMSVw] i ON a.Autorizador_Ident = i.Ident
	INNER JOIN [app620].[CatConceptos] x ON a.ConceptoId = x.ConceptoId
	where FolioSolicitud = @FolioId
	AND a.ConceptoId= @ConceptoId
	AND a.Autorizador_Ident = @EID
	AND Autorizador_Ident IS NOT NULL
	order by a.LastModifiedDate DESC
END