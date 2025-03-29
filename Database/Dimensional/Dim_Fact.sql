SELECT
    -- Código único de la venta
    sales.[CODE],

    -- Identificador de la tienda donde se realizó la venta
    tienda.[TIENDA_ID],

    -- Identificador único del cliente que realizó la compra
    clientes.[Customer_ID],

    -- Identificador único del producto vendido
    producto.[Id_Producto],

    -- Fecha de la venta en el formato de la tabla de tiempo
    tiempo.[Date],

    -- Fecha específica de la venta
    sales.[Sales_Date],

    -- Precio de venta al público (PVP) del producto
    sales.[PVP],

    -- Indica si el producto cuenta con mantenimiento gratuito
    sales.[MANTENIMIENTO_GRATUITO],

    -- Indica si el producto tiene seguro de batería a largo plazo
    sales.[SEGURO_BATERIA_LARGO_PLAZO],

    -- Fecha de finalización de la garantía del producto
    sales.[FIN_GARANTIA],

    -- Coste de venta sin incluir impuestos
    sales.[COSTE_VENTA_NO_IMPUESTOS],

    -- Impuestos aplicados a la venta
    sales.[IMPUESTOS],

    -- Indica si el producto está actualmente en garantía
    sales.[EN_GARANTIA],

    -- Indica si el cliente ha adquirido una extensión de garantía
    sales.[EXTENSION_GARANTIA],

    -- Margen de ganancia sobre la venta
    costes.[Margen],

    -- Margen de ganancia del distribuidor
    costes.[Margendistribuidor],

    -- Coste de transporte asociado a la venta
    costes.[Costetransporte],

    -- Gastos de marketing relacionados con la venta
    costes.[GastosMarketing],

    -- Comisión que recibe la marca por la venta
    costes.[Comisión_marca],

    -- Tiempo de entrega del producto desde la compra
    logistic.[Lead_compra],

    -- Indica si la venta fue resultado de un lead comercial
    logistic.[fue_Lead],

    -- Fecha estimada de producción del producto
    logistic.[t_prod_date],

    -- Días transcurridos desde la última revisión del vehículo/producto
    rev.[DIAS_DESDE_ULTIMA_REVISION],

    -- Edad del coche (en años) en el momento de la venta
    edad.[Car_Age],

    -- Kilometraje registrado en la última revisión
    rev.[km_ultima_revision],

    -- Número total de revisiones realizadas al producto
    rev.[Revisiones],

    -- Indica si el cliente ha presentado quejas sobre el producto
    cac.[QUEJA],

    -- Número de días que el vehículo/producto ha permanecido en el taller
    cac.[DIAS_EN_TALLER],


    -- Cálculo del margen bruto en euros después de impuestos
    ROUND(sales.PVP * (Margen) * 0.01 * (1 - IMPUESTOS / 100), 2) AS Margen_eur_bruto,

    -- Cálculo del margen neto considerando todos los costes asociados
    ROUND(sales.PVP * (Margen) * 0.01 * (1 - IMPUESTOS / 100) - 
          sales.COSTE_VENTA_NO_IMPUESTOS - 
          (Margendistribuidor * 0.01 + GastosMarketing * 0.01 - Comisión_Marca * 0.01) * 
          sales.PVP * (1 - IMPUESTOS / 100) - Costetransporte, 2) AS Margen_eur,

    -- Cálculo de la tasa de Churn: Indica si la venta se considera "perdida" por falta de revisiones recientes
    CASE
        -- Caso 1: Revisión reciente o sin revisión en los últimos 400 días → No churn (0)
        WHEN rev.DIAS_DESDE_ULTIMA_REVISION IS NOT NULL 
             AND rev.DIAS_DESDE_ULTIMA_REVISION <> '' 
             AND TRY_CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) BETWEEN 0 AND 400
        THEN 0
        -- Caso 2: No ha habido revisiones en más de 400 días → Churn (1)
        WHEN rev.DIAS_DESDE_ULTIMA_REVISION IS NOT NULL 
             AND rev.DIAS_DESDE_ULTIMA_REVISION <> '' 
             AND TRY_CAST(REPLACE(rev.DIAS_DESDE_ULTIMA_REVISION, '.', '') AS INT) > 400
        THEN 1
        -- Caso 3: Datos faltantes o inesperados → Churn por precaución (1)
        ELSE 1
    END AS Churn

FROM [DATAEX].[001_sales] sales

-- Relación con la tabla de tiendas para obtener información sobre la ubicación de la venta
LEFT JOIN [DATAEX].[011_tienda] tienda 
    ON sales.Tienda_ID = tienda.TIENDA_ID

-- Relación con la tabla de clientes para vincular la venta con un cliente específico
LEFT JOIN [DATAEX].[003_clientes] clientes 
    ON sales.Customer_ID = clientes.Customer_ID

-- Relación con la tabla de tiempo para obtener datos temporales estructurados
LEFT JOIN [DATAEX].[002_date] tiempo 
    ON sales.Sales_Date = tiempo.Date

-- Relación con la tabla de logística para obtener datos sobre entrega y producción
LEFT JOIN [DATAEX].[017_logist] logistic 
    ON sales.CODE = logistic.CODE

-- Relación con la tabla de revisiones para analizar mantenimiento del producto
LEFT JOIN [DATAEX].[004_rev] rev 
    ON sales.CODE = rev.CODE

-- Relación con la tabla de edad del vehículo/producto
LEFT JOIN [DATAEX].[018_edad] edad 
    ON sales.CODE = edad.CODE

-- Relación con la tabla de atención al cliente (CAC) para identificar quejas y tiempo en taller
LEFT JOIN [DATAEX].[008_cac] cac
    ON sales.CODE = cac.CODE

-- Relación con la tabla de productos para obtener información del producto vendido
LEFT JOIN [DATAEX].[006_producto] producto 
    ON sales.Id_Producto = producto.Id_Producto

-- Relación con la tabla de costes para calcular márgenes y gastos asociados a la venta
LEFT JOIN [DATAEX].[007_costes] costes 
    ON producto.Modelo = costes.Modelo;
