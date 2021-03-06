USE [ASN5]
GO
/****** Object:  StoredProcedure [app620].[CierraSolicitud]    Script Date: 26/09/2019 05:17:43 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CierraSolicitud]
	 @FolioSolicitud	INT
	,@Responsable_Ident	INT
	,@Estatus			INT = 1 OUTPUT
AS
	SET XACT_ABORT ON;
	SET NOCOUNT ON;
BEGIN TRY
	DECLARE
		 @CantidadTotal				INT = 0
		,@CantidadTotalAC			INT = 0

	BEGIN TRAN

		SELECT	@CantidadTotalAC		=	COUNT(1) 
		FROM	CatEmpleadosSolicitudes
		WHERE	FolioSolicitud			= @FolioSolicitud
		AND		EstatusSolicitudId		IN ('A', 'C', 'CE')	--Estatus de Autorizada, Cancelada y Cerrada.
		AND		Active				= 1

		SELECT	@CantidadTotal			=	COUNT(1) 
		FROM	CatEmpleadosSolicitudes
		WHERE	FolioSolicitud			= @FolioSolicitud
		AND		Active				= 1

		--Aun no se ha procesado ninguna solicitud
		IF (@CantidadTotal = @CantidadTotalAC)
			BEGIN
				UPDATE	CatEmpleadosSolicitudes
				SET		EstatusSolicitudId	= 'CE'
				WHERE	FolioSolicitud		= @FolioSolicitud
				AND		EstatusSolicitudId	<> 'C'

				UPDATE	CatSolicitudes
				SET		EstatusSolicitudId	= 'CE'
						,Responsable_Ident	= @Responsable_Ident 
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
