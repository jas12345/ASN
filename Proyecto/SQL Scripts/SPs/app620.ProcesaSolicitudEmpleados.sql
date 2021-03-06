USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[ProcesaSolicitudEmpleados]    Script Date: 23/05/2019 07:59:20 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [app620].[ProcesaSolicitudEmpleados]
@SolicitudId INT
,@Empleado_Ident INT 
,@Autorizantes VARCHAR(100) = NULL
,@UserEmployeeId INT
,@ListaEmpleados VARCHAR(MAX)
,@ParametroConceptoMonto DECIMAL(18,2)
,@Detalle VARCHAR(250)
--,@Tabla AS dbo.EmpleadosSolicitud READONLY  
,@Estatus Varchar(Max) = '' OUTPUT
AS
SET XACT_ABORT ON;
SET NOCOUNT ON;
BEGIN TRY
	BEGIN TRAN
	
IF @ListaEmpleados = ''
BEGIN

	DECLARE @Perfil INT

	SELECT @Perfil= Perfil_Ident FROM [app620].[CatSolicitudes] WHERE FolioSolicitud = @SolicitudId
	
	IF EXISTS( SELECT 1 FROM [app620].CatSolicitudEmpleadosDetalle WHERE FolioSolicitud=@SolicitudId AND Empleado_Ident=@Empleado_Ident)
	SET @Estatus = '-1_Existe un empleado con el mismo CCMID en la solicitud'

	IF NOT EXISTS(SELECT 1 FROM
			app620.CatEmployeeCCMSVw AS Emp 
			JOIN app620.CatLocationVw AS Loc 
				ON Emp.Location_Ident = Loc.Location_Ident 
			JOIN app620.CatPerfilEmpleados Perfil
				ON	(Perfil.Perfil_Ident		= @Perfil					OR	@Perfil				= -1)
				--AND	(Emp.Company_Ident			= Perfil.Company_Ident			OR	Perfil.Company_Ident		= -1)
				AND (Emp.Location_Ident			= Perfil.Location_Ident			OR	Perfil.Location_Ident		= -1)
				AND (Emp.Client_Ident			= Perfil.Client_Ident			OR	Perfil.Client_Ident			= -1)
				AND (Emp.Program_Ident			= Perfil.Program_Ident			OR	Perfil.Program_Ident		= -1)
				AND (Emp.Contract_Type_Ident	= Perfil.Contract_Type_Ident	OR	Perfil.Contract_Type_Ident	= -1)

				AND (Loc.country_ident			= Perfil.Country_Ident			OR	Perfil.Country_Ident		= -1)
				WHERE Emp.Ident = @Empleado_Ident)
	  SET @Estatus = '-2_No pertenece al perfil de la solicitud'

	
	IF @Estatus =''
	BEGIN
		--Cuando se requiere realizar solo una inserción
		INSERT INTO [app620].[CatEmpleadosSolicitudes] (
							   [FolioSolicitud]
							  ,[Empleado_Ident]
							  ,[Empleado_First_Name]
							  ,[Empleado_Middle_Name]
							  ,[Empleado_Last_Name]
							  ,[Empleado_Position_Code_Ident]
							  ,[Empleado_Position_Code_Title]
							  ,[Empleado_Contract_Type_Ident]
							  ,[Empleado_Contract_Type]
							  ,[Manager_Ident]
							  ,[Manager_First_Name]
							  ,[Manager_Middle_Name]
							  ,[Manager_Last_Name]
							  ,[Manager_Position_Code_Ident]
							  ,[Manager_Position_Code_Title]
							  ,[Manager_Contract_Type_Ident]
							  ,[Manager_Contract_Type]
							  ,ParametroConceptoMonto
							  ,Detalle
							  ,[Active])
				SELECT 
				@SolicitudId as FolioSolicitud
				,CE.Ident
				,CE.[First_Name]
				,CE.[Middle_Name]
				,CE.[Last_Name]
				,CE.[Position_Code_Ident]
				,CE.Position_Code_Title
				,CE.Contract_Type_Ident
				,CE.Contract_Type
				,CE.[Manager_Ident]
				,CE.[Manager_First_Name]
				,CE.[Manager_Middle_Name]
				,CE.[Manager_Last_Name]
				,MAN.[Position_Code_Ident] AS [Manager_Position_Code_Ident]
				,MAN.Position_Code_Title AS [Manager_Position_Code_Title]
				,MAN.Contract_Type_Ident AS [Manager_Contract_Type_Ident]
				,MAN.Contract_Type AS [Manager_Contract_Type]
				,@ParametroConceptoMonto AS ParametroConceptoMonto
				,@Detalle AS Detalle
				, 1 AS [Active]
				FROM [app620].[CatEmployeeCCMSVw] CE
				JOIN [app620].[CatEmployeeCCMSVw] MAN ON CE.Manager_Ident = MAN.Ident
				WHERE CE.Ident = @Empleado_Ident
	END
END
ELSE
BEGIN
	
	DECLARE @TempTable1 TABLE (Id INT IDENTITY(1, 1),idEmp VARCHAR(100), estatus int default null)

	INSERT INTO @TempTable1(idEmp)
	SELECT item FROM dbo.fnSplit(@ListaEmpleados,',')
		
	DECLARE @TotalRegistros Int = (Select count(*) from @TempTable1)-- #TempEmpleadosSolicitud)		
	DECLARE @indiceBase int=1;

	UPDATE [app620].[CatEmpleadosSolicitudes] SET Active =0 WHERE FolioSolicitud = @SolicitudId

-- Se recorre la tabla de empleados y se valida por medio de la columna estatus la acción a realizar
--Por medio de un Swith se encapsulara las acciones de crear o actualizar.
	WHILE 	@indiceBase <= @TotalRegistros
	BEGIN
	
		Declare @EmpleadoId Int= 0
		Declare @EstatusRegistro INT= NULL

		SELECT @EmpleadoId=idEmp, @EstatusRegistro=estatus FROM @TempTable1 WHERE Id=@indiceBase
			
		--Si estatus es 1 = Crear
		--Si Estatus es 2 = Actualizar y dar de baja
		--Si Estatus es 3 = Actualizar y reactivar
		 
		IF NOT EXISTS(SELECT * FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud = @SolicitudId AND Empleado_Ident = @EmpleadoId)--(@EstatusRegistro IS NULL )
		BEGIN
			INSERT INTO [app620].[CatEmpleadosSolicitudes] (
							   [FolioSolicitud]
							  ,[Empleado_Ident]
							  ,[Empleado_First_Name]
							  ,[Empleado_Middle_Name]
							  ,[Empleado_Last_Name]
							  ,[Empleado_Position_Code_Ident]
							  ,[Empleado_Position_Code_Title]
							  ,[Empleado_Contract_Type_Ident]
							  ,[Empleado_Contract_Type]
							  ,[Manager_Ident]
							  ,[Manager_First_Name]
							  ,[Manager_Middle_Name]
							  ,[Manager_Last_Name]
							  ,[Manager_Position_Code_Ident]
							  ,[Manager_Position_Code_Title]
							  ,[Manager_Contract_Type_Ident]
							  ,[Manager_Contract_Type]
							  ,[Active])
				SELECT 
				@SolicitudId as FolioSolicitud
				,CE.Ident
				,CE.[First_Name]
				,CE.[Middle_Name]
				,CE.[Last_Name]
				,CE.[Position_Code_Ident]
				,CE.Position_Code_Title
				,CE.Contract_Type_Ident
				,CE.Contract_Type
				,CE.[Manager_Ident]
				,CE.[Manager_First_Name]
				,CE.[Manager_Middle_Name]
				,CE.[Manager_Last_Name]
				,MAN.[Position_Code_Ident] AS [Manager_Position_Code_Ident]
				,MAN.Position_Code_Title AS [Manager_Position_Code_Title]
				,MAN.Contract_Type_Ident AS [Manager_Contract_Type_Ident]
				,MAN.Contract_Type AS [Manager_Contract_Type]
				, 1 AS [Active]
				FROM [app620].[CatEmployeeCCMSVw] CE
				JOIN [app620].[CatEmployeeCCMSVw] MAN ON CE.Manager_Ident = MAN.Ident
				WHERE CE.Ident = @EmpleadoId	
		END
		ELSE --IF @EstatusRegistro=2 
			BEGIN 
				Update [app620].[CatEmpleadosSolicitudes] SET Active=1 WHERE [FolioSolicitud]= @SolicitudId AND [Empleado_Ident] =@EmpleadoId
			END
		--ELSE IF @EstatusRegistro=3
		--	BEGIN
		--		Update [app620].[CatEmpleadosSolicitudes] SET Active=0 WHERE [FolioSolicitud]= @SolicitudId AND [Empleado_Ident] =@EmpleadoId
		--	END

			SET @indiceBase= @indiceBase+1
	END
END
	COMMIT TRAN;
END TRY
BEGIN CATCH  -- Modulo de manejo de errores
	
    DECLARE @Error_Number INT ,
        @Error_Severity INT ,
        @Error_State INT ,
        @Error_Procedure VARCHAR(1000) ,
        @Error_Line INT ,
        @Error_Message VARCHAR(8000);
    SELECT  @Error_Number = ERROR_NUMBER() ,
            @Error_Severity = ERROR_SEVERITY() ,
            @Error_State = ERROR_STATE() ,
            @Error_Procedure = ERROR_PROCEDURE() ,
            @Error_Line = ERROR_LINE() ,
            @Error_Message = ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
	
	RAISERROR(@Error_Message,@Error_Severity, @Error_State);	
END CATCH;