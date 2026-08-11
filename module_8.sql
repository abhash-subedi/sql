use my_assignment;

select country, count(*) from customers GROUP BY country;

select category, count(*) as number_products from products group by category;

select category, round(avg(price),2) as avg_price from products group by category order by avg_price desc;

select country, count(*) as customer_per_country from customers group by country;

select status, count(*) as order_count from orders group by status order by order_count desc;

select country, segment, count(*) as number from customers group by country, segment;

select category, round(sum(price),2) as sum_price from products group by category having sum_price > 500;

select category, count(*) as exp_product from products where price > 20 group by category having count(*) > 4;