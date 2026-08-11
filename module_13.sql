SELECT p.product_name, p.price, p.category FROM products p
WHERE p.price > (SELECT AVG(x.price) FROM products x WHERE x.category = p.category);

SELECT c.*
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id
);

SELECT p.*
FROM products p
WHERE NOT EXISTS (
    SELECT 1 
    FROM order_items oi 
    WHERE oi.product_id = p.product_id
);

SELECT c.*
FROM customers c
WHERE NOT EXISTS (
    SELECT 1 
    FROM orders o 
    WHERE o.customer_id = c.customer_id 
      AND o.status = 'Cancelled'
);