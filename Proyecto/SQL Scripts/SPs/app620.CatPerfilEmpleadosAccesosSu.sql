USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosAccesosSu]    Script Date: 05/06/2019 10:17:42 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[CatPerfilEmpleadosAccesosSu]
	 @Perfil_Ident INT
	,@EmpleadoId INT
	,@Nivel		INT = NULL

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
	- -1 = No existe registro con la clave de Perfil/Empleado
	*/
	
	SET @FechaActual = GETDATE();

	IF EXISTS		(
						SELECT 1 
						FROM [app620].[CatPerfilEmpleadosAccesos] 
						WHERE [Perfil_Ident] = @Perfil_Ident
					)
		BEGIN
			UPDATE [app620].[CatPerfilEmpleadosAccesos]
			SET 
				 [Active]					= @Active
				,LastModifiedBy				= @UserEmployeeId
				,LastModifiedDate			= @FechaActual
				,Nivel						= @Nivel

				,DeactivatedBy				= IIF(@Active=1,NULL,@UserEmployeeId)
				,DeactivatedDate			= IIF(@Active=1,NULL,@FechaActual)
				,LastModifiedFromPCName		= HOST_NAME()
			WHERE
				Perfil_Ident				= @Perfil_Ident
			AND
				EmpleadoId					= @EmpleadoId
		END
	ELSE
		SET @Estatus = -1
END
