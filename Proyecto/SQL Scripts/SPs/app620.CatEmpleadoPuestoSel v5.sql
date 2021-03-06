USE [ASN2]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadoPuestoSel]    Script Date: 01/10/2019 04:11:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[CatEmpleadoPuestoSel]
(
	   @Ident				INT = -1
	  ,@Solicitante_Ident	INT = -1
)
AS

BEGIN

	SELECT
		@Ident			= ISNULL(@Ident, -1)

	IF (@Ident <> -1) 
		BEGIN
			IF EXISTS(
				SELECT DISTINCT Emp.Ident
				FROM [app620].[CatEmployeeCCMSVw] Emp
				JOIN CatPerfilEmpleados PE
				ON (PE.Country_Ident = Emp.Country_Ident OR PE.Country_Ident = -1)
				AND  (PE.Location_Ident = Emp.Location_Ident OR PE.Location_Ident = -1)
				AND  (PE.Client_Ident = Emp.Client_Ident OR PE.Client_Ident = -1)
				AND  (PE.Program_Ident = Emp.Program_Ident OR PE.Program_Ident = -1)
				AND  (PE.Contract_Type_Ident = Emp.Contract_Type_Ident OR PE.Contract_Type_Ident = -1)
				AND PE.Active = 1

				AND Emp.Current_Status = 'Active'

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
				AND (emp.Ident = @Ident OR @Ident = -1)
			)
				BEGIN
					SELECT
						  Emp.Ident
						, Emp.Nombre				
						, Emp.Position_Code_Ident	
						, Emp.Position_Code_Title	
						, Emp.Contract_Type_Ident		
						, Emp.Contract_Type	
						, Emp.Location_Ident
						, Emp.Location_Name
						, Emp2.Ident IdentManager
						, Emp2.Nombre NombreManager
					FROM
						app620.CatEmployeeCCMSVw AS Emp 
					LEFT JOIN
						app620.CatEmployeeCCMSVw AS Emp2
					ON 
						Emp2.Ident	= Emp.Manager_Ident
					WHERE
						Emp.Ident			= @Ident

					AND Emp.Current_Status = 'Active'
					AND Emp2.Current_Status = 'Active'

				END
			ELSE IF EXISTS (
				SELECT	Emp.Ident
				FROM	app620.CatEmployeeCCMSVw AS Emp 
				WHERE	Emp.Ident = @Ident

				AND Emp.Current_Status = 'Active'

			)
					BEGIN
						SELECT
							  -1 Ident
							, NULL Nombre				
							, NULL Position_Code_Ident	
							, NULL Position_Code_Title	
							, NULL Contract_Type_Ident		
							, NULL Contract_Type	
							, NULL Location_Ident
							, NULL Location_Name
							, NULL IdentManager
							, NULL NombreManager					
					END
			ELSE 
				BEGIN
					SELECT
						  -2 Ident
						, NULL Nombre				
						, NULL Position_Code_Ident	
						, NULL Position_Code_Title	
						, NULL Contract_Type_Ident		
						, NULL Contract_Type	
						, NULL Location_Ident
						, NULL Location_Name
						, NULL IdentManager
						, NULL NombreManager					
				END

		END
END
