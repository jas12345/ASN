USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSu]    Script Date: 12/06/2019 02:53:48 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*************************************************************/
/* Autor: Michell Cuni										 */
/* Función: Actualizar la solicitud y cambiar su estatus	 */
/*															 */
/* NOTA: Cuando se le pasa el valor 1 al parametro @Estatus=1*/
/*  quiere decir que se cambie el estatus de la solicitud	 */
/*  "A Enviado".											 */
/*************************************************************/

ALTER PROC [app620].[CatSolicitudesSu]
	 @FolioSolicitud INT
    ,@Fecha_Solicitud DATETIME = NULL
    ,@Perfil_Ident INT
    ,@Solicitante_Ident INT = NULL
    ,@Solicintante_Nombre VARCHAR(100) = NULL
    ,@Puesto_solicitante_Ident INT = NULL
	,@PeriodoNomina_Id VARCHAR(50) =''
	,@PeriodoNominaOriginal_Id VARCHAR(50) =''  
    ,@ConceptoId INT = NULL
    ,@MotivoId INT = NULL
    ,@Justficacion VARCHAR(1024) = NULL
    ,@Responsable_Id INT = NULL
    ,@Detalle INT = NULL
    ,@Autorizantes VARCHAR(100) = NULL
	,@Estatus INT = 0 OUTPUT
	,@UserEmployeeId INT
AS
BEGIN
	
	DECLARE
		 @FechaActual DATETIME

	SET @FechaActual = GETDATE();
	SET @Estatus	 = ISNULL(@Estatus, 0)


	--IF EXISTS	(
	--					SELECT 1
	--					FROM app620.CatSolicitudes
	--					WHERE					
	--						Perfil_Ident	= @Perfil_Ident
	--					)
	--					SET @Estatus = @Estatus -1

	--IF EXISTS	(
	--					SELECT 1
	--					FROM [app620].[CatSolicitudes] 
	--					WHERE
	--						FolioSolicitud		= @FolioSolicitud						
	--					AND	Fecha_Solicitud		= @Fecha_Solicitud						
	--					AND	Perfil_Ident	= @Perfil_Ident
	--					)
	--					SET @Estatus = @Estatus -2

	IF @Estatus=0
		BEGIN
			UPDATE [app620].[CatSolicitudes]
				SET
					Solicitante_Ident = @Solicitante_Ident
				  ,Puesto_solicitante_Ident = @Puesto_solicitante_Ident
				  ,ConceptoId = @ConceptoId
				  ,MotivoId = @MotivoId
				  ,Justficacion = @Justficacion
				  ,Responsable_Id = @Responsable_Id
				  ,Detalle = @Detalle
				  ,LastModifiedDate = GETDATE()
				  ,LastModifiedBy=@UserEmployeeId
				  ,Autorizantes = @Autorizantes
				WHERE 
					FolioSolicitud = @FolioSolicitud
				--AND Perfil_Ident = @Perfil_Ident				  				  
		END
	ELSE
		IF @Estatus =1
			BEGIN

				--Validar que no sea mayor a la fecha maxima del periodo de la solicitud.
				DECLARE @FechaPeriodo datetime

				SELECT @FechaPeriodo = CPN.FechaCierre  FROM [app620].[CatSolicitudes] CS
				JOIN [app620].[CatPeriodosNomina] CPN on CPN.AnioId = CS.PeriodoNominaAnio_Id
													AND CPN.MesId = CS.PeriodoNominaMes_Id
													AND CPN.ConsecutivoId = CS.PeriodoNominaConsecutivoid
													AND CPN.PeriodicidadNominaId = CS.PeriodoNominaPeriodicidadNomina_Id
													AND CPN.TipoPeriodo = CS.PeriodoNominaTipoPeriodo_Id
				WHERE CS.FolioSolicitud = @FolioSolicitud

				IF @FechaPeriodo <= GETDATE()
					BEGIN
						UPDATE [app620].[CatSolicitudes]
							SET
							EstatusSolicitudId = 'E',
							LastModifiedDate = GETDATE(),
							LastModifiedBy=@UserEmployeeId
						WHERE 
							FolioSolicitud = @FolioSolicitud
					END
				ELSE
					BEGIN
						SET @Estatus = -2
					END
			END
END
