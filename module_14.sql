use my_assignment;
SELECT 
    IFNULL(p.category, 'total') AS category,
    SUM(oi.quantity * p.price) AS total
FROM order_items AS oi
JOIN products AS p 
ON oi.product_id = p.product_id
GROUP BY p.category WITH ROLLUP;

select country from customers 
where segment = 'Corporate' 
INTERSECT 
SELECT country
FROM customers
WHERE segment = 'Consumer';

SELECT product_id
FROM products
EXCEPT
SELECT product_id
FROM order_items;

SELECT DISTINCT
    country AS name, 
    'Country' AS type
FROM customers 
UNION ALL 
SELECT DISTINCT
    category AS name, 
    'Category' AS type
FROM products
ORDER BY type , name;