USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[ReporteAuditoriasDetalleAutorizadoresSel]    Script Date: 11/09/2019 02:25:45 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[ReporteAuditoriasDetalleAutorizadoresSel]
	@FolioId INT = 0
	--@EID INT = 0,
	--@ConceptoId INT = 0
AS
BEGIN
	--DECLARE @FolioId INT = 89--90--89
	--DECLARE @EID INT = 1796962--3160115--1796962
	--DECLARE @ConceptoId INT = 44--2--44

	SELECT  DISTINCT
		[Autorizador_Ident]
		,[FolioSolicitud]
		,[Empleado_Ident]
		,a.[ConceptoId]
		,x.Descripcion As ConceptoDesc
		,NivelAutorizacion
		,i.Nombre
	FROM [app620].[CatSolicitudEmpleadosAutorizantes] a
	INNER JOIN [app620].[CatEmployeeCCMSVw] i ON a.Autorizador_Ident = i.Ident
	INNER JOIN [app620].[CatConceptos] x ON a.ConceptoId = x.ConceptoId
	where FolioSolicitud = @FolioId
	--AND ConceptoId= @ConceptoId
	--AND Empleado_Ident = @EID
	--AND Autorizador_Ident IS NOT NULL
	order by ConceptoId,NivelAutorizacion
END