/****** Object:  Table [app620].[CatEmpleadosSolicitudesLog]    Script Date: 02/09/2019 07:44:30 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[CatEmpleadosSolicitudesLog](
	[FolioSolicitud] [int] NULL,
	[Empleado_Ident] [int] NULL,
	[ConceptoId] [int] NULL,
	[ParametroConceptoMonto] [decimal](18, 2) NULL,
	[MotivosSolicitudId] [int] NULL,
	[EstatusSolicitudId] [varchar](5) NULL,
	[Active] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[DeactivatedBy] [int] NULL,
	[DeactivatedDate] [datetime] NULL,
	[LastModifiedBy] [int] NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedFromPCName] [varchar](64) NULL,
	[Operation] [nvarchar](10) NULL
) ON [PRIMARY]
GO


