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
    clientes.[RENTA_MEDIA_ESTIMADA],
    clientes.[Fecha_nacimiento],
    clientes.[STATUS_SOCIAL],
    -- Unificamos los códigos postales en una sola columna
    COALESCE(
        cp.[CP],                     -- Código postal de la tabla cp (con prefijo "CP")
        CONCAT('CP', mosaic.[CP_value]), -- Código postal de la tabla mosaic (le añadimos el prefijo "CP")
        CONCAT('CP', clientes.[CODIGO_POSTAL]) -- Código postal de la tabla clientes (le añadimos el prefijo "CP")
    ) AS CODIGO_POSTAL_UNIFICADO
FROM [DATAEX].[003_clientes] clientes
LEFT JOIN 
  [DATAEX].[005_cp] cp ON clientes.[CODIGO_POSTAL] = cp.[CP]  -- Unimos por CP con prefijo
LEFT JOIN 
  [DATAEX].[019_Mosaic] mosaic ON clientes.[CODIGO_POSTAL] = mosaic.[CP_value];  -- Unimos por CP sin prefijo


--- Dimension producto
SELECT
[Id_Producto]
    ,producto.[Code_]
    ,producto.[Fuel_ID]
    ,producto.[CATEGORIA_ID]
    ,producto.[Modelo]
    ,fuel.[FUEL]
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

    
    

-- Hacer con ids calcular todas las cosas que no esyan en las tablas de dimensiones y todas las medidas: margen (esta en el portal) importante que esten todas las nedidas


SELECT
