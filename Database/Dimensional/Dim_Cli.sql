--- Dimension Clientes

SELECT
    CAST(clientes.[Customer_ID] AS INT) AS Customer_ID,
    CAST(clientes.[Edad] AS INT) AS Edad,
    clientes.[Fecha_nacimiento],
    clientes.[GENERO],
    CAST(COALESCE(cp.[codigopostalid], mosaic.[CP_value]) AS INT) AS CP,
    cp.[poblacion],
    cp.[provincia],
    clientes.[STATUS_SOCIAL],
    CAST(clientes.[RENTA_MEDIA_ESTIMADA] AS INT) AS RENTA_MEDIA_ESTIMADA,
    CAST(clientes.[ENCUESTA_ZONA_CLIENTE_VENTA] AS INT) AS ENCUESTA_ZONA_CLIENTE_VENTA,
    CAST(clientes.[ENCUESTA_CLIENTE_ZONA_TALLER] AS INT) AS ENCUESTA_CLIENTE_ZONA_TALLER,
    CAST(mosaic.[A] AS FLOAT) AS A,
    CAST(mosaic.[B] AS FLOAT) AS B,
    CAST(mosaic.[C] AS FLOAT) AS C,
    CAST(mosaic.[D] AS FLOAT) AS D,
    CAST(mosaic.[E] AS FLOAT) AS E,
    CAST(mosaic.[F] AS FLOAT) AS F,
    CAST(mosaic.[G] AS FLOAT) AS G,
    CAST(mosaic.[H] AS FLOAT) AS H,
    CAST(mosaic.[I] AS FLOAT) AS I,
    CAST(mosaic.[J] AS FLOAT) AS J,
    CAST(mosaic.[K] AS FLOAT) AS K,
    CAST(mosaic.[U2] AS FLOAT) AS U2,
    mosaic.[Max_Mosaic_G],
    CAST(mosaic.[Max_Mosaic2] AS FLOAT) AS Max_Mosaic2,
    CAST(mosaic.[Renta_Media] AS INT) AS Renta_Media,
    CAST(mosaic.[F2] AS INT) AS F2,
    CAST(mosaic.[Mosaic_number] AS INT) AS Mosaic_number,

    -- Unificamos los códigos postales en una sola columna
    COALESCE(
        CONCAT('CP', cp.[CP]),                     -- Código postal de la tabla cp (con prefijo "CP")
        CONCAT('CP', mosaic.[CP_value]),           -- Código postal de la tabla mosaic (le añadimos el prefijo "CP")
        CONCAT('CP', clientes.[CODIGO_POSTAL])     -- Código postal de la tabla clientes (le añadimos el prefijo "CP")
    ) AS CODIGO_POSTAL_UNIFICADO

FROM [DATAEX].[003_clientes] clientes
LEFT JOIN 
    [DATAEX].[005_cp] cp ON clientes.[CODIGO_POSTAL] = cp.[CP]  -- Unimos por CP con prefijo
LEFT JOIN 
    [DATAEX].[019_Mosaic] mosaic ON clientes.[CODIGO_POSTAL] = mosaic.[CP_value];  -- Unimos por CP sin prefijo