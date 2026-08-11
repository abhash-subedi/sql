select price, product_name from products where price > (select avg(price) from products);

select name from customers where customer_id in (select customer_id from orders where status = 'Returned');

select category, avg(price) from products group by category;

select product_name, price from products where price < (select min(price) from products where category = 'Electronics');

