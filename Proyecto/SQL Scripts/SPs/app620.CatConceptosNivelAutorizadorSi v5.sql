USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosNivelAutorizadorSi]    Script Date: 17/12/2019 05:51:50 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CatConceptosNivelAutorizadorSi]
(
	 @ConceptoId			INT	= 0
	,@NivelId				INT	= 0
	,@AutorizadorIdent		INT	= 0
	,@UserEmployeeId		INT	= 0
	,@Estatus				INT = 0 OUTPUT
)
AS

BEGIN
	DECLARE @FechaActual DATETIME

	SET @ConceptoId = ISNULL(@ConceptoId, 0)
	SET @NivelId = ISNULL(@NivelId, 0)

	SET @FechaActual = GETDATE();

	-- Se inicializa @Estatus a cero si el valor de entrada es NULL
	SET @Estatus = ISNULL(@Estatus, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
		 0 = Proceso sin error
		-1 = Ya existe un registro con el mismo Autorizador para ese Concepto.
	*/
	
	IF EXISTS	(
					SELECT	
						1 
					FROM 
						app620.CatConceptosNivelAutorizador 
					WHERE 
						ConceptoId			= @ConceptoId
					AND
						AutorizadorIdent	= @AutorizadorIdent 
					AND
						NivelId				<> @NivelId
				)
		SET @Estatus = @Estatus -1

	IF @Estatus = 0
		BEGIN
			IF NOT EXISTS (
				SELECT	
					1 
				FROM 
					app620.CatConceptosNivelAutorizador 
				WHERE 
					ConceptoId	= @ConceptoId
				AND
					NivelId		= @NivelId
			)
				BEGIN
					INSERT app620.CatConceptosNivelAutorizador
						(ConceptoId, NivelId, AutorizadorIdent, CreatedBy, LastModifiedBy, LastModifiedDate)
					VALUES	
						(@ConceptoId, @NivelId, @AutorizadorIdent, @UserEmployeeId, @UserEmployeeId, @FechaActual)
				END
			ELSE
				BEGIN
					UPDATE
						 app620.CatConceptosNivelAutorizador
					SET  AutorizadorIdent	= @AutorizadorIdent
						,LastModifiedBy		= @UserEmployeeId
						,LastModifiedDate	= @FechaActual

					--VALUES (@AutorizadorIdent)
					WHERE 
						ConceptoId	= @ConceptoId
					AND
						NivelId		= @NivelId
				END

			SELECT @Estatus = 0
		END

	SELECT @Estatus Estatus
END
