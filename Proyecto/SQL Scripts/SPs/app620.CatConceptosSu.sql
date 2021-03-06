USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosSu]    Script Date: 09/07/2019 11:45:56 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CatConceptosSu]
	 @ConceptoId INT
	,@Descripcion VARCHAR(50)
	,@TipoConceptoId INT	
	,@PaisId VARCHAR(50)
	,@ClienteId INT
	,@PeopleSoftId INT
	,@NumeroNivelAutorizante INT = NULL
	,@AutorizacionAutomatica BIT = NULL
	,@AutorizacionObligatoria BIT = NULL
	,@Vigencia VARCHAR(50)
	,@PagosFijos BIT = NULL
	,@Tope DECIMAL(18,2)
	,@PeriodicidadNominaId VARCHAR(100) = NULL
	,@FechaInicio VARCHAR(10)
	,@FechaFin VARCHAR(10)
	,@ParametroConceptoId INT = NULL
	,@Active BIT
	,@UserEmployeeId INT
	,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE
		 @FechaActual DATETIME
		,@DeactivatedBy INT
		,@DeactivatedDate DATETIME
		,@LastModifiedBy INT
		,@LastModifiedDate DATETIME

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe un registro con la misma descripción
	*/
	
	SET @FechaActual = GETDATE();

	IF (@PagosFijos = 0)
	BEGIN
		SET @Tope = NULL
		SET @PeriodicidadNominaId = NULL
		SET @FechaInicio = NULL
		SET @FechaFin = NULL
	END

	IF EXISTS		(
						SELECT 1 
						FROM [app620].[CatConceptos] 
						WHERE [ConceptoId] = @ConceptoId
					)
	AND NOT EXISTS	(
						SELECT 1 
						FROM [app620].[CatConceptos] 
						WHERE	ConceptoId		<> @ConceptoId 
						AND		Descripcion		= @Descripcion
					)
		BEGIN
			UPDATE [app620].[CatConceptos]
			SET 
				 [Descripcion]			= @Descripcion
				,[TipoConceptoId]		= @TipoConceptoId
				,[Active]				= @Active
				,LastModifiedBy			= @UserEmployeeId
				,LastModifiedDate		= @FechaActual
				,PaisId = @PaisId 
				,ClienteId = @ClienteId 
				,PeopleSoftId = @PeopleSoftId 
				,NumeroNivelAutorizante = @NumeroNivelAutorizante 
				,AutorizacionAutomatica = @AutorizacionAutomatica 
				,AutorizacionObligatoria = @AutorizacionObligatoria 

				,Vigencia = @Vigencia
				,PagosFijos = @PagosFijos
				,Tope = @Tope
				,PeriodicidadNominaId = @PeriodicidadNominaId
				,FechaInicio = @FechaInicio
				,FechaFin = @FechaFin
				,ParametroConceptoId = @ParametroConceptoId

				,DeactivatedBy			= IIF(@Active=1,NULL,@UserEmployeeId)
				,DeactivatedDate		= IIF(@Active=1,NULL,@FechaActual)
				,LastModifiedFromPCName	= HOST_NAME()
			WHERE
				[ConceptoId] = @ConceptoId

		END
	ELSE
		SET @Estatus = -1
END
