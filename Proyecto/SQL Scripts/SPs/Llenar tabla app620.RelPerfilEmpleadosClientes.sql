SELECT [Perfil_Ident]
      ,[Client_Ident]
  FROM [app620].[RelPerfilEmpleadosClientes]

INSERT INTO [app620].[RelPerfilEmpleadosClientes]
SELECT Perfil_Ident, Cli.Client_Ident
FROM app620.CatPerfilEmpleados PE
JOIN app620.CatClientVw Cli
ON (Cli.Client_Ident = PE.Client_Ident OR PE.Client_Ident = -1)

SELECT [Perfil_Ident]
      ,[Client_Ident]
  FROM [app620].[RelPerfilEmpleadosClientes]


