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