USE [ASN3]
GO
/****** Object:  StoredProcedure [app620].[CatConceptosxEmpleadoxSolicitanteCMB]    Script Date: 16/10/2019 10:08:05 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatConceptosxEmpleadoxSolicitanteCMB]
(
	  @Ident				INT = -1
	 ,@Ident_Solicitante	INT = -1
)
AS

BEGIN
	SELECT
			@Ident			= ISNULL(@Ident, -1)

	SELECT 
		 DISTINCT CC.ConceptoId As Ident
		,CC.Descripcion As Valor

		--CC.ClienteId, Perfil.Client_Ident,
		--CC.ConceptoId, Perfil.ConceptoId,

		--'Empleado' Empleado, Emp.*, 'Perfil' Perfil, Perfil.*, 'LocBIOS' LocBIOS, LocBIOS.*, 'Perfil Accesos' PerfilAccesos, PEA.*
		--,'Conceptos' Conceptos, CC.*

	FROM	
		app620.CatEmployeeCCMSVw Emp
	JOIN 
		app620.CatPerfilEmpleados Perfil
	ON	
		(Emp.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)
	AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
	AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
	AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
	AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)
	AND Emp.Ident = @Ident

	JOIN [app620].[CatRelLocationBiosCCMSVw] LocBIOS
	ON
		LocBIOS.location_ccms = Emp.Location_Ident
	AND
		(LocBIOS.location_bios			= Perfil.City_Ident				OR	Perfil.City_Ident			= -1)

	AND
		Emp.Current_Status = 'Active'

	JOIN CatPerfilEmpleadosAccesos PEA							--Sección que conecta con los Perfiles asociados a permisos del solicitante
	ON	
		PEA.Perfil_Ident				= Perfil.Perfil_Ident
	AND
		PEA.EmpleadoId					= @Ident_Solicitante	-- Id Solicitante
	AND 
		Perfil.TipoAccesoId				= 1						--Tipo de acceso Solicitantes
	AND
		PEA.Active						= 1						-- Permiso activo para solicitante

	JOIN
		 app620.CatConceptos AS CC
	--ON
	--	(Emp.country_ident IN (SELECT Ident country_ident FROM fnSplit(CC.PaisId, ',')) OR CC.PaisId = -1)
	ON
		(CHARINDEX(CAST(Emp.country_ident as varchar(50)), CC.PaisId) > 0 OR CC.PaisId = '-1')
	AND (Emp.[Client_Ident] = CC.ClienteId OR CC.ClienteId = -1)

	AND (CC.ClienteId	= Perfil.Client_Ident	OR Perfil.Client_Ident	= -1	OR CC.ClienteId = -1)
	AND (CC.ConceptoId	= Perfil.ConceptoId		OR Perfil.ConceptoId	IS NULL	OR CC.ConceptoId = -1)

	AND CC.Active = 1
END

--SELECT * FROM CatPerfilEmpleados
--SELECT * FROM CatConceptos
