USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[AutorizadoresxConceptoCMB]    Script Date: 20/07/2019 04:39:47 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CatConceptosNivelAutorizadorSi]
(
	  @ConceptoId INT		= 0
	 ,@NivelId INT			= 0
	 ,@AutorizadorIdent	INT	= 0
	 ,@UserEmployeeId INT	= 0
)
AS

BEGIN
	DECLARE @FechaActual DATETIME

	SET @ConceptoId = ISNULL(@ConceptoId, 0)
	SET @NivelId = ISNULL(@NivelId, 0)

	SET @FechaActual = GETDATE();

	IF NOT EXISTS (
		SELECT	
			1 
		FROM 
			CatConceptosNivelAutorizador 
		WHERE 
			ConceptoId	= @ConceptoId
		AND
			NivelId		= @NivelId
	)
		BEGIN
			INSERT CatConceptosNivelAutorizador
				(ConceptoId, NivelId, AutorizadorIdent, CreatedBy, LastModifiedBy, LastModifiedDate)
			VALUES	
				(@ConceptoId, @NivelId, @AutorizadorIdent, @UserEmployeeId, @UserEmployeeId, @FechaActual)
		END
	ELSE
		BEGIN
			UPDATE
				 CatConceptosNivelAutorizador
			SET  AutorizadorIdent	= @AutorizadorIdent
				,LastModifiedBy		= @UserEmployeeId
				,LastModifiedDate	= @FechaActual

			--VALUES (@AutorizadorIdent)
			WHERE 
				ConceptoId	= @ConceptoId
			AND
				NivelId		= @NivelId
		END
END
