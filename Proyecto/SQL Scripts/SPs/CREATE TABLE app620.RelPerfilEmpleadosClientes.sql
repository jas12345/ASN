USE [ASN_PE]
GO

/****** Object:  Table [app620].[RelPerfilEmpleadosClientes]    Script Date: 18/05/2020 01:20:51 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [app620].[RelPerfilEmpleadosClientes](
	[Perfil_Ident] [int] NOT NULL,
	[Client_Ident] [int] NOT NULL,
 CONSTRAINT [PK_RelPerfilEmpleadosClientes] PRIMARY KEY CLUSTERED 
(
	[Perfil_Ident] ASC,
	[Client_Ident] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [app620].[RelPerfilEmpleadosClientes]  WITH NOCHECK ADD  CONSTRAINT [FK_RelPerfilEmpleadosClientes_CatPerfilEmpleados] FOREIGN KEY([Perfil_Ident])
REFERENCES [app620].[CatPerfilEmpleados] ([Perfil_Ident])
GO

ALTER TABLE [app620].[RelPerfilEmpleadosClientes] CHECK CONSTRAINT [FK_RelPerfilEmpleadosClientes_CatPerfilEmpleados]
GO


