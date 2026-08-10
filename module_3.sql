use my_assignment;

SELECT * FROM products WHERE price > 200;

select * from customers where country = 'USA';

select * from products where category = 'Electronics' and price < 100;

select * from customers where segment = 'Corporate' and country in ('Nepal', 'India');

select * from orders;

select * from orders where status != 'Completed';
