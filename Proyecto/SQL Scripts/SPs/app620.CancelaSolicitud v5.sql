USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CancelaSolicitud]    Script Date: 07/08/2019 10:10:06 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CancelaSolicitud]
	 @FolioSolicitud INT
	,@Estatus INT = 1 OUTPUT
AS
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
BEGIN TRY
	DECLARE
		 @TotalconceptosAutorizados	INT = 0

	BEGIN TRAN

		SELECT	@TotalconceptosAutorizados		=	COUNT(1) 
		FROM	app620.CatEmpleadosSolicitudes
		WHERE	FolioSolicitud		= @FolioSolicitud
		AND		EstatusSolicitudId	= 'A'

		--Aun no se ha procesado ninguna solicitud
		IF (@TotalconceptosAutorizados = 0)
			BEGIN
				UPDATE	CatSolicitudes
				SET		EstatusSolicitudId	= 'C'
				WHERE	FolioSolicitud		= @FolioSolicitud

				UPDATE	CatEmpleadosSolicitudes
				SET		EstatusSolicitudId	= 'C'
				WHERE	FolioSolicitud		= @FolioSolicitud

			END
		ELSE
			BEGIN
				SET @Estatus = -1
			END

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
