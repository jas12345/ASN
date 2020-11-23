USE [ASN_PE]
GO
/****** Object:  StoredProcedure [app620].[ReporteDescuentosVarios]    Script Date: 11/23/2020 8:46:48 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [app620].[ReporteDescuentosVarios] 40, 4
ALTER proc [app620].[ReporteDescuentosVarios]			
(
	@PeriodoNominaId int = 0,
	@Empresaid int = 0
)			

AS
begin	
	declare  @Contract_type_ident int = 0	

	select	
			@contract_type_ident = Contract_Type_Ident 
	from	[app620].[CatIdEmpresaXCCMSContractVw]
	where	cia_idReporteo = 	(	SELECT CIA_IDREPORTEO 
								fROM [app620].[CatCompaniaXIdEmpresaVw]
								WHERE CompañiaXidEmpresaId = @Empresaid
							 )

SELECT   ' PERIODO DE NOMINA' 'PERIODO DE NOMINA'
		,'SITE'	'SITE'
		,'EMPLEADO' 'EMPLEADO'
		,'NOMBRE' 'NOMBRE'
		,'IMPORTE' 'IMPORTE'
		,'CONCEPTO' 'CONCEPTO'
		, 'DESCRIPCION' 'DESCRIPCION'

UNION

	select 
				convert(varchar, concat(cast(pn.fechainicio as date), ' al  ', cast(pn.fechafin as date)),10)	as 'Período de Nómina'
				,convert(varchar, e.location_name		,10)													as 'Site'	
				,convert(varchar,e.ident			,10)														AS 'Empleado'
				,convert(varchar,concat(e.first_name, ' ', e.middle_name, ' ', e.last_name)	,10)			as 'Nombre'
				,convert(varchar, cast(es.ParametroConceptoMonto as money)	,10)								as	'Importe'
				,convert(varchar, c.descripcion									,10)							as 'Concepto'
				,convert(varchar, ISNULL(d.MotivoDelConcepto,'')				,10)							as  'Descripcion'
	from		app620.catSolicitudes						as s
	inner join	app620.catempleadosSolicitudes				as es
		on		s.foliosolicitud = es.foliosolicitud
	inner join	[app620].[CatPeriodosNomina]				as Pn
		on		s.periodonominaid = pn.periodonominaid
	inner join  [app620].[CatEmployeeCCMSLastChangeVw]		as e
		on		es.empleado_ident = e.ident
	inner join	[app620].[CatConceptos]						as	c
		on		es.conceptoid = c.conceptoid
	left join [app620].[CatSolicitudEmpleadosDetalle]		as  d
		on		es.FolioSolicitud = d.FolioSolicitud and es.Empleado_Ident = d.Empleado_Ident and es.conceptoid = d.conceptoid 

	where 	 	
			 s.periodonominaid = @PeriodoNominaId 
			and   es.active = 1
			and   es.estatusSolicitudid = 'CE'
			and	 e.Contract_Type_ident = @Contract_type_ident
			AND	  e.location_ident not in(	select	 siteid
											from	[app620].[CatIdEmpresaXCCMSContractVw]
											WHERE   CONTRACT_TYPE_IDENT = @contract_type_ident
											AND		SITEID IS NOT NULL	
											)
	
END

