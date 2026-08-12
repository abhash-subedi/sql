use my_assignment;

WITH country_revenue AS (
    SELECT 
        c.country,
        SUM(oi.quantity * p.price) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    join products as p on oi.product_id = p.product_id
    GROUP BY c.country
)
SELECT 
    country,
    total_revenue,
    total_orders
FROM country_revenue
ORDER BY total_revenue DESC;

WITH customer_revenue AS (
    SELECT 
        c.customer_id,
        SUM(p.price * oi.quantity) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id
)
SELECT 
    customer_id,
    ROUND(total_spent, 2) AS total_revenue
FROM customer_revenue
ORDER BY total_revenue DESC
LIMIT 10;

WITH order_line_items AS (
    -- CTE 1: Calculate total for each line item
    SELECT 
        o.order_id,
        (p.price * oi.quantity) AS line_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status = 'Completed'
),
order_totals AS (
    -- CTE 2: Sum line items to get the total dollar amount for each order
    SELECT 
        order_id,
        SUM(line_total) AS order_total
    FROM order_line_items
    GROUP BY order_id
)
-- Final Select: Find the average across all order totals
SELECT 
    ROUND(AVG(order_total), 2) AS average_order_value
FROM order_totals;

WITH RECURSIVE numbers AS (
    -- Anchor: Start at 1
    SELECT 1 AS n
    
    UNION ALL
    
    -- Recursive Step: Add 1 each time
    SELECT n + 1
    FROM numbers
    WHERE n < 20  -- Termination Condition: Stop when we hit 20
)
SELECT n FROM numbers;