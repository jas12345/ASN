ALTER PROCEDURE [app620].[NivelesAutorizacionxEmpleadoxConcepto]
(
	@EmpleadoIdent INT = 0--2964012
	,@ConceptoId INT = 0--2
	,@FolioId INT = 0--87
)
AS

BEGIN
	SET @ConceptoId = ISNULL(@ConceptoId, 0)

	--SELECT * FROM app620.CatSolicitudEmpleadosAutorizantes WHERE FolioSolicitud = @FolioId AND Empleado_Ident = @EmpleadoIdent AND ConceptoId = @ConceptoId AND Autorizador_Ident IS NOT NULL

	IF EXISTS(SELECT 1 FROM app620.CatSolicitudEmpleadosAutorizantes WHERE FolioSolicitud = @FolioId AND Empleado_Ident = @EmpleadoIdent AND ConceptoId = @ConceptoId AND Autorizador_Ident IS NOT NULL)
	BEGIN
		--SELECT 'verdadero'
		SELECT 
		NivelAutorizacion AS Nivel
		,Autorizador_Ident AS Id
		,b.Nombre AS Valor
		FROM app620.CatSolicitudEmpleadosAutorizantes a
		INNER JOIN [app620].[CatEmployeeCCMSVw] b on a.Autorizador_Ident = b.Ident
		WHERE FolioSolicitud = @FolioId AND Empleado_Ident = @EmpleadoIdent AND ConceptoId = @ConceptoId AND Autorizador_Ident IS NOT NULL
	END
	ELSE
	BEGIN
		--SELECT 'falso'
		SELECT DISTINCT 
			 ISNULL(PEA.Nivel, 999) Nivel
			,PEA.EmpleadoId Id
			,Aut.Nombre		Valor
			--, PE.ConceptoId
		FROM
			 app620.CatPerfilEmpleadosAccesos PEA
		JOIN app620.CatPerfilEmpleados PE ON PE.Perfil_Ident = PEA.Perfil_Ident
		JOIN app620.RelPerfilEmpleadosConceptos REC ON REC.Perfil_Ident = PE.Perfil_Ident
		JOIN app620.CatConceptos C ON (C.ConceptoId	= REC.ConceptoId)
		JOIN [app620].[CatEmployeeCCMSVw] Aut ON Aut.Ident		= PEA.EmpleadoId
		JOIN [app620].[CatEmployeeCCMSVw] Emp ON Emp.Ident		= @EmpleadoIdent
			AND	(PE.Country_Ident = Emp.Country_Ident OR PE.Country_Ident = -1)
			AND	(PE.Location_Ident = Emp.Location_Ident OR PE.Location_Ident = -1)
			AND	(PE.Client_Ident = Emp.Client_Ident OR PE.Client_Ident = -1)
			AND	(PE.Program_Ident = Emp.Program_Ident OR PE.Program_Ident = -1)
			AND (PE.Contract_Type_Ident = Emp.Contract_Type_Ident OR PE.Contract_Type_Ident = -1)
		JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity ON (BiosCity.location_bios = PE.City_Ident  OR PE.City_Ident = -1)
			AND (BiosCity.location_ccms = Emp.Location_Ident)

		WHERE 
			PEA.Active		= 1
			AND	PE.TipoAccesoId	= 2	--El perfil es de Autorizadores
			AND PE.Active		= 1
			AND C.Active		= 1
			AND (
					C.ConceptoId	= @ConceptoId 
				OR 
					@ConceptoId	= 0
				)
			AND
				PEA.Nivel		<= C.NumeroNivelAutorizante
		ORDER BY Nivel
	END
END

