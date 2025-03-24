-- Tabla de Clientes (no dimensional)
SELECT [Clientes] (
    [Customer_ID] INT PRIMARY KEY,
    [Nombre] NVARCHAR(100),
    [Apellidos] NVARCHAR(100),
    [Edad] INT,
    [Fecha_nacimiento] DATE,
    [Genero] NVARCHAR(20),
    [Codigo_Postal] NVARCHAR(10),
    [Direccion] NVARCHAR(200),
    [Email] NVARCHAR(100),
    [Telefono] NVARCHAR(20),
    [Fecha_Alta] DATE,
    [Status_Social] NVARCHAR(50),
    [Renta_Media_Estimada] INT,
    [Encuesta_Zona_Cliente_Venta] INT,
    [Encuesta_Cliente_Zona_Taller] INT,
    [CodigoPostal_ID] INT,  -- FK a tabla dimensional de códigos postales
    [Mosaic_ID] INT         -- FK a tabla dimensional de mosaic
);

-- Insertar datos desde las tablas originales
INSERT INTO [Clientes] (
    [Customer_ID],
    [Edad],
    [Fecha_nacimiento],
    [Genero],
    [Codigo_Postal],
    [Status_Social],
    [Renta_Media_Estimada],
    [Encuesta_Zona_Cliente_Venta],
    [Encuesta_Cliente_Zona_Taller],
    [CodigoPostal_ID],
    [Mosaic_ID]
)
SELECT 
    CAST([cliente].[Customer_ID] AS INT),
    CAST([cliente].[Edad] AS INT),
    TRY_CONVERT(DATE, [cliente].[Fecha_nacimiento]),
    [cliente].[GENERO],
    [cliente].[CODIGO_POSTAL],
    [cliente].[STATUS_SOCIAL],
    CAST([cliente].[RENTA_MEDIA_ESTIMADA] AS INT),
    CAST([cliente].[ENCUESTA_ZONA_CLIENTE_VENTA] AS INT),
    CAST([cliente].[ENCUESTA_CLIENTE_ZONA_TALLER] AS INT),
    TRY_CAST([cp].[codigopostalid] AS INT),
    [mosaic].[Mosaic_number]
FROM 
    [DATAEX].[003_clientes] AS [cliente]
LEFT JOIN
    [DATAEX].[005_cp] AS [cp] ON [cliente].[CODIGO_POSTAL] = [cp].[CP]
LEFT JOIN
    [DATAEX].[019_mosaic] AS [mosaic] ON TRY_CAST([cp].[codigopostalid] AS INT) = TRY_CAST([mosaic].[CP] AS INT);

-- Crear relaciones con tablas dimensionales
ALTER TABLE [Clientes] 
ADD CONSTRAINT [FK_Clientes_CodigoPostal] 
FOREIGN KEY ([CodigoPostal_ID]) 
REFERENCES [Dimension_CodigoPostal]([codigopostalid]);

ALTER TABLE [Clientes] 
ADD CONSTRAINT [FK_Clientes_Mosaic] 
FOREIGN KEY ([Mosaic_ID]) 
REFERENCES [Dimension_Mosaic]([Mosaic_number]);