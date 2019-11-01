-- Datos de Solicitud
USE ASN3;
go
DECLARE @FolioSolicitud INT = 180

SELECT * FROM app620.CatSolicitudes WHERE FolioSolicitud = @FolioSolicitud
SELECT * FROM app620.CatEmpleadosSolicitudes WHERE FolioSolicitud = @FolioSolicitud

SELECT * FROM app620.CatSolicitudEmpleadosDetalle WHERE FolioSolicitud = @FolioSolicitud

SELECT * FROM app620.CatSolicitudEmpleadosAutorizantes --
WHERE FolioSolicitud = @FolioSolicitud
AND Autorizador_Ident IS NOT NULL

--UPDATE app620.CatSolicitudEmpleadosAutorizantes --
--SET Pendiente = 1, Autorizado = 0, Rechazado = 0
--WHERE FolioSolicitud = 178
--AND Empleado_Ident = 1000256
--AND ConceptoId = 21
--AND NivelAutorizacion = 1

--UPDATE app620.CatEmpleadosSolicitudes
--SET EstatusSolicitudId = 'R'
--WHERE FolioSolicitud = 180
--AND Empleado_Ident = 993780
--AND ConceptoId = 46

--UPDATE app620.CatSolicitudes
--SET EstatusSolicitudId = 'R'
--WHERE FolioSolicitud = 180

--INSERT INTO app620.CatSolicitudEmpleadosAutorizantes
--SELECT 
--	 FolioSolicitud 
--	,3380259 
--	,2  
--	,NivelAutorizacion 
--	,Autorizador_Ident 
--	,Obligatorio 
--	,MontoAutorizacionAutomatica             
--	,Pendiente 
--	,Autorizado 
--	,Rechazado 
--	,Cancelado 
--	,MotivoRechazo                                                                                                                                                                                                                                                    
--	,Active 
--	,CreatedBy   
--	,CreatedDate             
--	,DeactivatedBy 
--	,DeactivatedDate         
--	,LastModifiedBy 
--	,LastModifiedDate        
--	,LastModifiedFromPCName
--FROM app620.CatSolicitudEmpleadosAutorizantes
--WHERE FolioSolicitud = 35
--AND Empleado_Ident = 3380261
--AND ConceptoId = 19

--UPDATE app620.CatSolicitudEmpleadosAutorizantes
--SET Pendiente = 1
--WHERE FolioSolicitud = 35
--AND NivelAutorizacion = 1

--UPDATE app620.CatSolicitudEmpleadosAutorizantes
--SET Pendiente = 0, Rechazado = 1
--WHERE FolioSolicitud = 35
--AND ConceptoId = 19
--AND NivelAutorizacion = 1