SELECT
    CAST([cliente].[Customer_ID] AS INT) AS [Customer_ID],
    CAST([cliente].[Edad] AS INT) AS [Edad],
    [cliente].[Fecha_nacimiento],
    [cliente].[GENERO],
    CAST([cp].[codigopostalid] AS INT) AS [CP],
    [cp].[poblacion],
    [cp].[provincia],
    [cp].[lat],
    [cp].[lon],
    [cliente].[STATUS_SOCIAL],
    CAST([cliente].[RENTA_MEDIA_ESTIMADA] AS INT) AS [RENTA_MEDIA_ESTIMADA],
    CAST([cliente].[ENCUESTA_ZONA_CLIENTE_VENTA] AS INT) AS [ENCUESTA_ZONA_CLIENTE_VENTA],
    CAST([cliente].[ENCUESTA_CLIENTE_ZONA_TALLER] AS INT) AS [ENCUESTA_CLIENTE_ZONA_TALLER],
    CAST([mosaic].[A] AS FLOAT) AS [A],
    CAST([mosaic].[B] AS FLOAT) AS [B],
    CAST([mosaic].[C] AS FLOAT) AS [C],
    CAST([mosaic].[D] AS FLOAT) AS [D],
    CAST([mosaic].[E] AS FLOAT) AS [E],
    CAST([mosaic].[F] AS FLOAT) AS [F],
    CAST([mosaic].[G] AS FLOAT) AS [G],
    CAST([mosaic].[H] AS FLOAT) AS [H],
    CAST([mosaic].[I] AS FLOAT) AS [I],
    CAST([mosaic].[J] AS FLOAT) AS [J],
    CAST([mosaic].[K] AS FLOAT) AS [K],
    CAST([mosaic].[U2] AS FLOAT) AS [U2],
    [mosaic].[Max_Mosaic_G],
    CAST([mosaic].[Max_Mosaic2] AS FLOAT) AS [Max_Mosaic2],
    CAST([mosaic].[Renta_Media] AS INT) AS [Renta_Media],
    CAST([mosaic].[F2] AS INT) AS [F2],
    CAST([mosaic].[Mosaic_number] AS INT) AS [Mosaic_number]
FROM
    [DATAEX].[003_clientes] AS [cliente]
LEFT JOIN
    [DATAEX].[005_cp] AS [cp] ON [cliente].[CODIGO_POSTAL] = [cp].[CP]
LEFT JOIN
    [DATAEX].[019_mosaic] AS [mosaic] ON TRY_CAST([cp].[codigopostalid] AS INT) = TRY_CAST([mosaic].[CP] AS INT);