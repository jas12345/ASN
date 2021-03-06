USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosNivelMontoAutorizacionSi]    Script Date: 23/12/2019 11:38:30 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CatConceptosNivelMontoAutorizacionSi]
(
	 @ConceptoId			INT	= 0
	,@NivelId				INT	= 0
	,@MontoAutorizacion		DECIMAL(18,2)	= 0

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
		-1 = Ya existe un registro con el mismo Concepto/Nivel para ese Monto.
	*/
	
	IF EXISTS	(
					SELECT	
						1 
					FROM 
						app620.CatConceptosNivelMontoAutorizacion 
					WHERE 
						ConceptoId			= @ConceptoId
					AND
						NivelId				= @NivelId
				)
		SET @Estatus = -1

		--SELECT @Estatus Estatus 

	IF @Estatus = 0
		BEGIN

			IF NOT EXISTS (
				SELECT	
					1 
				FROM 
					app620.CatConceptosNivelMontoAutorizacion 
				WHERE 
					ConceptoId	= @ConceptoId
				AND
					NivelId		= @NivelId
			)
				BEGIN
					INSERT app620.CatConceptosNivelMontoAutorizacion
						(ConceptoId, NivelId, MontoAutorizacion, CreatedBy, LastModifiedBy, LastModifiedDate)
					VALUES	
						(@ConceptoId, @NivelId, @MontoAutorizacion, @UserEmployeeId, @UserEmployeeId, @FechaActual)

				END
			ELSE
				BEGIN
					UPDATE
						 app620.CatConceptosNivelMontoAutorizacion
					SET  MontoAutorizacion	= @MontoAutorizacion
						,LastModifiedBy		= @UserEmployeeId
						,LastModifiedDate	= @FechaActual

					WHERE 
						ConceptoId	= @ConceptoId
					AND
						NivelId		= @NivelId

				END
		END
END
