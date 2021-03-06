USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudEmpleadosDetalleSi]    Script Date: 12/06/2019 05:36:02 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatSolicitudEmpleadosDetalleSi]
	 @SolicitudId INT
    ,@CatEmpleadoId INT
    ,@CatConceptoMotivoId INT
	,@PeriodoNomina VARCHAR(100) = ''
	,@ReponsableId INT = 0
	,@Monto DECIMAL(18,2)=0
	,@Detalle VARCHAR(250)=''
	,@TTConceptoMotivoId BIT = 0
	,@TTManager_Ident BIT = 0
	,@TTMonto BIT = 0
	,@TTDetalle BIT = 0
	,@TTPeriodoNomina BIT = 0
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE @FechaActual DATETIME
	DECLARE 
	@AnioId INT = 0,
	@MesId INT = 0,
	@ConsecutivoId VARCHAR(5) = '',
	@PeriodicidadNominaId VARCHAR(5)='',
	@TipoPeriodo VARCHAR(5) =''

	SET @FechaActual = GETDATE();
	SET @Estatus = ISNULL(@Estatus, 0)

	--IF EXISTS( SELECT 1 FROM [app620].CatSolicitudEmpleadosDetalle WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId AND CatConceptoMotivoId=@CatConceptoMotivoId)
	--SET @Estatus = @Estatus -1

	IF(@PeriodoNomina <> '')
		SELECT @AnioId=AnioId,@MesId=MesId,@ConsecutivoId=ConsecutivoId,@PeriodicidadNominaId = PeriodicidadNominaId,@TipoPeriodo=TipoPeriodo FROM app620.CatPeriodosNomina WHERE NombrePeriodo = @PeriodoNomina
		
	IF NOT EXISTS( SELECT 1 FROM [app620].CatSolicitudEmpleadosDetalle WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId AND CatConceptoMotivoId=@CatConceptoMotivoId)--@Estatus=0
		BEGIN
				DECLARE @Responsable INT=0
				SELECT @Responsable = Manager_Ident 
				FROM [app620].[CatEmployeeCCMSVw] 
				WHERE Ident = @CatEmpleadoId

			INSERT INTO [app620].[CatSolicitudEmpleadosDetalle]
			(
				FolioSolicitud
				  ,Empleado_Ident
				  ,CatConceptoMotivoId	
				  ,ResponsableId
				  ,[PeriodoOriginalAnio_Id]		 
				  ,[PeriodoOriginalMes_Id]
				  ,[PeriodoOriginalConsecutivoid]
				  ,[PeriodoOriginalPeriodicidadNomina_Id]
				  ,[PeriodoOriginalTipoPeriodo_Id]
				  ,Active
				  ,CreatedBy
				  ,CreatedDate
				  ,LastModifiedBy  
			)
			VALUES
			(	@SolicitudId
				  ,@CatEmpleadoId
				  ,@CatConceptoMotivoId
				  ,@Responsable
				  ,@AnioId
				  ,@MesId
				  ,@ConsecutivoId
				  ,@PeriodicidadNominaId
				  ,@TipoPeriodo
				  ,1
				  ,@UserEmployeeId
				  ,@FechaActual
				  ,@UserEmployeeId
			)
		END
	ELSE
		BEGIN
			--UPDATE [app620].CatSolicitudEmpleadosDetalle SET Active=1 WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId AND CatConceptoMotivoId=@CatConceptoMotivoId
			UPDATE [app620].CatSolicitudEmpleadosDetalle 
			SET Active=1, [PeriodoOriginalAnio_Id] = @AnioId,
			[PeriodoOriginalMes_Id] =@MesId,
			[PeriodoOriginalConsecutivoid] = @ConsecutivoId,
			[PeriodoOriginalPeriodicidadNomina_Id] = @PeriodicidadNominaId,
			[PeriodoOriginalTipoPeriodo_Id] = @TipoPeriodo
			WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@CatEmpleadoId AND CatConceptoMotivoId=@CatConceptoMotivoId
		END

	IF @ReponsableId <> 0 OR @TTConceptoMotivoId = 1 OR @TTManager_Ident = 1 OR @TTDetalle =1 OR @TTMonto = 1 OR @TTPeriodoNomina = 1
		BEGIN 
			-- Si encuentra que esta seleccionado el check de todo de ConceptoMotivo
			-- Consultar todos los empleados de la tabla solicitudes que esten activos y validar si existen en LA TABLA CatSolicitudEmpleadosDetalle
			-- Realiza un insert y asignarle el concepto o un update seguin sea el caso
			IF @TTConceptoMotivoId = 1
				BEGIN

				DECLARE @TempEmpleadosSolicitud TABLE (Id INT IDENTITY(1, 1),idEmpleado INT)
				DECLARE @indiceBase int=1,@TotalRegistros int=0;
				SELECT @TotalRegistros=COUNT(*) FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud = @SolicitudId AND Active=1

				INSERT INTO @TempEmpleadosSolicitud (idEmpleado)
				SELECT Empleado_Ident FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud = @SolicitudId AND Active=1

					WHILE 	@indiceBase <= @TotalRegistros
					BEGIN

						DECLARE @CatEmpleado_Id INT = 0

						SELECT @CatEmpleado_Id= idEmpleado  FROM @TempEmpleadosSolicitud WHERE Id=@indiceBase

						IF NOT EXISTS(SELECT 1 FROM [app620].[CatSolicitudEmpleadosDetalle] WHERE FolioSolicitud = @SolicitudId AND Empleado_Ident = @CatEmpleado_Id)
						BEGIN
							DECLARE @Responsable_Id INT=0

							SELECT @Responsable_Id = Manager_Ident FROM [app620].[CatEmployeeCCMSVw] WHERE Ident = @CatEmpleado_Id

							INSERT INTO [app620].[CatSolicitudEmpleadosDetalle]
							(
								FolioSolicitud
								  ,Empleado_Ident
								  ,CatConceptoMotivoId	
								  ,ResponsableId
								  ,[PeriodoOriginalAnio_Id]		 
								  ,[PeriodoOriginalMes_Id]
								  ,[PeriodoOriginalConsecutivoid]
								  ,[PeriodoOriginalPeriodicidadNomina_Id]
								  ,[PeriodoOriginalTipoPeriodo_Id]
								  ,Active
								  ,CreatedBy
								  ,CreatedDate
								  ,LastModifiedBy  
							)
							VALUES
							(	@SolicitudId
								  ,@CatEmpleado_Id
								  ,@CatConceptoMotivoId
								  ,@Responsable_Id
								  ,@AnioId
								  ,@MesId
								  ,@ConsecutivoId
								  ,@PeriodicidadNominaId
								  ,@TipoPeriodo
								  ,1
								  ,@UserEmployeeId
								  ,@FechaActual
								  ,@UserEmployeeId
							)
						END
						ELSE
						BEGIN
							UPDATE [app620].[CatSolicitudEmpleadosDetalle]
							SET
								CatConceptoMotivoId		= @CatConceptoMotivoId
								,Active					= 1
								,LastModifiedBy			= @UserEmployeeId
								,LastModifiedDate		= @FechaActual
								,DeactivatedBy			= @UserEmployeeId --IIF(@Active=0,NULL,@UserEmployeeId)
								,DeactivatedDate		= @FechaActual --IIF(@Active=0,NULL,@FechaActual)
								,LastModifiedFromPCName	= HOST_NAME()
							WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident = @CatEmpleado_Id
						END

						SET @indiceBase= @indiceBase+1
					END
				END

			IF @ReponsableId <> 0
				BEGIN
					DECLARE @Empleado_Ident INT,
						@Empleado_First_Name VARCHAR(100),
						@Empleado_Middle_Name VARCHAR(100),
						@Empleado_Last_Name VARCHAR(100),
						@Empleado_Position_Code_Ident INT,
						@Empleado_Position_Code_Title VARCHAR(100),
						@Empleado_Contract_Type_Ident INT,
						@Empleado_Contract_Type VARCHAR(100)

					SELECT 
						@Empleado_Ident = Ident,
						@Empleado_First_Name = First_Name,
						@Empleado_Middle_Name = Middle_Name,
						@Empleado_Last_Name = Last_Name,
						@Empleado_Position_Code_Ident = Position_Code_Ident,
						@Empleado_Position_Code_Title = Position_Code_Title,
						@Empleado_Contract_Type_Ident = Contract_Type_Ident,
						@Empleado_Contract_Type = Contract_Type
					FROM [app620].[CatEmployeeCCMSVw] WHERE Ident = @ReponsableId

					UPDATE [app620].[CatEmpleadosSolicitudes] 
					SET
						ParametroConceptoMonto =@Monto, Detalle = @Detalle 
						,[Manager_Ident] = @Empleado_Ident
						,[Manager_First_Name] = @Empleado_First_Name
						,[Manager_Middle_Name] = @Empleado_Middle_Name
						,[Manager_Last_Name] = @Empleado_Last_Name
						,[Manager_Position_Code_Ident] = @Empleado_Position_Code_Ident
						,[Manager_Position_Code_Title] = @Empleado_Position_Code_Title
						,[Manager_Contract_Type_Ident] = @Empleado_Contract_Type_Ident
						,[Manager_Contract_Type] = @Empleado_Contract_Type
					WHERE FolioSolicitud =@SolicitudId AND Empleado_Ident = @CatEmpleadoId
				END

			IF @TTManager_Ident = 1
				BEGIN
				UPDATE [app620].[CatSolicitudEmpleadosDetalle]
				SET
					ResponsableId			= @ReponsableId
					,LastModifiedBy			= @UserEmployeeId
					,LastModifiedDate		= @FechaActual
					,DeactivatedBy			= @UserEmployeeId--IIF(@Active=0,NULL,@UserEmployeeId)
					,DeactivatedDate		= @FechaActual --IIF(@Active=0,NULL,@FechaActual)
					,LastModifiedFromPCName	= HOST_NAME()
					WHERE FolioSolicitud=@SolicitudId AND Active =1
				END

			IF @TTDetalle =1
				BEGIN
					UPDATE [app620].[CatEmpleadosSolicitudes]
					SET Detalle =  @Detalle
					WHERE FolioSolicitud=@SolicitudId AND Active =1
				END

			IF @TTMonto = 1
				BEGIN
					UPDATE [app620].[CatEmpleadosSolicitudes]
					SET ParametroConceptoMonto =  @Monto
					WHERE FolioSolicitud=@SolicitudId AND Active =1
				END

			IF @TTPeriodoNomina = 1
				BEGIN

					DECLARE
						@PeriodoOriginalAnio_Id INT
						,@PeriodoOriginalMes_Id INT
						,@PeriodoOriginalConsecutivoid VARCHAR(5)
						,@PeriodoOriginalPeriodicidadNomina_Id VARCHAR(5)
						,@PeriodoOriginalTipoPeriodo_Id VARCHAR(5) 
	  
					SELECT
						 @PeriodoOriginalAnio_Id = AnioId
						,@PeriodoOriginalMes_Id = MesId
						,@PeriodoOriginalConsecutivoid = ConsecutivoId
						,@PeriodoOriginalPeriodicidadNomina_Id = PeriodicidadNominaId
						,@PeriodoOriginalTipoPeriodo_Id = TipoPeriodo
					FROM [ASN].[app620].[CatPeriodosNomina] WHERE NombrePeriodo = @PeriodoNomina
	  
					UPDATE [app620].[CatSolicitudEmpleadosDetalle]
					SET
						 [PeriodoOriginalAnio_Id]				= @PeriodoOriginalAnio_Id
						,[PeriodoOriginalMes_Id]				= @PeriodoOriginalMes_Id
						,[PeriodoOriginalConsecutivoid]			= @PeriodoOriginalConsecutivoid
						,[PeriodoOriginalPeriodicidadNomina_Id]	= @PeriodoOriginalPeriodicidadNomina_Id
						,[PeriodoOriginalTipoPeriodo_Id]		= @PeriodoOriginalTipoPeriodo_Id
						,LastModifiedBy							= @UserEmployeeId
						,LastModifiedDate						= @FechaActual
						,DeactivatedBy							= @UserEmployeeId --IIF(@Active=0,NULL,@UserEmployeeId)
						,DeactivatedDate						= @FechaActual --IIF(@Active=0,NULL,@FechaActual)
						,LastModifiedFromPCName					= HOST_NAME()
					WHERE FolioSolicitud=@SolicitudId AND Active=1
				 END
		END
END

