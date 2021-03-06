USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudEmpleadosAutorizantesSI]    Script Date: 22/07/2019 07:32:24 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatSolicitudEmpleadosAutorizantesSu]
	 @FolioSolicitud INT = 0
	,@Empleado_Ident INT = 0
	,@Autorizador_Ident INT = 0
	,@NivelAutorizacion INT =0
	,@Accion INT = 0
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN

	IF NOT EXISTS(
		SELECT 1 
		FROM ASN.app620.CatSolicitudEmpleadosAutorizantes 
		WHERE FolioSolicitud	= @FolioSolicitud 
		AND Empleado_Ident		= @Empleado_Ident 
		AND Autorizador_Ident	= @Autorizador_Ident
		AND NivelAutorizacion	= @NivelAutorizacion
	)
	SET @Estatus =-1

	IF(@Estatus =0)
		BEGIN
			UPDATE app620.CatSolicitudEmpleadosAutorizantes
			SET 
				 Autorizado	= (CASE WHEN @Accion = 2 THEN 1 ELSE 0 END)--Autorizado
				,Rechazado	= (CASE WHEN @Accion = 3 THEN 1 ELSE 0 END)--Rechazado
				,Cancelado	= (CASE WHEN @Accion = 4 THEN 1 ELSE 0 END)--Cancelado
			WHERE
				FolioSolicitud		= @FolioSolicitud
			AND
				Empleado_Ident		= @Empleado_Ident
			AND
				Autorizador_Ident	= @Autorizador_Ident
			AND
				NivelAutorizacion	= @NivelAutorizacion
		END

END
