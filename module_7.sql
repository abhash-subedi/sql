use my_assignment;

select count(*) as number, round(avg(price), 2), min(price), max(price) from products;

select count(*) as customers, count(city) as city, count(distinct country) as dis_country from customers;

select count(*) as compl_order from orders where status='Completed';

select round(avg(price),2) from products;

select round(100.0 * count(case when status != 'Completed' then 1 end)/count(*), 2) as not_complete_percent from orders;