USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatPerfilEmpleadosAccesosSi]    Script Date: 05/06/2019 11:30:47 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [app620].[CatPerfilEmpleadosAccesosSi]
	 @EmpleadoId	INT
	,@Perfil_Ident	INT
	,@Nivel			INT = NULL

	,@UserEmployeeId	INT
	,@Active			BIT
	,@Estatus			INT = 0 OUTPUT
AS
BEGIN
		
	DECLARE @FechaActual DATETIME
	DECLARE @Position_Code_Title VARCHAR(752) = NULL
	DECLARE @UPDATE INT
	DECLARE @TipoAccesoId INT = 0

	SET @FechaActual = GETDATE();
	
	-- Se inicializa @Estatus a cero si el valor de entrada es NULL
	SET @Estatus = ISNULL(@Estatus, 0)

	/*
	Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
	- 0 = Proceso sin error
	- -1 = Ya existe este registro de Acceso para este empleado y perfil
	- -2 = el empleado no existe en CCMS o no está activo
	- -3 = El puesto del empleado no es válido para este perfil
	- 

	*/
	
	IF EXISTS	(
					SELECT 1 
					FROM CatPerfilEmpleadosAccesos
					WHERE Perfil_Ident = @Perfil_Ident
					AND EmpleadoId = @EmpleadoId
					AND Active = 1
				)
		SET @Estatus = -1

	IF NOT EXISTS	(
					SELECT 1 
					FROM [app620].[CatEmployeeCCMSVw] Emp
					WHERE Ident = @EmpleadoId
					AND [Current_Status] = 'Active'
				)
		SET @Estatus = -2

	IF (@Estatus = 0)
		BEGIN

			SELECT @Position_Code_Title = Emp.Position_Code_Title
			FROM [app620].[CatEmployeeCCMSVw] Emp
			WHERE Ident = @EmpleadoId
			AND [Current_Status] = 'Active'

			--SELECT @Position_Code_Title Position_Code_Title

			IF NOT (
					(@Position_Code_Title  IS NOT NULL)
				AND
					(
						(	-- Filtro para Solicitantes
							@Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
						AND
							@TipoAccesoId	= 1
						)
						OR
						(	-- Filtro para Autorizantes
							@Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
						AND
							@TipoAccesoId	= 2
						)
						OR
						(	-- Filtro para Responsables
							@Position_Code_Title IN ('IMSS Coordinator', 'IMSS Manager', 'Payroll Coordinator', 'Payroll Manager', 'Payroll Specialist', 'Payroll Sr. Manager')
						AND	
							@TipoAccesoId	= 3
						)
						OR
						(	-- Filtro para Consultas
							@Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
						AND	
							@TipoAccesoId	= 4
						)
						OR
						(	-- Filtro para Otros
							@Position_Code_Title NOT IN ('Becario - Bilingual', 'Becario - Domestic', 'Agent - Bilingual', 'Agent - Domestic', 'Agent - Hispanic', 'Agent SME - Bilingual', 'Agent SME - Domestic', 'Agent SME - Hispanic')
						AND	
							@TipoAccesoId = -1
						)	
					)
				)		
				BEGIN
					SELECT @Estatus = -3
				END
		END

	IF (@Estatus = 0)
		BEGIN
			SELECT @UPDATE = 1 
			FROM CatPerfilEmpleadosAccesos
			WHERE Perfil_Ident = @Perfil_Ident
			AND @EmpleadoId = @EmpleadoId
			AND Active = 0

			IF (ISNULL(@UPDATE, 0) = 1 ) AND (@Estatus <> 0)

				BEGIN
					-- Se actualizan registros a estatus Activo cuando ya aparece en la BD
					UPDATE [app620].[CatPerfilEmpleadosAccesos]
					SET 
						Nivel						= @Nivel,
						LastModifiedBy				= @UserEmployeeId,
						LastModifiedDate			= @FechaActual,

						DeactivatedBy				= NULL,
						DeactivatedDate				= NULL,
						LastModifiedFromPCName		= HOST_NAME(),
						[Active]					= 1
					WHERE
						Perfil_Ident				= @Perfil_Ident
					--AND
					--	Active						= 1
					AND
						EmpleadoId					= @EmpleadoId
				END
			ELSE
				BEGIN
			-- Se insertan las claves que no existen en la tabla CatPerfilEmpleadosAccesos
					INSERT INTO [app620].[CatPerfilEmpleadosAccesos]
						(
							Perfil_Ident,
							EmpleadoId,
							Nivel,

							[CreatedBy],
							[CreatedDate],
							[LastModifiedBy]
						)
					SELECT
						@EmpleadoId,
						@Perfil_Ident,
						@Nivel,

						@UserEmployeeId, 
						@FechaActual,
						@UserEmployeeId 
				END
		END
END
