USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizaSolicitudEmpleado]    Script Date: 18/07/2019 05:07:53 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[AutorizacionesSolicitudEmpleado]
(
	 @FolioSolicitud INT = 0
	,@Empleado_Ident INT = 0
	,@ConceptoId INT = 0
	,@NivelAutorizacion INT = 0
	,@Autorizado BIT = 0
	,@Rechazado BIT = 0
	,@Cancelado BIT = 0
)
AS

BEGIN

	UPDATE CatSolicitudEmpleadosAutorizantes
	SET
		 [Autorizado] = @Autorizado
		,[Rechazado] = @Rechazado
		,[Cancelado] = @Cancelado
	WHERE
		 [FolioSolicitud] = @FolioSolicitud
	AND	[Empleado_Ident] = @Empleado_Ident
	AND	[ConceptoId] = @ConceptoId
	AND	[NivelAutorizacion] = @NivelAutorizacion

	--TODO: Consulta que permite calcular que se han autorizado/cancelado todos EmpleadosAutorizantes
	--      para enviar Solicitud a Autorizada / Cancelada

END
