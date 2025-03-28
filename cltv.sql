-- Declaración de Variables.
DECLARE
    -- Coeficientes del modelo de churn.
    @b_intercepto FLOAT,
    @b_pvp FLOAT,
    @b_edad FLOAT,
    @b_km FLOAT,
    @b_revisiones FLOAT;

-- Carga de Coeficientes: Extracción de los coeficientes del modelo previamente entrenado.
SELECT
    @b_intercepto = MAX(CASE WHEN Variable = 'Intercepto' THEN Coeficiente END),
    @b_pvp        = MAX(CASE WHEN Variable = 'PVP' THEN Coeficiente END),
    @b_edad       = MAX(CASE WHEN Variable = 'Edad_Media_Coche' THEN Coeficiente END),
    @b_km         = MAX(CASE WHEN Variable = 'Km_Medio_Por_Revision' THEN Coeficiente END),
    @b_revisiones = MAX(CASE WHEN Variable = 'Margen_Medio' THEN Coeficiente END)
FROM churn_coef;

-- CTE Retención: Calcular la probabilidad de retención para cada cliente.
WITH retencion_cte AS (
    SELECT
        c.Customer_ID,
        LEAST(1, GREATEST(0,
            1 - (
                @b_intercepto +
                AVG(f.PVP) * @b_pvp +
                MAX(f.Car_Age) * @b_edad +
                AVG(f.km_ultima_revision) * @b_km +
                AVG(f.Revisiones) * @b_revisiones
            )
        )) AS retencion_estimado
    FROM Dim_client c
    LEFT JOIN Facts_Table f ON c.Customer_ID = f.Customer_ID
    GROUP BY c.Customer_ID
)

-- Consulta principal: Generar el dataset de clientes con sus métricas y segmentaciones.
SELECT
    c.Customer_ID,
    c.Edad,
    -- Modelo Predictivo: Probabilidad de Churn y Retención.
        -- CHURN.
    LEAST(1, GREATEST(0, 1 - r.retencion_estimado)) AS churn_estimado,
        -- RETENCIÓN DESDE EL CTE
    r.retencion_estimado,

    -- CLTV (Customer Lifetime Value).
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 1 año.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1)
    ) AS CLTV_1_anio,
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 2 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + 0.07, 2)
    ) AS CLTV_2_anios,
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 3 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + 0.07, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + 0.07, 3)
    ) AS CLTV_3_anios,
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 4 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + 0.07, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + 0.07, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + 0.07, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + 0.07, 4)
    ) AS CLTV_4_anios,
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 5 años.
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
