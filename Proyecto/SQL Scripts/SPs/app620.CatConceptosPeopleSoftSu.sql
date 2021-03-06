USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosPeopleSoftSu]    Script Date: 05/07/2019 11:54:17 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CatConceptosPeopleSoftSu]
	 @ConceptoId INT
	,@Descripcion VARCHAR(50)
	,@UserEmployeeId INT
	,@Active BIT
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

	IF EXISTS		(
						SELECT 1 
						FROM [app620].[CatConceptosPeopleSoft] 
						WHERE [ConceptoId] = @ConceptoId
					)
	AND NOT EXISTS	(
						SELECT 1 
						FROM [app620].[CatConceptosPeopleSoft] 
						WHERE	ConceptoId	<> @ConceptoId 
						AND		Descripcion			= @Descripcion
					)
		BEGIN
			UPDATE [app620].[CatConceptosPeopleSoft]
			SET 
				 [Descripcion]			= @Descripcion
				,[Active]				= @Active
				,LastModifiedBy			= @UserEmployeeId
				,LastModifiedDate		= @FechaActual

				,DeactivatedBy			= IIF(@Active=1,NULL,@UserEmployeeId)
				,DeactivatedDate		= IIF(@Active=1,NULL,@FechaActual)
				,LastModifiedFromPCName	= HOST_NAME()
			WHERE
				[ConceptoId] = @ConceptoId

		END
	ELSE
		SET @Estatus = -1
END
