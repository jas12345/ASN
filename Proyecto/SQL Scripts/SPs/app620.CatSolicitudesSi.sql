USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSi]    Script Date: 08/05/2019 11:02:55 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatSolicitudesSi]
	 @FolioSolicitud INT
      ,@Fecha_Solicitud VARCHAR(10) = NULL
      ,@Perfil_Ident INT
      ,@Solicitante_Ident INT = NULL
      ,@Solicintante_Nombre VARCHAR(100) = NULL
      ,@Puesto_solicitante_Ident INT = NULL
      ,@PeriodoNomina_Id VARCHAR(50)
      ,@ConceptoId INT = NULL
      ,@MotivoId INT = NULL
      ,@Justficacion VARCHAR(1024) = NULL
      ,@Responsable_Id INT = NULL
      ,@Detalle INT = NULL
	  ,@PeriodoNominaOriginal_Id VARCHAR(50)      
      ,@Autorizantes VARCHAR(100) = NULL
	  ,@ListaEmpleados VARCHAR(MAX) =NULL
	  ,@UserEmployeeId INT
	  ,@Estatus VARCHAR(10) = '0' OUTPUT
AS
BEGIN
	
	DECLARE
		 @FechaActual DATETIME
		 ,@PeriodoNominaAnio_Id INT
		 ,@PeriodoNominaMes_Id INT = NULL
		 ,@PeriodoNominaConsecutivoid VARCHAR(5) = NULL
		 ,@PeriodoNominaPeriodicidadNomina_Id VARCHAR(5) = NULL
		 ,@PeriodoNominaTipoPeriodo_Id VARCHAR(5) = NULL
		 ,@PeriodoOriginal_AnioId INT = NULL
		 ,@PeriodoOriginal_MesId INT = NULL
		 ,@PeriodoOriginal_ConsecutivoId VARCHAR(5) = NULL
		 ,@PeriodoOriginal_PeriodicidadId VARCHAR(5) = NULL
		 ,@PeriodoOriginal_TipoPeriodoId VARCHAR(5) = NULL

	SET @FechaActual = GETDATE();

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro con los mismos parametros. 
		-2 = Ya existe un registro con el mismo nombre de periodo de nomina
	*/

	--IF EXISTS	(
	--					SELECT 1
	--					FROM app620.CatSolicitudes
	--					WHERE					
	--						Perfil_Ident	= @Perfil_Ident
	--					)
	--					SET @Estatus = '-1'

	--IF EXISTS	(
	--					SELECT 1
	--					FROM [app620].[CatSolicitudes] 
	--					WHERE
	--						FolioSolicitud		= @FolioSolicitud						
	--					AND	Fecha_Solicitud		= @Fecha_Solicitud						
	--					AND	Perfil_Ident	= @Perfil_Ident
	--					)
	--					SET @Estatus = '-2'

	IF @Estatus='0'
	BEGIN
	
		DECLARE @idSolicitud INT =0

		SELECT @ConceptoId = ConceptoId
		FROM [app620].[CatPerfilEmpleados] 
		WHERE Perfil_Ident	= @Perfil_Ident

		SELECT 
		@PeriodoNominaAnio_Id = AnioId,
		@PeriodoNominaMes_Id = MesId,
		@PeriodoNominaConsecutivoid = ConsecutivoId,
		@PeriodoNominaPeriodicidadNomina_Id = PeriodicidadNominaId,
		@PeriodoNominaTipoPeriodo_Id = TipoPeriodo
		FROM app620.CatPeriodosNomina where NombrePeriodo = @PeriodoNomina_Id

		IF @PeriodoNominaOriginal_Id <> ''
		BEGIN
			SELECT 
			@PeriodoOriginal_AnioId = AnioId,
			@PeriodoOriginal_MesId = MesId,
			@PeriodoOriginal_ConsecutivoId = ConsecutivoId,
			@PeriodoOriginal_PeriodicidadId = PeriodicidadNominaId,
			@PeriodoOriginal_TipoPeriodoId = TipoPeriodo
			FROM app620.CatPeriodosNomina where NombrePeriodo = @PeriodoNominaOriginal_Id
		END

		INSERT INTO [app620].[CatSolicitudes]
		(
		  Fecha_Solicitud
		  ,Perfil_Ident
		  ,Solicitante_Ident
		  ,Solicintante_Nombre
		  ,Puesto_solicitante_Ident
		  ,PeriodoNominaAnio_Id
		  ,PeriodoNominaMes_Id
		  ,PeriodoNominaConsecutivoid
		  ,PeriodoNominaPeriodicidadNomina_Id
		  ,PeriodoNominaTipoPeriodo_Id
		  ,ConceptoId
		  ,MotivoId
		  ,Justficacion
		  ,Responsable_Id
		  ,Detalle
		  ,PeriodoOriginal_AnioId
		  ,PeriodoOriginal_MesId
		  ,PeriodoOriginal_ConsecutivoId
		  ,PeriodoOriginal_PeriodicidadId
		  ,PeriodoOriginal_TipoPeriodoId
		  ,Autorizantes
		  ,EstatusSolicitudId
		  ,Active
		  ,CreatedBy
		  ,LastModifiedBy
		)
     VALUES
		(
		  @FechaActual
		  ,@Perfil_Ident
		  ,@Solicitante_Ident
		  ,@Solicintante_Nombre
		  ,@Puesto_solicitante_Ident
		  ,@PeriodoNominaAnio_Id
		  ,@PeriodoNominaMes_Id 
		  ,@PeriodoNominaConsecutivoid
		  ,@PeriodoNominaPeriodicidadNomina_Id
		  ,@PeriodoNominaTipoPeriodo_Id
		  ,@ConceptoId
		  ,@MotivoId 
		  ,@Justficacion 
		  ,@Responsable_Id 
		  ,@Detalle 
		  ,@PeriodoOriginal_AnioId
		  ,@PeriodoOriginal_MesId 
		  ,@PeriodoOriginal_ConsecutivoId
		  ,@PeriodoOriginal_PeriodicidadId
		  ,@PeriodoOriginal_TipoPeriodoId
		  ,@Autorizantes
		  ,'EB'
		  ,1
		  ,@UserEmployeeId
		  ,@UserEmployeeId
		)
				
	SELECT @idSolicitud =SCOPE_IDENTITY();
		
	SET @Estatus= CONCAT (@Estatus,'_',@idSolicitud)
	END
END
