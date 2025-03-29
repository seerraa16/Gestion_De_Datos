-- Selección de la dimensión de tiempo

SELECT
    -- Fecha en formato completo (YYYY-MM-DD)
    [Date],  

    -- Año de la fecha
    Anno,  

    -- Año y mes en formato numérico (YYYYMM)
    Annomes,  

    -- Día del mes (1-31)
    Dia,  

    -- Día de la semana en número (1=Lunes, 7=Domingo)
    Diadelasemana,  

    -- Nombre del día de la semana (Ejemplo: Lunes, Martes)
    Diadelesemana_desc,  

    -- Indica si el día es festivo (1 = Sí, 0 = No)
    Festivo,  

    -- Indica si el día es fin de semana (1 = Sí, 0 = No)
    Findesemana,  

    -- Indica si el día es el último día del mes (1 = Sí, 0 = No)
    FinMes,  

    -- Indica si el día es el primer día del mes (1 = Sí, 0 = No)
    InicioMes,  

    -- Indica si el día es laboral (1 = Sí, 0 = No)
    Laboral,  

    -- Mes en número (1 = Enero, 12 = Diciembre)
    Mes,  

    -- Nombre del mes (Ejemplo: Enero, Febrero)
    Mes_desc,  

    -- Número de la semana en el año (1-52)
    [Week]  

FROM    
    -- Selección de la tabla que contiene la dimensión de tiempo
    [DATAEX].[002_date] AS [date];  
