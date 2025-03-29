SELECT
    -- Convertimos a entero customer_id 
    CAST([cliente].[Customer_ID] AS INT) AS [Customer_ID],  
    
    -- Edad del cliente, lo convertimos a entero
    CAST([cliente].[Edad] AS INT) AS [Edad],  
    
    -- Fecha de nacimiento del cliente, se mantiene en su formato original
    [cliente].[Fecha_nacimiento],  
    
    -- Género del cliente
    [cliente].[GENERO],  
    
    -- Código postal del cliente, convertido a entero
    CAST([cp].[codigopostalid] AS INT) AS [CP],  
    
    -- Nombre de la población y provincia asociadas al código postal del cliente
    [cp].[poblacion],  
    [cp].[provincia],  
    
    -- Coordenadas geográficas (latitud y longitud) del código postal del cliente
    [cp].[lat],  
    [cp].[lon],  
    
    -- Nivel socioeconómico del cliente
    [cliente].[STATUS_SOCIAL],  
    
    -- Renta media estimada del cliente, convertida a entero para cálculos futuros
    CAST([cliente].[RENTA_MEDIA_ESTIMADA] AS INT) AS [RENTA_MEDIA_ESTIMADA],  
    
    -- Resultados de encuestas sobre la zona de venta del cliente, convertidos a entero
    CAST([cliente].[ENCUESTA_ZONA_CLIENTE_VENTA] AS INT) AS [ENCUESTA_ZONA_CLIENTE_VENTA],  
    
    -- Resultados de encuestas sobre la zona de taller del cliente, convertidos a entero
    CAST([cliente].[ENCUESTA_CLIENTE_ZONA_TALLER] AS INT) AS [ENCUESTA_CLIENTE_ZONA_TALLER],  
    
    -- Variables de segmentación de clientes según el modelo Mosaic, convertidas a flotante para análisis
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
    
    -- Categoría más alta de segmentación en el modelo Mosaic
    [mosaic].[Max_Mosaic_G],  
    
    -- Otra métrica de segmentación, convertida a flotante
    CAST([mosaic].[Max_Mosaic2] AS FLOAT) AS [Max_Mosaic2],  
    
    -- Nivel de ingresos según Mosaic, convertido a entero
    CAST([mosaic].[Renta_Media] AS INT) AS [Renta_Media],  
    
    -- Otro indicador financiero en el modelo Mosaic, convertido a entero
    CAST([mosaic].[F2] AS INT) AS [F2],  
    
    -- Número de clasificación en el sistema Mosaic, convertido a entero
    CAST([mosaic].[Mosaic_number] AS INT) AS [Mosaic_number]  

FROM  
    -- Tabla principal que contiene información de los clientes
    [DATAEX].[003_clientes] AS [cliente]  
    
-- Unimos la tabla de códigos postales para obtener información geográfica del cliente
LEFT JOIN  
    [DATAEX].[005_cp] AS [cp] ON [cliente].[CODIGO_POSTAL] = [cp].[CP]  
    
-- Unimos la tabla Mosaic para agregar segmentación sociodemográfica y económica
LEFT JOIN  
    [DATAEX].[019_mosaic] AS [mosaic]  
    ON TRY_CAST([cp].[codigopostalid] AS INT) = TRY_CAST([mosaic].[CP] AS INT);
