USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSi]    Script Date: 17/06/2019 12:37:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatSolicitudesSi]
	 @FolioSolicitud INT = NULL
	,@Solicitante_Ident INT 
	,@EmployeeId INT 
	,@ConceptoId INT
	,@ConceptoMonto DECIMAL(18,2)
	,@ConceptoMotivoId INT
	,@ResponsableId INT
	,@PeriododOriginalId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	
	DECLARE @idSolicitud INT =0
	DECLARE @FechaActual DATETIME
	DECLARE @FolioSolicitudOut INT = 0

	SET @FechaActual = GETDATE();
	--SET @FolioSolicitudOut = -1;
	SET @Estatus = ISNULL(@Estatus, 0);

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro para esta solicitud.
	*/

	IF EXISTS	(
					SELECT 1
					FROM app620.CatSolicitudes
					WHERE					
						FolioSolicitud	= @FolioSolicitud
				)
		BEGIN
			SET @Estatus = '-1'
			--SET @FolioSolicitudOut	= @FolioSolicitud
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
			SET @Estatus= 0
		END

	IF (@Estatus = 0)
		BEGIN
			INSERT INTO CatEmpleadosSolicitudes
			(
				 FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,ParametroConceptoMonto
			)
			VALUES
			(
				 @FolioSolicitudOut
				,@EmployeeId 
				,@ConceptoId
				,@ConceptoMonto
			)
		END

	IF (@Estatus = 0)
		BEGIN
			INSERT INTO CatSolicitudEmpleadosDetalle
			(
				 FolioSolicitud
				,Empleado_Ident
				,ConceptoId
				,ConceptoMotivoId
				,ResponsableId
				,PeriodoOriginalId
			)
			VALUES
			(
				 @FolioSolicitudOut
				,@EmployeeId 
				,@ConceptoId
				,@ConceptoMonto
				,@ResponsableId
				,@PeriododOriginalId

			)
		END
END
