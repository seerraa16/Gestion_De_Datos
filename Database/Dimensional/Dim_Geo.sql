-- Selección de la dimensión geográfica de las tiendas

SELECT
    -- Identificador único de la tienda
    [TIENDA_ID], 

    -- Identificador de la provincia en la que se encuentra la tienda
    tienda.[PROVINCIA_ID], 

    -- Identificador de la zona geográfica a la que pertenece la tienda
    tienda.[ZONA_ID], 

    -- Descripción de la tienda (nombre o detalles relevantes)
    [TIENDA_DESC], 

    -- Descripción de la provincia (nombre de la provincia)
    [PROV_DESC],      

    -- Nombre o descripción de la zona geográfica
    [ZONA]

FROM [DATAEX].[011_tienda] tienda

-- Relación con la tabla de provincias para obtener información detallada de la provincia de la tienda
LEFT JOIN [DATAEX].[012_provincia] provincia 
    ON tienda.PROVINCIA_ID = provincia.PROVINCIA_ID

-- Relación con la tabla de zonas para obtener información sobre la región geográfica de la tienda
LEFT JOIN [DATAEX].[013_zona] zona 
    ON tienda.ZONA_ID = zona.ZONA_ID;
