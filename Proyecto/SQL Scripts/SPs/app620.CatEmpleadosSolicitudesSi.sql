USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatEmpleadosSolicitudesSi]    Script Date: 12/06/2019 04:59:42 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [app620].[CatEmpleadosSolicitudesSi]
@FolioSolicitud INT
      ,@Empleado_Ident INT
      ,@Empleado_First_Name VARCHAR(250)
      ,@Empleado_Middle_Name VARCHAR(250)
      ,@Empleado_Last_Name VARCHAR(250)
      ,@Empleado_Position_Code_Ident INT
      ,@Empleado_Position_Code_Title VARCHAR(150)
      ,@Empleado_Contract_Type_Ident INT
      ,@Empleado_Contract_Type VARCHAR(50)
      ,@Manager_Ident INT
      ,@Manager_First_Name VARCHAR(250)
      ,@Manager_Middle_Name VARCHAR(250)
      ,@Manager_Last_Name VARCHAR(250)
      ,@Manager_Position_Code_Ident INT
      ,@Manager_Position_Code_Title VARCHAR(150)
      ,@Manager_Contract_Type_Ident INT
      ,@Manager_Contract_Type VARCHAR(250)
	  ,@ParametroConceptoMonto DECIMAL(18,2)
	  ,@Detalle VARCHAR(250)
	  ,@UserEmployeeId INT
	  ,@Estatus INT = 0 OUTPUT
AS
BEGIN
	DECLARE @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	SET @Estatus = ISNULL(@Estatus, 0)

	IF EXISTS( SELECT 1 FROM [app620].[CatEmpleadosSolicitudes] WHERE FolioSolicitud=@FolioSolicitud AND Empleado_Ident=@Empleado_Ident)
	SET @Estatus = @Estatus -1

	IF @Estatus=0
	BEGIN
		INSERT INTO [app620].[CatEmpleadosSolicitudes]
		(
			FolioSolicitud
			  ,Empleado_Ident
			  ,Empleado_First_Name
			  ,Empleado_Middle_Name
			  ,Empleado_Last_Name
			  ,Empleado_Position_Code_Ident
			  ,Empleado_Position_Code_Title
			  ,Empleado_Contract_Type_Ident
			  ,Empleado_Contract_Type
			  ,Manager_Ident
			  ,Manager_First_Name
			  ,Manager_Middle_Name
			  ,Manager_Last_Name
			  ,Manager_Position_Code_Ident
			  ,Manager_Position_Code_Title
			  ,Manager_Contract_Type_Ident
			  ,Manager_Contract_Type
			  ,ParametroConceptoMonto
			  ,Detalle
			  ,Active
			  ,CreatedBy
			  ,LastModifiedBy
		)
		VALUES
		( 
			   @FolioSolicitud
			  ,@Empleado_Ident
			  ,@Empleado_First_Name
			  ,@Empleado_Middle_Name
			  ,@Empleado_Last_Name
			  ,@Empleado_Position_Code_Ident
			  ,@Empleado_Position_Code_Title
			  ,@Empleado_Contract_Type_Ident
			  ,@Empleado_Contract_Type
			  ,@Manager_Ident
			  ,@Manager_First_Name
			  ,@Manager_Middle_Name
			  ,@Manager_Last_Name
			  ,@Manager_Position_Code_Ident
			  ,@Manager_Position_Code_Title
			  ,@Manager_Contract_Type_Ident
			  ,@Manager_Contract_Type
			  ,@ParametroConceptoMonto
			  ,@Detalle
			  ,1
			  ,@UserEmployeeId
			  ,@UserEmployeeId
		)
	END
END
