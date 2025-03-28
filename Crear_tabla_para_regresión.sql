SELECT 
    sales.PVP AS PVP,
    AVG(sales.Car_Age) AS Edad_Media_Coche,
    AVG(sales.km_ultima_revision) AS Km_Medio_Por_Revision,
    AVG(sales.margen) AS Margen_Medio,
    COUNT(sales.CODE) * 1.0 / COUNT(DISTINCT sales.Customer_ID) AS Revisiones_Media,
    AVG(CAST(Churn AS FLOAT)) AS churn_percentage
FROM [dbo].[Facts_Table] sales
GROUP BY sales.PVP;
