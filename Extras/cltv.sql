-- Declaración de Variables: Se definen los coeficientes del modelo de churn.
DECLARE
    -- Intercepto del modelo
    @b_intercepto FLOAT,
    -- Coeficiente del Precio de Venta Promedio (PVP)
    @b_pvp FLOAT,
    -- Coeficiente de la edad media del coche
    @b_edad FLOAT,
    -- Coeficiente del kilometraje medio por revisión
    @b_km FLOAT,
    -- Coeficiente del margen medio
    @b_revisiones FLOAT;

-- Carga de Coeficientes: Se extraen los coeficientes previamente calculados desde la tabla churn_coef.
SELECT
    @b_intercepto = MAX(CASE WHEN Variable = 'Intercepto' THEN Coeficiente END),
    @b_pvp        = MAX(CASE WHEN Variable = 'PVP' THEN Coeficiente END),
    @b_edad       = MAX(CASE WHEN Variable = 'Edad_Media_Coche' THEN Coeficiente END),
    @b_km         = MAX(CASE WHEN Variable = 'Km_Medio_Por_Revision' THEN Coeficiente END),
    @b_revisiones = MAX(CASE WHEN Variable = 'Margen_Medio' THEN Coeficiente END)
FROM churn_coef;

-- CTE (Common Table Expression) para calcular la probabilidad de retención por cliente.
WITH retencion_cte AS (
    SELECT
        c.Customer_ID,
        -- Cálculo de la retención usando la función LEAST y GREATEST para acotar valores entre 0 y 1.
        LEAST(1, GREATEST(0,
            1 - (
                @b_intercepto +
                AVG(f.PVP) * @b_pvp +                 -- Impacto del precio de venta
                MAX(f.Car_Age) * @b_edad +           -- Impacto de la edad del coche
                AVG(f.km_ultima_revision) * @b_km +  -- Impacto del kilometraje medio
                AVG(f.Revisiones) * @b_revisiones    -- Impacto del número de revisiones
            )
        )) AS retencion_estimado
    FROM Dim_client c
    LEFT JOIN Facts_Table f ON c.Customer_ID = f.Customer_ID
    GROUP BY c.Customer_ID
)

-- Consulta principal: Genera el dataset de clientes con sus métricas de churn, retención y CLTV.
SELECT
    c.Customer_ID,
    c.Edad,

    -- Cálculo de la probabilidad de Churn
    LEAST(1, GREATEST(0, 1 - r.retencion_estimado)) AS churn_estimado,

    -- Probabilidad de retención del cliente
    r.retencion_estimado,

    -- Cálculo del CLTV (Customer Lifetime Value) para diferentes periodos
    -- Fórmula: Margen Promedio * (Retención estimada ^ años) / (1 + tasa de descuento)^años

    -- CLTV a 1 año
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1)
    ) AS CLTV_1_anio,

    -- CLTV a 2 años
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + 0.07, 2)
    ) AS CLTV_2_anios,

    -- CLTV a 3 años
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + 0.07, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + 0.07, 3)
    ) AS CLTV_3_anios,

    -- CLTV a 4 años
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + 0.07, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + 0.07, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + 0.07, 4)
    ) AS CLTV_4_anios,

    -- CLTV a 5 años
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + 0.07, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + 0.07, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + 0.07, 4) +
        POWER(r.retencion_estimado, 5) / POWER(1 + 0.07, 5)
    ) AS CLTV_5_anios

FROM Dim_client c
LEFT JOIN Facts_Table f ON c.Customer_ID = f.Customer_ID
LEFT JOIN retencion_cte r ON c.Customer_ID = r.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Edad,
    c.GENERO,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,
    c.CP,
    c.poblacion,
    c.provincia,
    c.lat,
    c.lon,
    c.Max_Mosaic_G,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    r.retencion_estimado;
