ALTER PROCEDURE app620.EnviaNotificacionAutorizante
@CCMSID INT
AS
	BEGIN
			Declare @val Varchar(MAX),
					@CorreoAutorizador VARCHAR(200),
					@NombreAutorizador VARCHAR(300); 

			SELECT @val = (
			select 
			  (select SEA.FolioSolicitud     as 'td' for xml path(''), type),
			  (select E.First_Name + ' ' + E.Last_Name     as 'td' for xml path(''), type),
			  (select ESO.Descripcion           as 'td' for xml path(''), type)
			FROM	app620.CatSolicitudEmpleadosAutorizantes SEA WITH(NOLOCK)
					INNER JOIN [Mty1vacd-01].CCMS.dbo.TPNSR_CCMS_EmployeePlus E WITH(NOLOCK) ON E.Ident = SEA.[Empleado_Ident]
					INNER JOIN app620.CatConceptos C WITH(NOLOCK) ON C.ConceptoId = SEA.ConceptoId
					INNER JOIN app620.CatSolicitudes S WITH(NOLOCK) ON S.FolioSolicitud = SEA.FolioSolicitud
					INNER JOIN app620.CatParametroConceptos P WITH(NOLOCK) ON P.ParametroConceptoId = C.ParametroConceptoId
					INNER JOIN app620.CatEmpleadosSolicitudes ES WITH(NOLOCK) ON ES.FolioSolicitud = S.FolioSolicitud
					INNER JOIN app620.CatMotivosSolicitud M WITH(NOLOCK) ON M.MotivosSolicitudId = ES.MotivosSolicitudId
					INNER JOIN app620.CatEstatusSolicitudes ESO WITH(NOLOCK) ON ESO.EstatusSolicitudId = S.EstatusSolicitudId
					INNER JOIN [Mty1vacd-01].CCMS.dbo.TPNSR_CCMS_EmployeePlus A WITH(NOLOCK) ON A.Ident = SEA.Autorizador_Ident
			WHERE	SEA.Pendiente = 1
					AND SEA.Autorizador_Ident = @CCMSID
			GROUP BY SEA.FolioSolicitud, 
					--SEA.Empleado_Ident, 
					E.First_Name + ' ' + E.Last_Name, 
					--SEA.ConceptoId, 
					--C.Descripcion, 
					--M.Descripcion, 
					ESO.Descripcion --, 
					--SEA.Autorizador_Ident,
					--A.First_Name + ' ' + A.Last_Name
					--,A.email1
			for xml path('tr'))


			SELECT	@NombreAutorizador = 
					CASE WHEN Middle_Name IS NULL OR LEN(Middle_Name) = 0 THEN First_Name + ' ' + Last_Name ELSE First_Name + ' ' + isnull(Middle_Name, '') + ' ' + Last_Name END
					,@CorreoAutorizador = email1
			FROM	[Mty1vacd-01].CCMS.dbo.TPNSR_CCMS_EmployeePlus WITH(NOLOCK)
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
									+ '<br/>Mediante el presente correo electr&oacute;nico le informamos que tiene pendiente de autorizar la(s) siguiente(s) solicitud(es).<br/>Para su seguimiento, entrar a la aplicaci&oacute;n Nomina Manual en la parte de Mis Autorizaciones</span>
									<br/>
									<br/>
									<br/>
									<div align="center">					
										<table id="customers">
											<tr>
												<th>Folio</th>
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
			
			SELECT @mensaje Body, 'alfredo.guerrero@teleperformance.com' CorreoAutorizador, 'Solicitudes Pendientes de Autorizar' [Subject]
			--SELECT @mensaje Body, @CorreoAutorizador CorreoAutorizador, 'Solicitudes Pendientes de Autorizar' [Subject]
		END