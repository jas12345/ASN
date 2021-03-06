USE [ASN]
GO
/****** Object:  StoredProcedure [app620].[CatSolicitudesSu]    Script Date: 14/06/2019 11:33:36 a. m. ******/
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

	IF @Estatus=0
		BEGIN
			UPDATE [app620].[CatSolicitudes]
				SET
					Solicitante_Ident = @Solicitante_Ident
				  ,LastModifiedDate = GETDATE()
				  ,LastModifiedBy=@UserEmployeeId
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
				JOIN [app620].[CatPeriodosNomina] CPN on CPN.PeriodoNominaId = CS.PeriodoNominaId
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
