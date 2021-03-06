USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudEmpleadosAutorizantesSu]    Script Date: 23/07/2019 02:41:21 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatSolicitudEmpleadosAutorizantesSu]
	 @FolioSolicitud INT = 0
	,@Empleado_Ident INT = 0
	,@Concepto_Id INT = 0
	,@NivelAutorizacion INT =0
	,@Autorizador_Ident INT = 0
	,@Accion INT = 0
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN

	DECLARE
		 @CantidadTotal		INT = 0
		,@CantidadTotalAC	INT = 0

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
				 Pendiente	= (CASE WHEN @Accion = 1 THEN 1 ELSE 0 END)--Pendiente
				,Autorizado	= (CASE WHEN @Accion = 2 THEN 1 ELSE 0 END)--Autorizado
				,Rechazado	= (CASE WHEN @Accion = 3 THEN 1 ELSE 0 END)--Rechazado
				,Cancelado	= (CASE WHEN @Accion = 4 THEN 1 ELSE 0 END)--Cancelado
			WHERE
				FolioSolicitud		= @FolioSolicitud
			AND
				Empleado_Ident		= @Empleado_Ident
			AND
				ConceptoId			= @Concepto_Id
			AND
				NivelAutorizacion	= @NivelAutorizacion
			AND
				Autorizador_Ident	= @Autorizador_Ident
		END

		IF (@Accion <> 3)
			-- Se actualiza la nueva solicitud Pendiente
			BEGIN
				UPDATE CatSolicitudes 
				SET EstatusSolicitudId = 'PA'
				WHERE FolioSolicitud = @FolioSolicitud

				EXEC	[app620].[EnviaSolicitud] @FolioSolicitud = 6

			END
		ELSE
			BEGIN
				UPDATE CatEmpleadosSolicitudes
				SET EstatusSolicitudId	= 'R'
				FROM app620.CatSolicitudEmpleadosAutorizantes SEA 
				WHERE
					SEA.FolioSolicitud	= CatEmpleadosSolicitudes.FolioSolicitud
				AND SEA.Empleado_Ident	= CatEmpleadosSolicitudes.Empleado_Ident
				AND SEA.ConceptoId		= CatEmpleadosSolicitudes.ConceptoId
				AND SEA.Rechazado		= 1

				UPDATE CatSolicitudes 
				SET EstatusSolicitudId = 'R'
				WHERE FolioSolicitud = @FolioSolicitud


			END

		-- En esta sección se revisa si la la solicitud Completa pasa a Autorizada

		SELECT	@CantidadTotalAC =	COUNT(1) 
		FROM	CatEmpleadosSolicitudes 
		WHERE	FolioSolicitud		= @FolioSolicitud
		AND		Empleado_Ident		= @Empleado_Ident
		AND		ConceptoId			= @Concepto_Id
		AND		EstatusSolicitudId	IN ('A', 'C')

		SELECT	@CantidadTotal =	COUNT(1)
		FROM	CatEmpleadosSolicitudes 
		WHERE	FolioSolicitud		= @FolioSolicitud
		AND		Empleado_Ident		= @Empleado_Ident
		AND		ConceptoId			= @Concepto_Id						

		IF (@CantidadTotal = @CantidadTotalAC)
			BEGIN
				UPDATE CatSolicitudes
				SET EstatusSolicitudId = 'A'
				WHERE	FolioSolicitud		= @FolioSolicitud
			END

	SELECT @Estatus

END
