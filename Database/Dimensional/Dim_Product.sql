-- Selección de la dimensión de productos

SELECT
    -- Identificador único del producto
    [Id_Producto], 

    -- Código del producto
    producto.[Code_], 

    -- Identificador de la categoría del producto
    producto.[CATEGORIA_ID], 

    -- Modelo del producto
    producto.[Modelo], 

    -- Tipo de combustible asociado al producto
    fuel.[FUEL], 

    -- Identificador del grado del producto dentro de su categoría
    categoría_producto.[Grade_ID], 

    -- Equipamiento adicional del producto
    categoría_producto.[Equipamiento], 

    -- Modelo del producto en la tabla de costos
    costes.[Modelo], 

    -- Costo de transporte del producto
    costes.[Costetransporte], 

    -- Gastos de marketing asociados al producto
    costes.[GastosMarketing], 

    -- Costo medio de mantenimiento del producto
    costes.[Mantenimiento_medio], 

    -- Comisión que la marca cobra por la venta del producto
    costes.[Comisión_Marca]

FROM [DATAEX].[006_producto] producto

-- Relación con la tabla de combustibles para obtener información sobre el tipo de combustible
LEFT JOIN [DATAEX].[015_fuel] fuel 
    ON producto.Fuel_ID = fuel.Fuel_ID

-- Relación con la tabla de categorías de productos para obtener detalles sobre su categoría y equipamiento
LEFT JOIN [DATAEX].[014_categoría_producto] categoría_producto 
    ON producto.CATEGORIA_ID = categoría_producto.CATEGORIA_ID

-- Relación con la tabla de costos para obtener información financiera sobre el producto
LEFT JOIN [DATAEX].[007_costes] costes 
    ON producto.Modelo = costes.Modelo;
