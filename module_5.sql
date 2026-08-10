use my_assignment;

select count(*), count(city) from customers;

select * from customers;

update customers set city = NULL where city = 'Unknown';

SET SQL_SAFE_UPDATES = 0;

update customers set city = 'Unknown' where city is null;

select * from customers;

update customers set city = 'Unknown' where city is null;


select customer_id / nullif(customer_id, 0) from customers;

update customers set customer_id = replace(lower(customer_id), 'c', '');

alter table customers modify COLUMN customer_id int;

