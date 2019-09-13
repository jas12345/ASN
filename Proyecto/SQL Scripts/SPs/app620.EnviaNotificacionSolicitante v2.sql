ALTER PROCEDURE app620.EnviaNotificacionSolicitante
@CCMSID INT
AS
	BEGIN
			Declare @val Varchar(MAX),
					@CorreoSolicitante VARCHAR(200),
					@NombreSolicitante VARCHAR(300); 

			SELECT @val = (
			select 
			  (select S.FolioSolicitud     as 'td' for xml path(''), type),
			  --(select E.First_Name + ' ' + E.Last_Name     as 'td' for xml path(''), type),
			  (select ES.Descripcion           as 'td' for xml path(''), type)			  
			FROM	app620.CatSolicitudes S WITH(NOLOCK)
					--INNER JOIN app620.CatSolicitudEmpleadosDetalle D WITH(NOLOCK) ON D.FolioSolicitud = S.FolioSolicitud
					--INNER JOIN [Mty1vacd-01].CCMS.dbo.TPNSR_CCMS_EmployeePlus E WITH(NOLOCK) ON E.Ident = S.[Solicitante_Ident]
					INNER JOIN app620.CatEstatusSolicitudes ES WITH(NOLOCK) ON ES.EstatusSolicitudId = S.EstatusSolicitudId					
			WHERE	Solicitante_Ident = @CCMSID
					AND S.EstatusSolicitudId IN ('EB','R')			
			for xml path('tr'))			

			SELECT	@NombreSolicitante = Nombre
					,@CorreoSolicitante = email1
			FROM	[app620].[CatEmployeeCCMSVw] WITH(NOLOCK)
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
									<span style="font-family:Calibri;">Buen d&iacute;a, ' + @NombreSolicitante + ' (' + @CorreoSolicitante + ')' 
									+ '<br/>Mediante el presente correo electr&oacute;nico le informamos que tiene pendiente de enviar la(s) siguiente(s) solicitud(es).<br/>Para su seguimiento, entrar a la aplicaci&oacute;n Nomina Manual en la parte de Mis Solicitudes</span>
									<br/>
									<br/>
									<br/>
									<div align="center">					
										<table id="customers">
											<tr>
												<th>Folio</th>
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
			
			SELECT @mensaje Body, 'alfredo.guerrero@teleperformance.com' CorreoSolicitante, 'Solicitudes Pendientes de Enviar' [Subject], 'alfredo.guerrero@teleperformance.com' CorreoCopia
			--SELECT @mensaje Body, @CorreoAutorizador CorreoAutorizador, 'Solicitudes Pendientes de Autorizar' [Subject]
		END

