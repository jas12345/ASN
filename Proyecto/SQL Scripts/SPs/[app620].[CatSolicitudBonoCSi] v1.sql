USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudBonoCSi]    Script Date: 11/18/2020 2:59:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--EXEC [app620].[CatSolicitudBonoCSi]  -1 ,998539,'Bono C',155.54,746205,746205
ALTER PROCEDURE [app620].[CatSolicitudBonoCSi] 
	 @FolioSolicitud INT = NULL
	,@EmployeeId INT =-1
	,@ConceptoPS VARCHAR(12)
	,@ConceptoMonto DECIMAL(18,2) = NULL
	,@UserEmployeeId INT = NULL
	,@CCMSIdSolicitante INT =-1
	--,@FolioSolicitudOut INT = -1 OUTPUT
	--,@Estatus INT = 0 OUTPUT
	--,@MessageSalida varchar (max) =NULL OUTPUT
AS
BEGIN

	DECLARE @contractTypeSol nvarchar(200)
			,@contractTypeEmp nvarchar(200)
			,@existe int
			,@valContrato int
			,@valConcepto varchar(200)
			,@message nvarchar(200)
			,@messageExiste nvarchar(200)
			,@messageContrato nvarchar(200)
			,@messageConcepto nvarchar(200)
			,@FolioSolicitudOut INT = -1 
			,@Estatus INT = 0 
			,@result int = 0

			--SELECT @contractTypeSol=Contract_Type FROM [app620].[CatEmployeeCCMSVw] where Ident =@CCMSIdSolicitante
			--select @contractTypeEmp =Contract_Type FROM [app620].[CatEmployeeCCMSVw] where Ident =@EmployeeId
			--SELECT @existe=COUNT(Ident) FROM [app620].[CatEmployeeCCMSVw] WHERE Ident = @EmployeeId
			--select @valConcepto = (1) FROM [app620].[CatConceptos] where Descripcion =@ConceptoPS
			--SELECT count(Ident) FROM [app620].[CatEmployeeCCMSVw] WHERE Ident = 1078
			--SELECT (1) FROM [app620].[CatConceptos] where Descripcion ='Bono'

				SELECT	@EmployeeId	= ISNULL(@EmployeeId, -1)

	IF (@EmployeeId <> -1) 
		BEGIN
			IF EXISTS (
				SELECT DISTINCT Emp.Ident, pe.perfil_ident
				FROM [app620].[CatEmployeeCCMSVw] Emp
				JOIN app620.CatPerfilEmpleados PE
				ON (PE.Country_Ident = Emp.Country_Ident OR PE.Country_Ident = -1)
				AND  (PE.Location_Ident = Emp.Location_Ident OR PE.Location_Ident = -1)
				--AND  (PE.Client_Ident = Emp.Client_Ident OR PE.Client_Ident = -1)
				AND  (PE.Program_Ident = Emp.Program_Ident OR PE.Program_Ident = -1)
				--AND  (PE.Contract_Type_Ident = Emp.Contract_Type_Ident OR PE.Contract_Type_Ident = -1)
				AND PE.Active = 1

				AND Emp.Current_Status = 'Active'

				JOIN [app620].[CatRelLocationBiosCCMSVw] BiosCity 
				ON (BiosCity.location_bios = PE.City_Ident  OR PE.City_Ident = -1)
				AND (BiosCity.location_ccms = Emp.Location_Ident)

				--Adecuación de MultiCliente en RelPerfilEmpleadosClientes
				JOIN app620.RelPerfilEmpleadosClientes RECli
				ON	RECli.Perfil_Ident = PE.Perfil_Ident
				AND	RECli.Client_Ident = Emp.Client_Ident
					
				--Adecuación de MultiContrato en RelPerfilEmpleadosContratos
				JOIN app620.RelPerfilEmpleadosContratos RECon
					ON	RECon.Perfil_Ident = PE.Perfil_Ident
					AND	RECon.Contract_type_Ident = Emp.Contract_type_Ident or RECon.Contract_type_Ident = -1

				WHERE 
					PE.Perfil_Ident IN (
					SELECT Perfil_Ident 
					FROM app620.CatPerfilEmpleadosAccesos 
					WHERE (EmpleadoId = @CCMSIdSolicitante OR @CCMSIdSolicitante = -1)
					AND Active = 1
				)
				AND (emp.Ident = @EmployeeId OR @EmployeeId = -1)
			)
				BEGIN
					SELECT
						  @existe= Emp.Ident
						--, Emp.Nombre				
						--, Emp.Position_Code_Ident	
						--, Emp.Position_Code_Title	
						--, Emp.Contract_Type_Ident		
						--, Emp.Contract_Type	
						--, Emp.Location_Ident
						--, Emp.Location_Name
						--, Emp2.Ident IdentManager
						--, Emp2.Nombre NombreManager
					FROM
						app620.CatEmployeeCCMSVw AS Emp 
					LEFT JOIN
						app620.CatEmployeeCCMSVw AS Emp2
					ON 
						Emp2.Ident	= Emp.Manager_Ident
					WHERE
						Emp.Ident			= @EmployeeId

					AND Emp.Current_Status = 'Active'
					AND (Emp2.Current_Status = 'Active' or  Emp2.Current_Status = 'Leave of Absence') -- Se  le agrego el estatus 'Leave of Absence'

				END
			ELSE IF EXISTS (
				SELECT	 Emp.Ident
				FROM	app620.CatEmployeeCCMSVw AS Emp 
				WHERE	Emp.Ident = @EmployeeId

				AND Emp.Current_Status = 'Active'

			)
					BEGIN
						SELECT
							 @existe=   -1 
							--, NULL Nombre				
							--, NULL Position_Code_Ident	
							--, NULL Position_Code_Title	
							--, NULL Contract_Type_Ident		
							--, NULL Contract_Type	
							--, NULL Location_Ident
							--, NULL Location_Name
							--, NULL IdentManager
							--, NULL NombreManager					
					END
			ELSE 
				BEGIN
					SELECT
						  @existe=  -2 
						--, NULL Nombre				
						--, NULL Position_Code_Ident	
						--, NULL Position_Code_Title	
						--, NULL Contract_Type_Ident		
						--, NULL Contract_Type	
						--, NULL Location_Ident
						--, NULL Location_Name
						--, NULL IdentManager
						--, NULL NombreManager					
				END

		END


			IF (@existe <= 0)
			BEGIN 
				SET @messageExiste='No existe el empleado o No pertenece al contrato, ';
			END

			--IF(@existe > 0)
			--BEGIN
			--	SELECT @valContrato = COUNT(Ident) FROM [app620].[CatEmployeeCCMSVw] WHERE Ident = @EmployeeId AND Contract_Type=@contractTypeSol
			--END

			--IF (@valContrato <= 0)
			--BEGIN
			--	SET @messageContrato ='No pertenece al contrato, ';
			--END

			IF (@ConceptoPS <> 'Bono C')
			BEGIN
				SET @messageConcepto ='No pertenece al Concepto Bono C, ';
			END
		--IF EXISTS (SELECT (1) FROM [app620].[CatEmployeeCCMSVw] WHERE Ident = @EmployeeId AND Contract_Type=@contractTypeSol)
			IF (@existe > 0 AND @ConceptoPS ='Bono C')
				BEGIN
	
				DECLARE @idSolicitud INT =0
				DECLARE @FechaActual DATETIME
				DECLARE  @EstatusSolicitud VARCHAR(5) = 'EB'
						,@Autorizador1 INT = NULL
						,@Autorizador2 INT = NULL
						,@Autorizador3 INT = NULL
						,@Autorizador4 INT = NULL
						,@Autorizador5 INT = NULL
						,@Autorizador6 INT = NULL
						,@Autorizador7 INT = NULL
						,@Autorizador8 INT = NULL
						,@Autorizador9 INT = NULL
						,@ConceptoId INT = -1
						,@PeriodoNomina_Id INT = 0
						,@Active BIT = 1
	
				DECLARE
					 @CantidadTotal		INT = 0

				DECLARE @NivelesAutorizacionxEmpleadoxConcepto table(
					 Nivel	INT
					,Id		INT
					,Valor	VARCHAR(752)
				)

				SELECT @FechaActual = GETDATE();
				--SELECT @Estatus = ISNULL(@Estatus, 0);

				/*
				Estados para @Estatus, de esta manera de lado de la aplicacion recibe un estatus de la ejecución del SP
					 0 = Proceso sin error
					-2 = Ya existe un registro con este Empleado y Concepto.
				*/

				SELECT @FolioSolicitudOut	= @FolioSolicitud

				--SELECT @PeriodoNomina_Id = PeriodoNomina_Id
				--FROM app620.catperioodonomina
				--ORDER BY fechaCaptura

				SELECT TOP 1
					 @PeriodoNomina_Id = PeriodoNominaId
				FROM [app620].[CatPeriodosNomina]
				WHERE 
							FechaCaptura >= @FechaActual -- getdate()
				ORDER BY FechaCaptura ASC --DESC

				IF EXISTS	(
								SELECT 1
								FROM app620.CatSolicitudes
								WHERE					
									FolioSolicitud	= @FolioSolicitud
							)
					BEGIN
						SET @FolioSolicitudOut	= @FolioSolicitud

					END
				ELSE
					BEGIN
						DECLARE @inserted TABLE (
							[FolioSolicitud] [int]
						)

						INSERT INTO [app620].[CatSolicitudes]
						(
							 Fecha_Solicitud
							,Solicitante_Ident
							,PeriodoNominaId
							,EstatusSolicitudId
							,CreatedBy
							,CreatedDate
							,LastModifiedBy
							,LastModifiedDate
						)
						OUTPUT Inserted.FolioSolicitud INTO @inserted
						VALUES
						(
							 @FechaActual
							,@UserEmployeeId
							,@PeriodoNomina_Id
							,'EB'
							,@UserEmployeeId
							,@FechaActual
							,@UserEmployeeId
							,@FechaActual
						)
				
						SELECT TOP 1 @FolioSolicitudOut = FolioSolicitud FROM @inserted;
					END

				SELECT @Estatus = @FolioSolicitudOut

				SELECT	@ConceptoId = C.ConceptoId
				FROM	CatConceptos C
				JOIN	app620.CatConceptosPeopleSoft CCPS
					ON CCPS.ConceptoId = C.PeopleSoftId
				WHERE
					CCPS.Descripcion = @ConceptoPS
				AND		@ConceptoPS IN (
								'Bono C'
						)

				INSERT INTO @NivelesAutorizacionxEmpleadoxConcepto
				EXECUTE [app620].[NivelesAutorizacionxEmpleadoxConcepto] 
					 @EmpleadoIdent	= @EmployeeId
					,@ConceptoId	= @ConceptoId
					,@FolioId		= -1

				--SELECT	@ConceptoId --= ISNULL(@ConceptoId, 0)

				IF (@ConceptoId		<> -1)
				BEGIN
					IF NOT EXISTS(
								SELECT 1 FROM CatEmpleadosSolicitudes 
								WHERE
									FolioSolicitud	= @FolioSolicitud
								AND
									Empleado_Ident	= @EmployeeId
								AND
									ConceptoId		= @ConceptoId
								AND
									@ConceptoId		<> -1
					)

						BEGIN
							INSERT INTO CatEmpleadosSolicitudes
							(
								 FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,ParametroConceptoMonto
								,MotivosSolicitudId
								,Active
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate
							)
							VALUES
							(
								 @FolioSolicitudOut
								,@EmployeeId 
								,@ConceptoId
								,@ConceptoMonto
								,3					-- Motivo: N/A
								,@Active
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual
							)
						END

					INSERT INTO @NivelesAutorizacionxEmpleadoxConcepto
					EXECUTE [app620].[NivelesAutorizacionxEmpleadoxConcepto] 
						 @EmpleadoIdent	= @EmployeeId
						,@ConceptoId	= @ConceptoId
						,@FolioId		= -1

					SELECT	@Autorizador1	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 1

					SELECT	@Autorizador2	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 2

					SELECT	@Autorizador3	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 3

					SELECT	@Autorizador4	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 4

					SELECT	@Autorizador5	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 5

					SELECT	@Autorizador6	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 6

					SELECT	@Autorizador7	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 7

					SELECT	@Autorizador8	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 8

					SELECT	@Autorizador9	= Id
					FROM	@NivelesAutorizacionxEmpleadoxConcepto
					WHERE	Nivel = 9

					IF NOT EXISTS(
						SELECT 1 
						FROM [app620].CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 1
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,1
								,@Autorizador1
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)
						END

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 2
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,2
								,@Autorizador2
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)

						END

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 3
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,3
								,@Autorizador3
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)
						END

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 4
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,4
								,@Autorizador4
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)

						END

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 5
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,5
								,@Autorizador5
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)

						END

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 6
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,6
								,@Autorizador6
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)

						END

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 7
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,7
								,@Autorizador7
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)

						END

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 8
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,8
								,@Autorizador8
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)

						END

					IF NOT EXISTS(
						SELECT 1 
						FROM CatSolicitudEmpleadosAutorizantes
						WHERE
							FolioSolicitud		= @FolioSolicitudOut
						AND
							Empleado_Ident		= @EmployeeId
						AND
							ConceptoId			= @ConceptoId
						AND
							NivelAutorizacion	= 9
					)
						BEGIN
							INSERT INTO [app620].[CatSolicitudEmpleadosAutorizantes]
								(FolioSolicitud
								,Empleado_Ident
								,ConceptoId
								,NivelAutorizacion
								,Autorizador_Ident
								,CreatedBy
								,CreatedDate
								,LastModifiedBy
								,LastModifiedDate)
							VALUES
								(@FolioSolicitudOut
								,@EmployeeId
								,@ConceptoId
								,9
								,@Autorizador9
								,@UserEmployeeId
								,@FechaActual
								,@UserEmployeeId
								,@FechaActual)

						END
				END
			
					SET @message='Se agrego registro correctamente, ';	
					SET @result = 1;

		END
END
				SELECT CONCAT(@message,@messageExiste,@messageContrato,@messageConcepto)AS 'Mensaje',
					@result as 'Result',
					@Estatus as 'FolioSolicitud'

