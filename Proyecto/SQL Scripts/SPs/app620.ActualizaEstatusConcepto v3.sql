USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[ActualizaEstatusConcepto]    Script Date: 26/09/2019 08:38:01 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [app620].[ActualizaEstatusConcepto]
	@FolioSolicitud INT
	,@Empleado_Ident INT
	,@ConceptoId INT
	,@EstatusSolicitudId VARCHAR(5)
	,@CCMS_User INT	
AS
	BEGIN
		UPDATE	[app620].[CatEmpleadosSolicitudes]
		SET		EstatusSolicitudId = @EstatusSolicitudId
				,LastModifiedBy = @CCMS_User
				,LastModifiedDate = GETDATE()
				,LastModifiedFromPCName = HOST_NAME()
		WHERE	FolioSolicitud = @FolioSolicitud
				AND Empleado_Ident = @Empleado_Ident
				AND ConceptoId = @ConceptoId

		
		UPDATE	app620.CatSolicitudEmpleadosAutorizantes
		SET		Pendiente = 0, Rechazado = 0, Cancelado = 1
		WHERE	FolioSolicitud = @FolioSolicitud 
		AND		Empleado_Ident = @Empleado_Ident 
		AND		ConceptoId = @ConceptoId
		--AND		Pendiente = 1
		AND		(Pendiente = 1 OR Rechazado = 1)

		-- CALCULA EL ESTATUS DE LA SOLICITUD Y HACE UPDATE DE SER NECESARIO
		DECLARE
			@Autorizada INT
			,@Cancelada INT
			,@PendienteAutorizacion INT
			,@Rechazada INT

		SELECT	@Rechazada = COUNT(FolioSolicitud)
		FROM	app620.CatEmpleadosSolicitudes WITH(NOLOCK)
		where	FolioSolicitud = @FolioSolicitud
				AND EstatusSolicitudId = 'R'

		SELECT	@PendienteAutorizacion = COUNT(FolioSolicitud)
		FROM	app620.CatEmpleadosSolicitudes WITH(NOLOCK)
		where	FolioSolicitud = @FolioSolicitud
				AND EstatusSolicitudId = 'PA'

		SELECT	@Autorizada = COUNT(FolioSolicitud)
		FROM	app620.CatEmpleadosSolicitudes WITH(NOLOCK)
		where	FolioSolicitud = @FolioSolicitud
				AND EstatusSolicitudId = 'A'

		SELECT	@Cancelada = COUNT(FolioSolicitud)
		FROM	app620.CatEmpleadosSolicitudes WITH(NOLOCK)
		where	FolioSolicitud = @FolioSolicitud
				AND EstatusSolicitudId = 'C'

		DECLARE 
			@NuevoEstatus VARCHAR(5)

		SET @NuevoEstatus = CASE
								WHEN @Rechazada > 0 
								THEN 'R'
								WHEN @PendienteAutorizacion > 0
								THEN 'PA'
								WHEN @Autorizada > 0
								THEN 'A'
								WHEN @Cancelada > 0
								THEN 'C'
							END

		IF (@NuevoEstatus IS NOT NULL AND @NuevoEstatus != '')
			BEGIN
				UPDATE	app620.CatSolicitudes
				SET		EstatusSolicitudId = @NuevoEstatus
						,LastModifiedBy = @CCMS_User
						,LastModifiedDate = GETDATE()
						,LastModifiedFromPCName = HOST_NAME()
				WHERE	FolioSolicitud = @FolioSolicitud

				--IF 

			END

	END