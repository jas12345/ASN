USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[SolicitudEmpleadosxPerfilCMB]    Script Date: 23/05/2019 07:43:26 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[SolicitudEmpleadosxPerfilCMB]
(
	 @Perfil_Ident			INT = -1
	 ,@Solicitud INT =0
)
AS

BEGIN

	IF @Solicitud =0
	BEGIN
		SELECT
			 @Perfil_Ident			= ISNULL(@Perfil_Ident, -1)
	END
	ELSE
	BEGIN
		SELECT @Perfil_Ident = [Perfil_Ident] FROM [app620].[CatSolicitudes] WHERE [FolioSolicitud] = @Solicitud	
	END

		SELECT
			  Emp.Ident 
			, Emp.Nombre AS Value	
		FROM
			app620.CatEmployeeCCMSVw AS Emp 
			JOIN app620.CatLocationVw AS Loc 
				ON Emp.Location_Ident = Loc.Location_Ident 
			JOIN app620.CatPerfilEmpleados Perfil
				ON	(Perfil.Perfil_Ident		= @Perfil_Ident				OR	@Perfil_Ident				= -1)

				--AND	(Emp.Company_Ident			= Perfil.Company_Ident			OR	Perfil.Company_Ident		= -1)
				AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
				AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
				AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
				AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

				AND (Loc.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)
			JOIN app620.CatRelLocationBiosCCMSVw LocBIOS
				ON	(LocBIOS.[location_bios]	= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)
				AND	(LocBIOS.[location_ccms]	= Loc.Location_Ident)
			LEFT JOIN [app620].[CatEmpleadosSolicitudes] CES ON CES.Empleado_Ident = Emp.Ident
			LEFT JOIN [app620].[CatConceptos] CC ON CC.ConceptoId = Perfil.ConceptoId
			ORDER BY CES.FolioSolicitud DESC
	
END
