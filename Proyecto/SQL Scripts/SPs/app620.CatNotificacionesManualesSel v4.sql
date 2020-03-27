ALTER PROC [app620].[CatNotificacionesManualesSel]
@ResponsableCCMSID int = 0
AS
BEGIN
DECLARE @PeriodoNoimaId int = 0
DECLARE @TablaPerfilesResponsable TABLE (PerfilID int primary key,EID int)
DECLARE @TablaDefinicionPerfilesResponsable TABLE (
PerfilIDResponsable int primary key
,EIDResponsable int
,PerfilId int
,[Country_Ident] int
,[City_Ident] int
,[Location_Ident] int
,[Client_Ident] int
,[Program_Ident] int
,[Contract_Type_Ident] int
,[ConceptoId] int
,[TipoAccesoId] int
)
DECLARE @TablaPerfilesSolicitantes TABLE (PerfilIDSolicitante int, NombrePerfil nvarchar(50), CountryId int, CityId int, LocationId int, ClientId int, ProgramId int, ContractId int, ConceptoId int)
DECLARE @TablaPerfilesAutorizantes TABLE (PerfilIDSolicitante int, NombrePerfil nvarchar(50), CountryId int, CityId int, LocationId int, ClientId int, ProgramId int, ContractId int, ConceptoId int)
DECLARE @TablaCCMSIDSolicitantes TABLE (EID int)
DECLARE @TablaCCMSIDAutorizantes TABLE (EID int)
DECLARE @TablaSolicitudesSolicitantes TABLE (FolioId int, Estatus nvarchar(10), EID int, email nvarchar(100), Nombre nvarchar(250))
DECLARE @TablaSolicitudesAutorizantes TABLE (FolioId int, Estatus nvarchar(10), EID int, email nvarchar(100), Nombre nvarchar(250))

SET @PeriodoNoimaId = (select PeriodoNominaId from [app620].[CatPeriodosNomina] where convert(date,getdate()) between convert(date,FechaInicio) and convert(date,FechaFin))

/*
PASO 1:
Obtener el perfil del responsable logeado
*/
INSERT INTO @TablaPerfilesResponsable
select
Perfil_Ident,EmpleadoId
from [app620].[CatPerfilEmpleadosAccesos]
where EmpleadoId = @ResponsableCCMSID
AND Active = 1

--SELECT * from @TablaPerfilesResponsable

/*
PASO 2:
Sacar la definicion del perfil o los perfiles donde aplique el responsable por medio del CCMSID
*/
INSERT INTO @TablaDefinicionPerfilesResponsable
SELECT
b.PerfilID,b.EID,a.Perfil_Ident,a.Country_Ident,a.City_Ident,a.Location_Ident,a.Client_Ident,a.Program_Ident,a.Contract_Type_Ident,a.ConceptoId,a.TipoAccesoId
from [app620].[CatPerfilEmpleados] a
inner join @TablaPerfilesResponsable b on a.Perfil_Ident in (b.PerfilID)
AND a.Active = 1

--SELECT * FROM @TablaDefinicionPerfilesResponsable

/*
PASO 3:
Obtener pefiles de solicitante y autorizantes que concuerden con la definicion del perfil o perfiles del responsable.
*/
INSERT INTO @TablaPerfilesSolicitantes
SELECT DISTINCT
a.Perfil_Ident, a.NombrePerfilEmpleados, a.Country_Ident, a.City_Ident, a.Location_Ident, a.Client_Ident, a.Program_Ident, a.Contract_Type_Ident, a.ConceptoId
FROM [app620].[CatPerfilEmpleados] a
INNER JOIN @TablaDefinicionPerfilesResponsable b on
(((a.Country_Ident = b.Country_Ident OR a.Country_Ident = -1)
AND
(a.City_Ident = b.City_Ident OR a.City_Ident = -1)
AND
(a.Location_Ident = b.Location_Ident OR a.Location_Ident = -1))
OR
((a.Client_Ident = b.Client_Ident OR a.Client_Ident = -1)
AND
(a.Program_Ident = b.Program_Ident OR a.Program_Ident = -1))
OR
(a.Contract_Type_Ident = b.Contract_Type_Ident OR a.Contract_Type_Ident = -1)
OR
(a.ConceptoId = b.ConceptoId OR a.ConceptoId = -1))
AND
a.TipoAccesoId = 1
AND
a.Active = 1


--SELECT * FROM @TablaPerfilesSolicitantes


INSERT INTO @TablaPerfilesAutorizantes
SELECT DISTINCT
a.Perfil_Ident, a.NombrePerfilEmpleados, a.Country_Ident, a.City_Ident, a.Location_Ident, a.Client_Ident, a.Program_Ident, a.Contract_Type_Ident, a.ConceptoId
FROM [app620].[CatPerfilEmpleados] a
INNER JOIN @TablaDefinicionPerfilesResponsable b on
(((a.Country_Ident = b.Country_Ident OR a.Country_Ident = -1)
AND
(a.City_Ident = b.City_Ident OR a.City_Ident = -1)
AND
(a.Location_Ident = b.Location_Ident OR a.Location_Ident = -1))
OR
((a.Client_Ident = b.Client_Ident OR a.Client_Ident = -1)
AND
(a.Program_Ident = b.Program_Ident OR a.Program_Ident = -1))
OR
(a.Contract_Type_Ident = b.Contract_Type_Ident OR a.Contract_Type_Ident = -1)
OR
(a.ConceptoId = b.ConceptoId OR a.ConceptoId = -1))
AND
a.TipoAccesoId = 2
AND
a.Active = 1


--SELECT * FROM @TablaPerfilesAutorizantes

/*
PASO 4:
Dividir los perfiles por solicitante y autorizantes
*/
INSERT INTO @TablaCCMSIDSolicitantes
SELECT DISTINCT
a.EmpleadoId--, a.*
FROM [app620].[CatPerfilEmpleadosAccesos] a
INNER JOIN @TablaPerfilesSolicitantes b on a.Perfil_Ident = b.PerfilIDSolicitante AND a.Active = 1


--SELECT * FROM @TablaCCMSIDSolicitantes



INSERT INTO @TablaCCMSIDAutorizantes
SELECT DISTINCT
a.EmpleadoId--, a.*
FROM [app620].[CatPerfilEmpleadosAccesos] a
INNER JOIN @TablaPerfilesAutorizantes b on a.Perfil_Ident = b.PerfilIDSolicitante AND a.Active = 1


--SELECT * FROM @TablaCCMSIDAutorizantes


/*
PASO 5:
Obtener los ccmsid relacionados con cada perfil y sus email.
En el caso de solicitantes, buscar por medio del ccmsid todas las solicitudes que estan en estatus de borrador(EB) o rechazadas(R) relacionadas a ese CCMSID.
En el caso de autorizantes, buscar por medio del ccmsid todas las solicitudes que estan en estatus de PA relacionadas a ese CCMSID.
*/
INSERT INTO @TablaSolicitudesSolicitantes
SELECT
a.FolioSolicitud, a.EstatusSolicitudId, a.Solicitante_Ident, c.email1 + ';Alfredo.Guerrero@teleperformance.com' email1, c.Nombre
FROM [app620].[CatSolicitudes] a
INNER JOIN @TablaCCMSIDSolicitantes b on a.Solicitante_Ident = b.EID AND a.EstatusSolicitudId in ('EB','R') AND a.Active = 1 AND a.PeriodoNominaId = @PeriodoNoimaId
INNER JOIN [app620].[CatEmployeeCCMSVw] c on b.EID = c.Ident

--SELECT * FROM @TablaSolicitudesSolicitantes order by eid


INSERT INTO @TablaSolicitudesAutorizantes
SELECT DISTINCT
a.FolioSolicitud,b.EstatusSolicitudId, a.Autorizador_Ident, d.email1 + ';Alfredo.Guerrero@teleperformance.com' email1, d.Nombre
FROM [app620].[CatSolicitudEmpleadosAutorizantes] a
INNER JOIN [app620].[CatSolicitudes] b on a.FolioSolicitud = b.FolioSolicitud AND b.EstatusSolicitudId in ('PA') AND a.Active = 1 AND b.PeriodoNominaId = @PeriodoNoimaId
INNER JOIN @TablaCCMSIDAutorizantes c on a.Autorizador_Ident = c.EID AND a.Pendiente = 1
INNER JOIN [app620].[CatEmployeeCCMSVw] d on c.EID = d.Ident
order by a.Autorizador_Ident


--SELECT * FROM @TablaSolicitudesAutorizantes order by eid

/*
PASO 6:
Juntar las solicitudes que se van a enviar por email.
*/
SELECT
FolioId, Estatus, EID, email, 1 AS Accesos, Nombre
FROM @TablaSolicitudesSolicitantes

UNION

SELECT
FolioId, Estatus, EID, email, 2 AS Accesos, Nombre
FROM @TablaSolicitudesAutorizantes
ORDER BY EID
END
