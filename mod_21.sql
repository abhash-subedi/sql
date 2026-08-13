WITH monthly_revenue_cte AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY sales_month ASC
    ) AS running_total_revenue
FROM monthly_revenue_cte
ORDER BY sales_month;

WITH monthly_revenue_cte AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    sales_month,
    monthly_revenue,
    SUM(monthly_revenue) OVER (
        ORDER BY sales_month ASC
    ) AS running_total_revenue,
    ROUND(
        AVG(monthly_revenue) OVER (
            ORDER BY sales_month ASC
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_3_month
FROM monthly_revenue_cte
ORDER BY sales_month;

WITH monthly_revenue_cte AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
        SUM(oi.quantity * p.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)
SELECT 
    sales_month,
    monthly_revenue,
    LAG(monthly_revenue, 1) OVER (
        ORDER BY sales_month ASC
    ) AS previous_month_revenue,
    ROUND(
        (monthly_revenue - LAG(monthly_revenue, 1) OVER (ORDER BY sales_month ASC)) 
        / LAG(monthly_revenue, 1) OVER (ORDER BY sales_month ASC) * 100, 
        2
    ) AS mom_growth_pct,
    SUM(monthly_revenue) OVER (
        ORDER BY sales_month ASC
    ) AS running_total_revenue,
    ROUND(
        AVG(monthly_revenue) OVER (
            ORDER BY sales_month ASC
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
    ) AS moving_avg_3_month
FROM monthly_revenue_cte
ORDER BY sales_month;

WITH category_revenue_cte AS (
    SELECT 
        p.category,
        SUM(oi.quantity * p.price) AS category_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category
)
SELECT 
    category,
    category_revenue,
    SUM(category_revenue) OVER () AS grand_total_revenue,
    ROUND(
        (category_revenue / SUM(category_revenue) OVER ()) * 100, 
        2
    ) AS revenue_share_pct
FROM category_revenue_cte
ORDER BY category_revenue DESC;

SELECT 
    category,
    product_id,
    product_name,
    price,
    FIRST_VALUE(product_name) OVER (
        PARTITION BY category 
        ORDER BY price DESC
    ) AS top_priced_product,
    FIRST_VALUE(price) OVER (
        PARTITION BY category 
        ORDER BY price DESC
    ) AS max_category_price
FROM products
ORDER BY category, price DESC;