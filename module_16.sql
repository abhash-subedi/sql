use my_assignment;

select price, product_name, case when price > 300 then 'high' when price > 100 then 'mid' else 'low' end as price_band from products;

SELECT 
    c.segment,
    SUM(CASE WHEN o.status = 'Completed' THEN 1 ELSE 0 END) AS completed_orders,
    SUM(CASE WHEN o.status != 'Completed' THEN 1 ELSE 0 END) AS non_completed_orders,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.segment;

SELECT 
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    
    -- Count only orders that were NOT completed
    COUNT(DISTINCT CASE WHEN o.status != 'Completed' THEN 1 END) AS non_completed_orders,
    
    -- Calculate non-completion percentage
    ROUND(
        (COUNT(DISTINCT CASE WHEN o.status != 'Completed' THEN 1 END) * 100.0) 
        / COUNT(DISTINCT o.order_id), 
        2
    ) AS non_completion_rate_pct

FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.category;


SELECT 
    c.country,
    SUM(CASE WHEN p.category = 'Electronics' THEN (p.price * oi.quantity) ELSE 0 END) AS 'Electronic rev',
    SUM(CASE WHEN p.category = 'Furniture' THEN (p.price * oi.quantity) ELSE 0 END) 'furn rev',
    SUM(CASE WHEN p.category = 'Stationery' THEN (p.price * oi.quantity) ELSE 0 END) 'stat rev',
    SUM(CASE WHEN p.category = 'Sports' THEN (p.price * oi.quantity) ELSE 0 END) 'sport rev'
FROM customers AS c
        JOIN orders AS o ON o.customer_id = c.customer_id
        JOIN order_items AS oi ON oi.order_id = o.order_id
        JOIN products AS p ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY c.country;


SELECT 
    *
FROM
    orders
ORDER BY CASE status
    WHEN 'Completed' THEN 1
    WHEN 'Returned' THEN 2
    WHEN 'Canceled' THEN 3
    ELSE 4
END;









