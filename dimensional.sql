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
    [Customer_ID],
    -- Añadimos el prefijo "CP" al código postal de clientes
    CONCAT('CP', clientes.[CODIGO_POSTAL]) AS CODIGO_POSTAL_FORMATADO, 
    clientes.[RENTA_MEDIA_ESTIMADA],
    clientes.[Fecha_nacimiento],
    clientes.[STATUS_SOCIAL],
    -- El CP de la tabla cp ya tiene el prefijo "CP"
    cp.[CP],
    mosaic.[CP_value]
FROM [DATAEX].[003_clientes] clientes
LEFT JOIN 
  [DATAEX].[005_cp] cp ON CONCAT('CP', clientes.[CODIGO_POSTAL]) = cp.[CP]  -- Aquí igualamos con el CP con prefijo
LEFT JOIN 
  [DATAEX].[019_Mosaic] mosaic ON clientes.[CODIGO_POSTAL] = mosaic.[CP_value]  -- Mosaic tiene el CP sin prefijo




--- Dimension producto
SELECT
[Id_Producto]
    ,producto.[Code_]
    ,producto.[Fuel_ID]
    ,producto.[CATEGORIA_ID]
    ,producto.[Modelo]
    ,fuel.[Fuel_ID]
    ,fuel.[FUEL]
    ,categoría_producto.[CATEGORIA_ID]
    ,categoría_producto.[Grade_ID]
    ,categoría_producto.[Equipamiento]
    ,costes.[Modelo]
    ,costes.[Costetransporte]
    ,costes.[GastosMarketing]
    ,costes.[Mantenimiento_medio]
    ,costes.[Comisión_Marca]

FROM [DATAEX].[006_producto] producto
LEFT JOIN
  [DATAEX].[015_fuel] fuel ON producto.Fuel_ID = fuel.Fuel_ID
LEFT JOIN
  [DATAEX].[014_categoría_producto] categoría_producto ON producto.CATEGORIA_ID = categoría_producto.CATEGORIA_ID
LEFT JOIN
  [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo



--- Dimension Tiempo 
SELECT
[Date]
    ,date.[Dia]
    ,date.[Mes]
    ,date.[Anno]
    ,date.[Week]      
    ,[ZONA]
    
    

