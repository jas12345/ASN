USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[ProcesaSolicitudEmpleados]    Script Date: 17/07/2019 05:15:21 p. m. ******/
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

		UPDATE CatSolicitudes
		SET EstatusSolicitudId = 'E'
		WHERE FolioSolicitud = @FolioSolicitud

		UPDATE CatEmpleadosSolicitudes
		SET EstatusSolicitudId = 'PA'
		WHERE FolioSolicitud = @FolioSolicitud

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
