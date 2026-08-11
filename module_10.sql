use my_assignment;

select c.customer_id, c.name from customers c left join orders o on c.customer_id = o.customer_id;

select c.customer_id, c.name from customers c left join orders o on c.customer_id = o.customer_id where o.order_id is null;

select p.product_name from products p left join order_items oi on p.product_id = oi.product_id where oi.order_id is null;

select c.name, count(o.order_id) from customers c left join orders o on c.customer_id = o.customer_id and o.status = 'Completed'
group by c.customer_id, c.name;
