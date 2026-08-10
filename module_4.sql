use my_assignment;

select * from customers where country in ('Nepal', 'India', 'Germany');

select * from products where price between 100 and 300;

select * from products where product_name like '%desk%';

select * from products where product_name like 'Water%';

select * from orders where status not in ('Returned','Cancelled');