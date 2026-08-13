SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month, 
    COUNT(*)
FROM orders
GROUP BY month;

SELECT 
    DATE_FORMAT(order_date, '%Y') AS year, 
    COUNT(*)
FROM orders
GROUP BY year;

SELECT *
FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-04-30';

SELECT 
    *, 
    MONTH(order_date) AS month_number
FROM orders;

SELECT 
  DATE_FORMAT(o.order_date, '%Y-%m') AS month,
  SUM(i.quantity * p.price) AS total_revenue
FROM orders o
JOIN order_items i using (order_id)
JOIN products p using (product_id)
GROUP BY month order by total_revenue DESC;

