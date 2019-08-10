


/*
	Consulta los autorizadores por solicitud, Concepto y Empleado

 */

ALTER PROCEDURE app620.CatSolicitudAutorizantesSel
	@FolioSolicitud		INT
	,@ConceptoId		INT
	,@Empleado_Ident	INT
AS

BEGIN
SELECT FolioSolicitud
		,Empleado_Ident	
		,ConceptoId		
		,NivelAutorizacion
		,Autorizador_Ident
	FROM app620.CatSolicitudEmpleadosAutorizantes 
	where FolioSolicitud = @FolioSolicitud	--16
	and ConceptoId = @ConceptoId			--9
	and Empleado_Ident = @Empleado_Ident	--3235579
	and Autorizador_Ident IS NOT NULL
END