SELECT 
    c.country,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY c.country
ORDER BY total_revenue DESC;

SELECT 
    p.category,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue,
    ROUND(SUM(oi.quantity * (p.price - p.cost)), 2) AS total_profit
FROM products p
JOIN order_items oi 
    ON p.product_id = oi.product_id
JOIN orders o 
    ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY total_profit DESC;

SELECT 
    p.category,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue,
    ROUND(SUM(oi.quantity * (p.price - p.cost)), 2) AS total_profit
FROM products p
JOIN order_items oi 
    ON p.product_id = oi.product_id
JOIN orders o 
    ON oi.order_id = o.order_id
WHERE o.status = 'Completed'
GROUP BY p.category
ORDER BY total_profit DESC;

SELECT 
    c1.customer_id AS customer1_id,
    c1.name AS customer1_name,
    c2.customer_id AS customer2_id,
    c2.name AS customer2_name,
    c1.city
FROM customers c1
JOIN customers c2 
    ON c1.city = c2.city
   AND c1.customer_id < c2.customer_id
ORDER BY c1.city, c1.customer_id, c2.customer_id;

SELECT 
    c.segment,
    ROUND(SUM(oi.quantity * p.price), 2) AS total_revenue
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY c.segment
ORDER BY total_revenue DESC;