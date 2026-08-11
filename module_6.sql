use my_assignment;

select product_name, price from products ORDER BY price DESC;

select product_name, price from products ORDER BY price ASC;

select DISTINCT country from customers;

select country, name from customers order by country, name;

select product_name from products limit 5 offset 5;