USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSi]    Script Date: 12/06/2019 02:53:37 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatSolicitudesSi]
	 @FolioSolicitud INT
	,@Solicitante_Ident INT = NULL
	--,@UserEmployeeId INT
	,@FolioSolicitudOut INT OUTPUT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	
	DECLARE @idSolicitud INT =0
	DECLARE @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	SET @FolioSolicitudOut = -1;
	SET @Estatus = ISNULL(@Estatus, 0);

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro con los mismos parametros.
	*/

	IF EXISTS	(
					SELECT 1
					FROM app620.CatSolicitudes
					WHERE					
						FolioSolicitud	= @FolioSolicitud
				)
		BEGIN
			SET @Estatus = '-1'
			SET @FolioSolicitudOut	= @FolioSolicitud
		END
	ELSE
		BEGIN
			DECLARE @inserted TABLE (
				[FolioSolicitud] [int]
			)

			INSERT INTO [app620].[CatSolicitudes]
			(
				-- FolioSolicitud
				--,
				 Fecha_Solicitud
				,Solicitante_Ident
				,EstatusSolicitudId
				,CreatedBy
				,LastModifiedBy
			)
			OUTPUT Inserted.FolioSolicitud INTO @inserted
			VALUES
			(
				-- 0
				--,
				 @FechaActual
				,@Solicitante_Ident
				,'EB'
				,@Solicitante_Ident
				,@Solicitante_Ident
			)
				
			SELECT TOP 1 @FolioSolicitudOut = FolioSolicitud FROM @inserted;
		END

	--SET @Estatus= CONCAT (@Estatus,'_',@idSolicitud)
END
