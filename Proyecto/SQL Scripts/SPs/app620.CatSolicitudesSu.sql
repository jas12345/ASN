USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSu]    Script Date: 23/04/2019 08:51:10 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatSolicitudesSu]
	 @FolioSolicitud INT
      ,@Fecha_Solicitud DATETIME = NULL
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
	  ,@Estatus INT = 0 OUTPUT
	  ,@UserEmployeeId INT
AS
BEGIN
	
	DECLARE
		 @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	SET @Estatus	 = ISNULL(@Estatus, 0)

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
						SET @Estatus = @Estatus -1

	IF EXISTS	(
						SELECT 1
						FROM [app620].[CatSolicitudes] 
						WHERE
							FolioSolicitud		= @FolioSolicitud						
						AND	Fecha_Solicitud		= @Fecha_Solicitud						
						AND	Perfil_Ident	= @Perfil_Ident
						)
						SET @Estatus = @Estatus -2

	IF @Estatus=0
	BEGIN

	UPDATE [app620].[CatSolicitudes]
		SET
		   Fecha_Solicitud = @Fecha_Solicitud
		  ,Solicitante_Ident = @Solicitante_Ident
		  ,Puesto_solicitante_Ident = @Puesto_solicitante_Ident
		  ,PeriodoNominaAnio_Id = @PeriodoNominaAnio_Id
		  ,PeriodoNominaMes_Id = @PeriodoNominaMes_Id
		  ,PeriodoNominaConsecutivoid = @PeriodoNominaConsecutivoid
		  ,PeriodoNominaPeriodicidadNomina_Id = @PeriodoNominaPeriodicidadNomina_Id
		  ,PeriodoNominaTipoPeriodo_Id = @PeriodoNominaTipoPeriodo_Id
		  ,ConceptoId = @ConceptoId
		  ,MotivoId = @MotivoId
		  ,Justficacion = @Justficacion
		  ,ConceptoMotivoId = @ConceptoMotivoId
		  ,Responsable_Id = @Responsable_Id
		  ,Detalle = @Detalle
		  ,PeriodoOriginal_AnioId = @PeriodoOriginal_AnioId
		  ,PeriodoOriginal_MesId = @PeriodoOriginal_MesId
		  ,PeriodoOriginal_ConsecutivoId = @PeriodoOriginal_ConsecutivoId
		  ,PeriodoOriginal_PeriodicidadId = @PeriodoOriginal_PeriodicidadId
		  ,PeriodoOriginal_TipoPeriodoId = @PeriodoOriginal_TipoPeriodoId
		  ,Autorizantes = @Autorizantes
		WHERE 
			FolioSolicitud = @FolioSolicitud
		--AND
		--	Perfil_Ident = @Perfil_Ident				  
				  
	END
END
