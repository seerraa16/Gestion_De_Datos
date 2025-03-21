--- Dimension producto
SELECT
[Id_Producto]
    ,producto.[Code_]
    ,producto.[CATEGORIA_ID]
    ,producto.[Modelo]
    ,fuel.[FUEL]
    ,categoría_producto.[Grade_ID]
    ,categoría_producto.[Equipamiento]
    ,costes.[Modelo]
    ,costes.[Costetransporte]
    ,costes.[GastosMarketing]
    ,costes.[Mantenimiento_medio]
    ,costes.[Comisión_Marca]

FROM [DATAEX].[006_producto] producto
LEFT JOIN
  [DATAEX].[015_fuel] fuel ON producto.Fuel_ID = fuel.Fuel_ID
LEFT JOIN
  [DATAEX].[014_categoría_producto] categoría_producto ON producto.CATEGORIA_ID = categoría_producto.CATEGORIA_ID
LEFT JOIN
  [DATAEX].[007_costes] costes ON producto.Modelo = costes.Modelo