SELECT
    sales.[CODE],
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
    logistic.[Lead_compra],
    logistic.[fue_Lead],
    logistic.[t_prod_date],
    rev.[DIAS_DESDE_ULTIMA_REVISION],
    edad.[Car_Age],
    rev.[km_ultima_revision],
    rev.[Revisiones],
    cac.[QUEJA],
    cac.[DIAS_EN_TALLER],




    -- Cálculo de Margen Bruto en euros
    ROUND(sales.PVP * (Margen)*0.01 * (1 - IMPUESTOS / 100), 2) AS Margen_eur_bruto,

    ROUND(sales.PVP * (Margen)*0.01 * (1 - IMPUESTOS / 100) - sales.COSTE_VENTA_NO_IMPUESTOS - (Margendistribuidor*0.01 + GastosMarketing*0.01-Comisión_Marca*0.01) * sales.PVP * (1 - IMPUESTOS / 100) - Costetransporte, 2) AS Margen_eur,
-- Tasa de Churn: Indica si la venta ha sido cancelada en los últimos 400 días (1) o no (0).
    CASE
            -- Caso 1: Revisión reciente o sin revisión (0-400 días) - No churn.
        WHEN
            rev.DIAS_DESDE_ULTIMA_REVISION IS NOT NULL AND
            rev.DIAS_DESDE_ULTIMA_REVISION <> '' AND
            TRY_CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) BETWEEN 0 AND 400
        THEN 0
            -- Caso 2: Revisión muy antigua (>400 días) - Churn.
        WHEN
            rev.DIAS_DESDE_ULTIMA_REVISION IS NOT NULL AND
            rev.DIAS_DESDE_ULTIMA_REVISION <> '' AND
            TRY_CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) > 400
        THEN 1
            -- Caso 4: Otros valores inesperados - Churn por precaución.
        ELSE 1
    END AS Churn

FROM [DATAEX].[001_sales] sales
LEFT JOIN [DATAEX].[011_tienda] tienda 
    ON sales.Tienda_ID = tienda.TIENDA_ID
LEFT JOIN [DATAEX].[003_clientes] clientes 
    ON sales.Customer_ID = clientes.Customer_ID
LEFT JOIN [DATAEX].[002_date] tiempo 
    ON sales.Sales_Date = tiempo.Date
LEFT JOIN [DATAEX].[017_logist] logistic 
    ON sales.CODE = logistic.CODE
LEFT JOIN [DATAEX].[004_rev] rev 
    ON sales.CODE = rev.CODE
LEFT JOIN [DATAEX].[018_edad] edad 
    ON sales.CODE = edad.CODE
LEFT JOIN [DATAEX].[008_cac] cac
    ON sales.CODE = cac.CODE


LEFT JOIN [DATAEX].[006_producto] producto ON sales.Id_Producto = producto.Id_Producto
LEFT JOIN [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo;