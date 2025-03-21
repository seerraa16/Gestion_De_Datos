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
    [Date],
    Anno,
    Annomes,
    Dia,
    Diadelasemana,
    Diadelesemana_desc,
    Festivo,
    Findesemana,
    FinMes,
    InicioMes,
    Laboral,
    Mes,
    Mes_desc,
    [Week]
FROM    
    [DATAEX].[002_date] AS [date]




-- Hacer con ids calcular todas las cosas que no esyan en las tablas de dimensiones y todas las medidas: margen (esta en el portal) importante que esten todas las nedidas


SELECT
[CODE],
    tienda.[TIENDA_ID],
    clientes.[Customer_ID],
    producto.[Id_Producto],
    tiempo.[Date],
    sales.[Sales_Date],
    sales.[PVP],
    sales.[MANTENIMIENTO_GRATUITO],
    sales.[SEGURO_BATERIA_LARGO_PLAZO],
    sales.[FIN_GARANTIA],
    sales.[COSTE_VENTA_NO_IMPUESTOS],
    sales.[IMPUESTOS],
    sales.[EN_GARANTIA],
    sales.[EXTENSION_GARANTIA]

FROM [DATAEX].[001_sales] sales
LEFT JOIN
  [DATAEX].[011_tienda] tienda ON sales.Tienda_ID = tienda.Tienda_ID
LEFT JOIN
  [DATAEX].[003_clientes] clientes ON sales.Customer_ID = clientes.Customer_ID
LEFT JOIN
  [DATAEX].[006_producto] producto ON sales.Id_Producto = producto.Id_Producto
LEFT JOIN
  [DATAEX].[002_date] tiempo ON sales.Sales_Date = tiempo.Date

  ---- CON MARGEN 


SELECT
    [CODE],
    tienda.[TIENDA_ID],
    clientes.[Customer_ID],
    producto.[Id_Producto],
    tiempo.[Date],
    sales.[Sales_Date],
    sales.[PVP],
    sales.[MANTENIMIENTO_GRATUITO],
    sales.[SEGURO_BATERIA_LARGO_PLAZO],
    sales.[FIN_GARANTIA],
    sales.[COSTE_VENTA_NO_IMPUESTOS],
    sales.[IMPUESTOS],
    sales.[EN_GARANTIA],
    sales.[EXTENSION_GARANTIA],
    costes.[Margen],
    costes.[Margendistribuidor],
    costes.[Costetransporte],
    costes.[GastosMarketing],
    costes.[Comisión_marca],


    -- Cálculo de Margen Bruto en euros
    ROUND(sales.PVP * (Margen)*0.01 * (1 - IMPUESTOS / 100), 2) AS Margen_eur_bruto,

    ROUND(sales.PVP * (Margen)*0.01 * (1 - IMPUESTOS / 100) - sales.COSTE_VENTA_NO_IMPUESTOS - (Margendistribuidor*0.01 + GastosMarketing*0.01-Comisión_Marca*0.01) * sales.PVP * (1 - IMPUESTOS / 100) - Costetransporte, 2) AS Margen_eur

FROM [DATAEX].[001_sales] sales
LEFT JOIN [DATAEX].[011_tienda] tienda 
    ON sales.Tienda_ID = tienda.TIENDA_ID
LEFT JOIN [DATAEX].[003_clientes] clientes 
    ON sales.Customer_ID = clientes.Customer_ID
LEFT JOIN [DATAEX].[002_date] tiempo 
    ON sales.Sales_Date = tiempo.Date

LEFT JOIN [DATAEX].[006_producto] producto ON sales.Id_Producto = producto.Id_Producto
LEFT JOIN [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo;

 






    