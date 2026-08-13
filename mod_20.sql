SELECT 
product_name, 
price, 
ROUND(AVG(price) OVER (PARTITION BY category),2) AS avg_price_category
FROM
    products;
    

SELECT 
    category,
    product_name,
    price,
    ROW_NUMBER() OVER (PARTITION BY category ORDER BY price DESC) AS row_num,
    RANK()       OVER (PARTITION BY category ORDER BY price DESC) AS rank_num,
    DENSE_RANK() OVER (PARTITION BY category ORDER BY price DESC) AS dense_rank_num
FROM products;

WITH country_product_revenue AS (
    SELECT 
        c.country,
        p.product_id,
        p.product_name,
        SUM(oi.quantity * p.price) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY c.country 
            ORDER BY SUM(oi.quantity * p.price) DESC
        ) as rnk
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY c.country, p.product_id, p.product_name
)
SELECT 
    country,
    product_id,
    product_name,
    total_revenue
FROM country_product_revenue
WHERE rnk = 1;

WITH category_product_revenue AS (
    SELECT 
        p.category, -- Or c.category_name if you have a separate categories table
        p.product_id,
        p.product_name,
        SUM(oi.quantity * p.price) AS total_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY p.category 
            ORDER BY SUM(oi.quantity * p.price) DESC
        ) AS rnk
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category, p.product_id, p.product_name
)
SELECT 
    category,
    product_id,
    product_name,
    total_revenue,
    rnk AS rank_in_category
FROM category_product_revenue
WHERE rnk <= 2
ORDER BY category, rnk;

SELECT 
    product_id,
    product_name,
    price,
    NTILE(4) OVER (
        ORDER BY price DESC
    ) AS price_quartile
FROM products;

