WITH CustomerAggregates AS (
    SELECT 
        sales.Customer_ID,
        -- Número total de ventas por cliente
        COUNT(sales.CODE) AS num_ventas,

        -- Precio medio de venta (ticket promedio)
        AVG(CAST(sales.PVP AS DECIMAL(10,2))) AS pvp_medio,

        -- Coste medio de venta
        AVG(CAST(sales.COSTE_VENTA_NO_IMPUESTOS AS DECIMAL(10,2))) AS coste_medio,

        -- Última fecha de compra del cliente
        MAX(sales.Sales_Date) AS ultima_fecha_compra,

        -- Precio mínimo y máximo pagado
        MIN(CAST(sales.PVP AS DECIMAL(10,2))) AS pvp_min,
        MAX(CAST(sales.PVP AS DECIMAL(10,2))) AS pvp_max,

        -- Margen medio generado por el cliente
        AVG(CAST(sales.Margen_eur AS DECIMAL(10,2))) AS margen_medio
    FROM [DATAEX].[001_sales] sales
    GROUP BY sales.Customer_ID
),

FechasLimpias AS (
    SELECT 
        sales.Customer_ID,
        -- Validación de fechas
        CASE 
            WHEN ISDATE(sales.Sales_Date) = 1 THEN CAST(sales.Sales_Date AS DATETIME)
            ELSE NULL
        END AS Sales_Date_clean
    FROM [DATAEX].[001_sales] sales
)

SELECT
    -- Datos del Cliente
    c.Customer_ID,
    c.Edad,
    c.Fecha_nacimiento,
    c.GENERO,
    c.CP,
    c.poblacion,
    c.provincia,
    c.STATUS_SOCIAL,
    c.RENTA_MEDIA_ESTIMADA,

    -- Datos de Venta
    f.CODE,
    f.PVP,
    f.COSTE_VENTA_NO_IMPUESTOS,
    f.IMPUESTOS,
    f.Margen_eur,
    f.Sales_Date,

    -- Métricas Calculadas
    agg.num_ventas,
    agg.pvp_medio,
    agg.coste_medio,
    agg.ultima_fecha_compra,
    agg.pvp_min,
    agg.pvp_max,
    agg.margen_medio,

    -- Días desde la última compra
    DATEDIFF(DAY, agg.ultima_fecha_compra, GETDATE()) AS dias_ultima_compra

FROM [DATAEX].[003_clientes] AS c
LEFT JOIN [DATAEX].[001_sales] AS f ON c.Customer_ID = f.Customer_ID
LEFT JOIN CustomerAggregates AS agg ON c.Customer_ID = agg.Customer_ID
LEFT JOIN FechasLimpias AS fl ON c.Customer_ID = fl.Customer_ID;
