SELECT UPPER(name), LENGTH(name)
FROM customers;

SELECT CONCAT(name, ' (', country, ')') AS name_country
FROM customers;

SELECT SUBSTR(product_name, 1, 3)
FROM products;

SELECT REPLACE(name, '.', '') AS no_periods
FROM customers;

SELECT 
    LENGTH(name), name
FROM customers
WHERE LENGTH(name) > 8;


use my_assignment;