USE [ASN_PE]
GO

/****** Object:  Table [app620].[RelPerfilEmpleadosContratos]    Script Date: 11/09/2020 16:50:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[RelPerfilEmpleadosContratos](
	[Perfil_Ident] [int] NOT NULL,
	[Contract_Type_Ident] [int] NOT NULL,
 CONSTRAINT [PK_RelPerfilEmpleadosContratos] PRIMARY KEY CLUSTERED 
(
	[Perfil_Ident] ASC,
	[Contract_Type_Ident] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [app620].[RelPerfilEmpleadosContratos]  WITH NOCHECK ADD  CONSTRAINT [FK_RelPerfilEmpleadosContratos_CatPerfilEmpleados] FOREIGN KEY([Perfil_Ident])
REFERENCES [app620].[CatPerfilEmpleados] ([Perfil_Ident])
GO

ALTER TABLE [app620].[RelPerfilEmpleadosContratos] CHECK CONSTRAINT [FK_RelPerfilEmpleadosContratos_CatPerfilEmpleados]
GO

