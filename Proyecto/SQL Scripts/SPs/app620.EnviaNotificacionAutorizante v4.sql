USE [ASN_Ref]
GO
/****** Object:  StoredProcedure [app620].[EnviaNotificacionAutorizante]    Script Date: 14/07/2020 04:53:27 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [app620].[EnviaNotificacionAutorizante]
@CCMSID INT
AS
	BEGIN
			Declare @val Varchar(MAX),
					@CorreoAutorizador VARCHAR(200),
					@NombreAutorizador VARCHAR(300); 

			SELECT @val = (
			SELECT 
					(select SEA.FolioSolicitud	as 'td' for xml path(''), type),
					 
					(SELECT ESol.Nombre			as 'td' for xml path(''), type),

					(SELECT EAutAnt.Nombre		as 'td' for xml path(''), type),

					(select E.Nombre			as 'td' for xml path(''), type),
					(select ESO.Descripcion		as 'td' for xml path(''), type)

			FROM app620.CatSolicitudEmpleadosAutorizantes SEA
			INNER JOIN [app620].[CatEmployeeCCMSVw] E ON E.Ident = SEA.Empleado_Ident
			INNER JOIN app620.CatEmpleadosSolicitudes ES WITH(NOLOCK) 
				ON	ES.FolioSolicitud = SEA.FolioSolicitud 
				AND ES.Empleado_Ident = SEA.Empleado_Ident
				AND ES.ConceptoId     = SEA.ConceptoId
			INNER JOIN app620.CatEstatusSolicitudes ESO WITH(NOLOCK) ON ESO.EstatusSolicitudId = ES.EstatusSolicitudId
			INNER JOIN app620.CatSolicitudes S WITH(NOLOCK) ON S.FolioSolicitud = SEA.FolioSolicitud
			INNER JOIN app620.CatPeriodosNomina PN WITH(NOLOCK) ON PN.PeriodoNominaId = S.PeriodoNominaId
			LEFT JOIN app620.CatEmployeeCCMSVw ESol WITH(NOLOCK) ON ESol.Ident = S.Solicitante_Ident

			LEFT JOIN app620.CatSolicitudEmpleadosAutorizantes SEAAnt 
					ON SEAAnt.FolioSolicitud = SEA.FolioSolicitud 
				AND SEAAnt.Empleado_Ident = SEA.Empleado_Ident 
				AND SEAAnt.ConceptoId = SEA.ConceptoId 
				AND (
						(SEAAnt.NivelAutorizacion = (SEA.NivelAutorizacion -1) AND SEA.NivelAutorizacion > 1 AND SEA.Pendiente = 1)
					OR
						(SEAAnt.NivelAutorizacion = SEA.NivelAutorizacion AND SEA.NivelAutorizacion = 1 AND SEA.Pendiente = 1)
					)
			LEFT JOIN app620.CatEmployeeCCMSVw EAutAnt ON EAutAnt.Ident = SEAAnt.Autorizador_Ident

			WHERE	SEA.Pendiente = 1
					AND SEA.Autorizador_Ident = @CCMSID
					AND S.EstatusSolicitudId IN ('PA', 'R')
					AND ES.EstatusSolicitudId IN ('PA')
					AND PN.FechaCierre > GETDATE()
			GROUP BY 
					SEA.FolioSolicitud, 
					E.Nombre, 
					ESol.Nombre,
					EAutAnt.Nombre,
					ESO.Descripcion
			for xml path('tr'))


			SELECT	@NombreAutorizador = Nombre					
					,@CorreoAutorizador = email1
			FROM	app620.CatEmployeeCCMSVw WITH(NOLOCK)
			WHERE	Ident = @CCMSID
		
		

			DECLARE @mensaje NVARCHAR(MAX)
			
			SET @mensaje = '<!DOCTYPE html>
							<html>
								<head>
									<style type="text/css">
										#customers {
											font-family: Verdana, Arial, Helvetica, sans-serif;
											font-size: 8pt;
											color: #333333;
											background-color: #f2f2f2;    
											margin: 5px 0 10px 0;  
											border: 1px solid #333333; 
											border-collapse: collapse;								
										}

										#customers td, #customers th {
											border: 1px solid #ddd;
											padding: 8px;
											text-align: center;
										}

										#customers tr:nth-child(even){background-color: #f2f2f2;}

										#customers tr:hover {background-color: #ddd;}

										#customers th {
											padding-top: 2px;
											padding-bottom: 2px;
											background-color: #0072B1;
											color: white;
										}
									</style>
								</head>
								<body bgcolor="#3f3f3f" text="#919191" alink="#cccccc" vlink="#cccccc" style="margin: 0;padding: 0;background-color: #ffffff;color: #919191;">								
									<span style="font-family:Calibri;">Buen d&iacute;a, ' + @NombreAutorizador + ' (' + @CorreoAutorizador + ')' 
									+ '<br/>Mediante el presente correo electr&oacute;nico le informamos que tiene pendiente de autorizar la(s) siguiente(s) solicitud(es).<br/>Para su seguimiento, entrar a la aplicaci&oacute;n Nomina Manual en la parte de Mis Autorizaciones<br/> https://payrollrequest.tpnsr.com </span>





									<br/>
									<br/>
									<br/>
									<div align="center">					
										<table id="customers">
											<tr>
												<th>Folio</th>
												<th>Solicitante</th>
												<th>Autorizador Anterior</th>
												<th>Nombre</th>
												<th>Estatus</th>												
											</tr>' + 
											 @val +
										'</table>
									</div>						
								</body>
							</html>'
							
			--EXEC msdb.dbo.sp_send_dbmail 
			--	@profile_name= 'mtysqldev01'
			--	,@recipients='jdelossantosr@outlook.com' --'alfredo.guerrero@teleperformance.com'
			--	--,@copy_recipients=@CC
			--	--,@blind_copy_recipients=@BCC
			--	,@subject='Notificación de Nómina Manual'
			--	--,@file_attachments =@File_destination
			--	,@body= @mensaje
			--	,@body_format='HTML'
			
			IF @mensaje IS NOT NULL
				BEGIN			
					--SELECT @mensaje Body, 'alfredo.guerrero@teleperformance.com' CorreoAutorizador, 'Solicitudes Pendientes de Autorizar' [Subject], 'alfredo.guerrero@teleperformance.com' CorreoCopia
					SELECT @mensaje Body, @CorreoAutorizador CorreoAutorizador, 'Solicitudes Pendientes de Autorizar' [Subject], 'alfredo.guerrero@teleperformance.com' CorreoCopia
				END
		END



