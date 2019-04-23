USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSi]    Script Date: 23/04/2019 08:49:07 a. m. ******/
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
      ,@PeriodoNominaAnio_Id INT = NULL
      ,@PeriodoNominaMes_Id INT = NULL
      ,@PeriodoNominaConsecutivoid VARCHAR(5) = NULL
      ,@PeriodoNominaPeriodicidadNomina_Id VARCHAR(5) = NULL
      ,@PeriodoNominaTipoPeriodo_Id VARCHAR(5) = NULL
      ,@ConceptoId INT = NULL
      ,@MotivoId INT = NULL
      ,@Justficacion VARCHAR(1024) = NULL
      ,@ConceptoMotivoId INT = NULL
      ,@Responsable_Id INT = NULL
      ,@Detalle INT = NULL
      ,@PeriodoOriginal_AnioId INT = NULL
      ,@PeriodoOriginal_MesId INT = NULL
      ,@PeriodoOriginal_ConsecutivoId VARCHAR(5) = NULL
      ,@PeriodoOriginal_PeriodicidadId VARCHAR(5) = NULL
      ,@PeriodoOriginal_TipoPeriodoId VARCHAR(5) = NULL
      ,@Autorizantes VARCHAR(100) = NULL
	  ,@ListaEmpleados VARCHAR(MAX) =NULL
	  ,@UserEmployeeId INT
	  ,@Estatus VARCHAR(10) = '0' OUTPUT
AS
BEGIN
	
	DECLARE
		 @FechaActual DATETIME

	SET @FechaActual = GETDATE();

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro con los mismos parametros. 
		-2 = Ya existe un registro con el mismo nombre de periodo de nomina
	*/

	IF EXISTS	(
						SELECT 1
						FROM app620.CatSolicitudes
						WHERE					
							Perfil_Ident	= @Perfil_Ident
						)
						SET @Estatus = '-1'

	IF EXISTS	(
						SELECT 1
						FROM [app620].[CatSolicitudes] 
						WHERE
							FolioSolicitud		= @FolioSolicitud						
						AND	Fecha_Solicitud		= @Fecha_Solicitud						
						AND	Perfil_Ident	= @Perfil_Ident
						)
						SET @Estatus = '-2'

	IF @Estatus='0'
	BEGIN
	
		DECLARE @idSolicitud INT =0

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
		  ,ConceptoMotivoId
		  ,Responsable_Id
		  ,Detalle
		  ,PeriodoOriginal_AnioId
		  ,PeriodoOriginal_MesId
		  ,PeriodoOriginal_ConsecutivoId
		  ,PeriodoOriginal_PeriodicidadId
		  ,PeriodoOriginal_TipoPeriodoId
		  ,Autorizantes
		  ,Active
		  ,CreatedBy
		  ,LastModifiedBy
		)
     VALUES
		(
		  @Fecha_Solicitud 
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
		  ,@ConceptoMotivoId
		  ,@Responsable_Id 
		  ,@Detalle 
		  ,@PeriodoOriginal_AnioId
		  ,@PeriodoOriginal_MesId 
		  ,@PeriodoOriginal_ConsecutivoId
		  ,@PeriodoOriginal_PeriodicidadId
		  ,@PeriodoOriginal_TipoPeriodoId
		  ,@Autorizantes
		  ,1
		  ,@UserEmployeeId
		  ,@UserEmployeeId
		)
			
	--DECLARE @TempTable1 AS dbo.EmpleadosSolicitud--TABLE (id VARCHAR(800), estatus int default null)
	--INSERT INTO dbo.EmpleadosSolicitud(EmpleadoId)
	--SELECT item FROM dbo.fnSplit(@ListaEmpleados,',')
	
	SELECT @idSolicitud =SCOPE_IDENTITY();

	DECLARE	@return_value int
	
	EXEC	@return_value = [app620].[ProcesaSolicitudEmpleados]
		@SolicitudId = @idSolicitud,
		@Autorizantes = @Autorizantes,
		@UserEmployeeId = @UserEmployeeId,
		@ListaEmpleados =@ListaEmpleados-- @TempTable1
		
	SET @Estatus= CONCAT (@Estatus,'_',@idSolicitud)
	END
END
