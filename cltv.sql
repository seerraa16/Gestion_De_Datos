IF OBJECT_ID('client_insights', 'U') IS NOT NULL
    DROP TABLE client_insights;

-- Declaración de Variables.
DECLARE
    -- Tasa de descuento para cálculos financieros.
    @discount_rate FLOAT = 0.07,

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
    @b_revisiones = MAX(CASE WHEN Variable = 'Revisiones_Media' THEN Coeficiente END)
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
    c.GENERO,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    SUM(CASE WHEN f.QUEJA = 'SI' THEN 1 ELSE 0 END) AS total_quejas,

    -- Datos Demográficos.
    c.CODIGO_POSTAL,
    c.poblacion,
    c.provincia,
    c.lat,
    c.lon,
    c.Max_Mosaic_G AS Segmento_Principal,

    -- Métricas de Ventas: KPIs de compras históricas.
    COUNT(DISTINCT f.CODE) AS numventas,
    AVG(f.PVP) AS pvp_medio,
    AVG(f.COSTE_VENTA_NO_IMPUESTOS) AS coste_medio_sin_impuestos,
    AVG(CASE
        WHEN f.COSTE_VENTA_NO_IMPUESTOS > 0
        THEN 100 * (f.COSTE_VENTA_NO_IMPUESTOS - f.PVP) / f.COSTE_VENTA_NO_IMPUESTOS
        ELSE 0
    END) AS descuento_medio,

    -- Postventa: Métricas de fidelización y uso del servicio.
    AVG(f.Revisiones) AS Revisiones_Media,
    CASE
        WHEN AVG(f.Revisiones) > 0 THEN c.Edad / NULLIF(AVG(f.Revisiones), 0)
        ELSE 0
    END AS ratio_edad_rev,
    AVG(f.km_ultima_revision) AS km_rev,
    MAX(f.km_ultima_revision) AS km_rev_max,
    MAX(f.DIAS_DESDE_ULTIMA_REVISION) AS dias_ultima_rev_max,
    AVG(f.DIAS_EN_TALLER) AS avg_dias_taller,
    AVG(CASE WHEN f.EN_GARANTIA = 'SI' THEN 1 ELSE 0 END) AS ratio_en_garantia,

    -- Leads: Clientes potenciales.
    MAX(CASE WHEN f.Fue_Lead = 1 THEN 1 ELSE 0 END) AS lead_algunavez,
    MAX(f.Lead_compra) AS lead_compra,

    -- Indicadores Financieros: Rentabilidad por cliente.
    AVG(f.Margen_Eur_bruto) AS margenbruto_pu,
    SUM(f.Margen_Eur) AS margen_total,
    AVG(f.Margen_Eur) AS margen_pu,

    -- Información Coches.
    MAX(f.Car_Age) AS edad_ultimocoche,
    AVG(Car_Age) AS edad_promedio_coches,
    MAX(f.Id_Producto) AS max_coches,

    -- Cálculo de PVP * Q (Ingresos Totales).
    SUM(f.PVP) AS ingresos_totales,
    SUM(f.PVP * (f.IMPUESTOS/100)) AS impuestos_totales,

    -- Fechas Clave.
    MIN(CONVERT(DATE, f.Sales_Date)) AS primera_compra,
    MAX(CONVERT(DATE, f.Sales_Date)) AS ultima_compra,
    DATEDIFF(DAY,
        MIN(CONVERT(DATE, f.Sales_Date)),
        MAX(CONVERT(DATE, f.Sales_Date))) AS dias_relacion,
    AVG(DATEDIFF(DAY, f.Prod_date, f.Sales_Date)) AS avg_dias_produccion_venta,

    -- Modelo Predictivo: Probabilidad de Churn y Retención.
        -- CHURN.
    LEAST(1, GREATEST(0, 1 - r.retencion_estimado)) AS churn_estimado,
        -- RETENCIÓN DESDE EL CTE
    r.retencion_estimado,

    -- CLTV (Customer Lifetime Value).
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 1 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1)
    ) AS CLTV_1_anio,
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 2 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2)
    ) AS CLTV_2_anios,
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 3 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3)
    ) AS CLTV_3_anios,
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 4 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + @discount_rate, 4)
    ) AS CLTV_4_anios,
        -- CLTV (Customer Lifetime Value): Valor del cliente a lo largo de 5 años.
    AVG(f.Margen_Eur) * (
        POWER(r.retencion_estimado, 1) / POWER(1 + @discount_rate, 1) +
        POWER(r.retencion_estimado, 2) / POWER(1 + @discount_rate, 2) +
        POWER(r.retencion_estimado, 3) / POWER(1 + @discount_rate, 3) +
        POWER(r.retencion_estimado, 4) / POWER(1 + @discount_rate, 4) +
        POWER(r.retencion_estimado, 5) / POWER(1 + @discount_rate, 5)
    ) AS CLTV_5_anios

INTO client_insights  -- Creación tabla de salida en local.
FROM Dim_client c
LEFT JOIN Facts_Table f ON c.Customer_ID = f.Customer_ID
LEFT JOIN retencion_cte r ON c.Customer_ID = r.Customer_ID
GROUP BY
    c.Customer_ID,
    c.Edad,
    c.GENERO,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,
    c.CODIGO_POSTAL,
    c.poblacion,
    c.provincia,
    c.lat,
    c.lon,
    c.Max_Mosaic_G,
    c.ENCUESTA_ZONA_CLIENTE_VENTA,
    c.ENCUESTA_CLIENTE_ZONA_TALLER,
    r.retencion_estimado;
ALTER TABLE client_insights
ADD CONSTRAINT PK_client_insights PRIMARY KEY (Customer_ID);

-- Resultados: Mostrar los registros de la tabla generada.
SELECT * FROM client_insights;