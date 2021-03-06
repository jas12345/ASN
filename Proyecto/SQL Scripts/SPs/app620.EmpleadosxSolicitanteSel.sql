USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[EmpleadosxPerfilSel]    Script Date: 10/07/2019 02:46:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[EmpleadosxSolicitanteSel]
(
	  @Solicitante_Ident	INT = -1
	 ,@Empleado_Ident		INT = -1
)
AS

BEGIN

	SELECT
		 @Solicitante_Ident	= ISNULL(@Solicitante_Ident, -1)
		,@Empleado_Ident	= ISNULL(@Empleado_Ident, -1)

	SELECT DISTINCT Emp.Ident
	FROM [app620].[CatEmployeeCCMSVw] Emp
	JOIN CatPerfilEmpleados PE
	ON (PE.Country_Ident = Emp.Country_Ident OR PE.Country_Ident = -1)
	AND  (PE.Location_Ident = Emp.Location_Ident OR PE.Location_Ident = -1)
	AND  (PE.Client_Ident = Emp.Client_Ident OR PE.Client_Ident = -1)
	AND  (PE.Program_Ident = Emp.Program_Ident OR PE.Program_Ident = -1)
	AND  (PE.Contract_Type_Ident = Emp.Contract_Type_Ident OR PE.Contract_Type_Ident = -1)

	JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity 
	ON (BiosCity.location_bios = PE.City_Ident  OR PE.City_Ident = -1)
	AND (BiosCity.location_ccms = Emp.Location_Ident)
	WHERE 
		PE.Perfil_Ident IN (
		SELECT Perfil_Ident 
		FROM CatPerfilEmpleadosAccesos 
		WHERE (EmpleadoId = @Solicitante_Ident OR @Solicitante_Ident = -1)
		AND Active = 1
	)
	AND (emp.Ident = @Empleado_Ident OR @Empleado_Ident = -1)

END
