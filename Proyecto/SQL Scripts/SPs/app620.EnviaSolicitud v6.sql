USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[EnviaSolicitud]    Script Date: 31/07/2019 09:28:39 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[EnviaSolicitud]
	 @FolioSolicitud INT
	,@Estatus INT = 1 OUTPUT
AS
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
BEGIN TRY
	BEGIN TRAN
		DECLARE @EstatusSolicitudId VARCHAR(5) = ''

		SELECT @EstatusSolicitudId = EstatusSolicitudId
		FROM CatSolicitudes
		WHERE FolioSolicitud = @FolioSolicitud

		IF (@EstatusSolicitudId = 'EB')
			BEGIN
				UPDATE CatSolicitudes
				SET EstatusSolicitudId = 'PA'
				WHERE FolioSolicitud = @FolioSolicitud

				UPDATE CatEmpleadosSolicitudes
				SET EstatusSolicitudId = 'PA'
				WHERE FolioSolicitud = @FolioSolicitud
			END

		UPDATE app620.CatSolicitudEmpleadosAutorizantes 
		SET Pendiente = 1, Rechazado = 0
		FROM (
			SELECT 
				 MIN(NivelAutorizacion) AS NivelAutorizacion
				,FolioSolicitud, Empleado_Ident, ConceptoId--, Pendiente, Autorizado, Rechazado
			FROM app620.CatSolicitudEmpleadosAutorizantes
			WHERE FolioSolicitud = @FolioSolicitud
			AND Autorizador_Ident IS NOT NULL
			AND ((Pendiente = 1) OR (Autorizado = 0 AND Rechazado = 0 AND Pendiente = 0 AND Cancelado = 0) OR (Rechazado = 1))
			GROUP BY FolioSolicitud, Empleado_Ident, ConceptoId--, Pendiente, Autorizado, Rechazado
		) SEA
		WHERE
			SEA.FolioSolicitud		= CatSolicitudEmpleadosAutorizantes.FolioSolicitud
		AND
			SEA.Empleado_Ident		= CatSolicitudEmpleadosAutorizantes.Empleado_Ident
		AND
			SEA.ConceptoId			= CatSolicitudEmpleadosAutorizantes.ConceptoId
		AND
			SEA.NivelAutorizacion	= CatSolicitudEmpleadosAutorizantes.NivelAutorizacion		

		SELECT @Estatus = 1

	COMMIT TRAN
END TRY
BEGIN CATCH  -- Modulo de manejo de errores
	
    DECLARE @Error_Number INT ,
        @Error_Severity INT ,
        @Error_State INT ,
        @Error_Procedure VARCHAR(1000) ,
        @Error_Line INT ,
        @Error_Message VARCHAR(8000);
    SELECT  @Error_Number = ERROR_NUMBER() ,
            @Error_Severity = ERROR_SEVERITY() ,
            @Error_State = ERROR_STATE() ,
            @Error_Procedure = ERROR_PROCEDURE() ,
            @Error_Line = ERROR_LINE() ,
            @Error_Message = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	
	SELECT @Estatus = -1	

	RAISERROR(@Error_Message,@Error_Severity, @Error_State);	
END CATCH;
