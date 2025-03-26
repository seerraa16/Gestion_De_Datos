SELECT 
    Customer_ID,
    COUNT(order_id) / COUNT(DISTINCT YEAR(order_date)) AS frecuencia_compra,
    AVG(total_amount) AS AOV
FROM ventas
GROUP BY Customer_ID;