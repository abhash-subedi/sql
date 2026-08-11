use my_assignment;

select o.order_id,c.name, c.country from orders o join customers c using (customer_id);

select o.order_id, p.product_name, p.category from order_items o join products p using (product_id);

select p.category, sum(oi.quantity) as total_units from order_items oi 	join products p using (product_id) group by p.category;

select c.segment, count(o.order_id) as total_orders from customers c join orders o on c.customer_id = o.customer_id group by c.segment;