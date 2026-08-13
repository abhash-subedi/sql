use my_assignment;

SELECT
  ROUND(SUM(i.quantity * p.price), 2) AS total_revenue,
  ROUND(SUM(i.quantity * (p.price - p.cost)), 2) AS total_profit,
  ROUND(
    (SUM(i.quantity * (p.price - p.cost)) / SUM(i.quantity * p.price)) * 100,
    2
  ) AS profit_margin_pct
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
JOIN products p ON i.product_id = p.product_id;

SELECT 
  DENSE_RANK() OVER (ORDER BY SUM(i.quantity * (p.price - p.cost)) DESC) AS profit_rank,
  p.category,
  ROUND(SUM(i.quantity * p.price), 2) AS total_revenue,
  ROUND(SUM(i.quantity * (p.price - p.cost)), 2) AS total_profit,
  ROUND(
    (SUM(i.quantity * (p.price - p.cost)) / NULLIF(SUM(i.quantity * p.price), 0)) * 100, 
    2
  ) AS profit_margin_pct
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
JOIN products p ON i.product_id = p.product_id
GROUP BY p.category
ORDER BY total_profit DESC;

SELECT 
  p.product_id,
  p.product_name,
  SUM(i.quantity) AS total_units_sold,
  ROUND(SUM(i.quantity * p.price), 2) AS total_revenue
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
JOIN products p ON i.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

SELECT 
  c.segment AS customer_segment,
  COUNT(DISTINCT o.order_id) AS total_orders,
  ROUND(SUM(i.quantity * p.price), 2) AS total_revenue,
  ROUND(
    SUM(i.quantity * p.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 
    2
  ) AS average_order_value
FROM orders o
JOIN order_items i ON o.order_id = i.order_id
JOIN products p ON i.product_id = p.product_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.segment
ORDER BY total_revenue DESC;

WITH monthly_sales AS (
  SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(i.quantity * p.price) AS monthly_revenue
  FROM orders o
  JOIN order_items i ON o.order_id = i.order_id
  JOIN products p ON i.product_id = p.product_id
  GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
  month,
  ROUND(monthly_revenue, 2) AS monthly_revenue,
  
  -- Running total cumulative sum
  ROUND(
    SUM(monthly_revenue) OVER (ORDER BY month ASC), 
    2
  ) AS running_total_revenue,
  
  -- Month-over-Month Growth Percentage
  ROUND(
    ((monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY month ASC)) 
      / NULLIF(LAG(monthly_revenue, 1) OVER (ORDER BY month ASC), 0)) * 100,
    2
  ) AS mom_growth_pct

FROM monthly_sales
ORDER BY month ASC;

WITH product_country_revenue AS (
  SELECT 
    c.country,
    p.product_id,
    p.product_name,
    SUM(i.quantity) AS total_units_sold,
    ROUND(SUM(i.quantity * p.price), 2) AS total_revenue,
    ROW_NUMBER() OVER (
      PARTITION BY c.country 
      ORDER BY SUM(i.quantity * p.price) DESC
    ) AS `rank`
  FROM orders o
  JOIN order_items i ON o.order_id = i.order_id
  JOIN products p ON i.product_id = p.product_id
  JOIN customers c ON o.customer_id = c.customer_id
  GROUP BY c.country, p.product_id, p.product_name
)
SELECT 
  country,
  product_id,
  product_name,
  total_units_sold,
  total_revenue
FROM product_country_revenue
WHERE `rank` = 1
ORDER BY total_revenue DESC;

WITH customer_country_summary AS (
  SELECT 
    c.country,
    c.customer_id,
    c.name, -- or CONCAT(c.first_name, ' ', c.last_name) depending on your table
    SUM(i.quantity * p.price) AS customer_revenue,
    
    -- Calculate total revenue for the ENTIRE country across all customers
    SUM(SUM(i.quantity * p.price)) OVER (
      PARTITION BY c.country
    ) AS country_total_revenue,
    
    -- Rank customers within each country by their total spend
    ROW_NUMBER() OVER (
      PARTITION BY c.country 
      ORDER BY SUM(i.quantity * p.price) DESC
    ) AS `rank`
  FROM orders o
  JOIN order_items i ON o.order_id = i.order_id
  JOIN products p ON i.product_id = p.product_id
  JOIN customers c ON o.customer_id = c.customer_id
  GROUP BY c.country, c.customer_id, c.name
)


SELECT 
  'Inactive Customer' AS entity_type,
  c.customer_id AS entity_id,
  c.customer_name AS entity_name,
  CONCAT('Country: ', COALESCE(c.country, 'N/A'), ' | Segment: ', COALESCE(c.segment, 'N/A')) AS details
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL

UNION ALL

SELECT 
  'Unsold Product' AS entity_type,
  p.product_id AS entity_id,
  p.product_name AS entity_name,
  CONCAT('Category: ', COALESCE(p.category, 'N/A'), ' | Price: $', COALESCE(p.price, 0)) AS details
FROM products p
LEFT JOIN order_items i ON p.product_id = i.product_id
WHERE i.product_id IS NULL

ORDER BY entity_type, entity_id;
SELECT 
  country,
  customer_id,
  name,
  ROUND(customer_revenue, 2) AS customer_revenue,
  ROUND(country_total_revenue, 2) AS country_total_revenue,
  ROUND((customer_revenue / NULLIF(country_total_revenue, 0)) * 100, 2) AS pct_share_of_country_total
FROM customer_country_summary
WHERE `rank` = 1
ORDER BY country_total_revenue DESC;

SELECT 
  'Inactive Customer' AS entity_type,
  c.customer_id AS entity_id,
  c.name AS entity_name,
  CONCAT('Country: ', COALESCE(c.country, 'N/A')) AS details
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL

UNION ALL

SELECT 
  'Unsold Product' AS entity_type,
  p.product_id AS entity_id,
  p.product_name AS entity_name,
  CONCAT('Category: ', COALESCE(p.category, 'N/A'), ' | Price: $', COALESCE(p.price, 0)) AS details
FROM products p
LEFT JOIN order_items i ON p.product_id = i.product_id
WHERE i.product_id IS NULL

ORDER BY entity_type, entity_id;

SELECT 
  c.segment,
  COUNT(o.order_id) AS total_orders,
  SUM(CASE WHEN o.status != 'Completed' THEN 1 ELSE 0 END) AS non_completed_orders,
  ROUND(
    (SUM(CASE WHEN o.status != 'Completed' THEN 1 ELSE 0 END) / NULLIF(COUNT(o.order_id), 0)) * 100, 
    2
  ) AS non_completion_rate_pct
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.segment
ORDER BY non_completion_rate_pct DESC;
