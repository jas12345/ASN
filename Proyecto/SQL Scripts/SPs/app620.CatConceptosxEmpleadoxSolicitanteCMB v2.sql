USE [ASN]
GO

DECLARE	@return_value int

EXEC	@return_value = [app620].[CatConceptosxEmpleadoxSolicitanteCMB]
		@Ident = 665422,
		@Ident_Solicitante = 844795

SELECT	'Return Value' = @return_value

GO


		SELECT Perfil_Ident 
		FROM CatPerfilEmpleadosAccesos 
		WHERE (EmpleadoId = 844795 OR 844795 = -1)
		AND Active = 1


