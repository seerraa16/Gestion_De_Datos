-- Dimension Geo

SELECT
[TIENDA_ID]
    ,tienda.[PROVINCIA_ID]
    ,tienda.[ZONA_ID]
    ,[TIENDA_DESC]
    ,[PROV_DESC]      
    ,[ZONA]

FROM [DATAEX].[011_tienda] tienda
LEFT JOIN
  [DATAEX].[012_provincia] provincia ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID
LEFT JOIN
  [DATAEX].[013_zona] zona ON tienda.ZONA_ID = zona.ZONA_ID


--- Dimension Clientes

SELECT
[Customer_ID]
    ,clientes.[CODIGO_POSTAL]
    ,[CP]
    ,[CP_value]

FROM [DATAEX].[003_cliente] clientes
LEFT JOIN
  [DATAEX].[005_cp] cp ON clientes.CODIGO_POSTAL = cp.CODIGO_POSTAL
LEFT JOIN
  [DATAEX].[010_Mosaic] cp_value ON clientes.CODIGO_POSTAL = cp_value.CODIGO_POSTAL



--- Dimensio producto
SELECT
[Id_Producto]
  ,producto.[Code_]
  ,producto.[Fuel_ID]
  ,producto.[CATEGORIA_ID]
  ,producto.[Modelo]
  ,[Fuel_ID]
  ,[FUEL]
  ,[CATEGORIA_ID]
  ,[Grade_ID]
  ,[Equipamiento]
  ,


--- Dimension Tiempo 
SELECT
[Date]
    ,date.[Dia]
    ,date.[Mes]
    ,date.[Anno]
    ,date.[Week]      
    ,[ZONA]
    
    

