-- Datos de Solicitud
USE ASN2;
go
DECLARE @FolioSolicitud INT = 81

SELECT * FROM app620.CatSolicitudes WHERE FolioSolicitud = @FolioSolicitud
SELECT * FROM app620.CatEmpleadosSolicitudes WHERE FolioSolicitud = @FolioSolicitud

SELECT * FROM app620.CatSolicitudEmpleadosDetalle WHERE FolioSolicitud = @FolioSolicitud

SELECT * FROM app620.CatSolicitudEmpleadosAutorizantes --
WHERE FolioSolicitud = @FolioSolicitud
AND Autorizador_Ident IS NOT NULL