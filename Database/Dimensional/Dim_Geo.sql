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