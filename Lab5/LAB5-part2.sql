/* 5 customer bartar bar asase counry */
with q as (
	select c.contact_name || ' - ' || c.contact_title as "customer", c.country as "country",
	sum(od.unit_price * od.quantity * (1-od.discount)) as "total_paid"
from orders o
	inner join customers c on o.customer_id = c.customer_id
	inner join order_details od on o.order_id = od.order_id
	where order_date >= to_date('1997', 'YYYY') and order_date <
to_date('1998', 'YYYY')
	group by "customer", "country"
)
select t.customer, t.country, t.total_paid
from (
	select *, row_number() over (partition by "country" order by total_paid
desc) as "rank" from q
) as t
	where "rank" <= 5;
	

/* 5 employee bartar bar asase month */
with q as (
	select e.first_name || ' ' || e.last_name as "employee", to_char(order_date, 'month') as "month",
	sum(od.unit_price * od.quantity * (1-od.discount)) as "total_paid"
from orders o
	inner join employees e on o.employee_id = e.employee_id 
	inner join order_details od on o.order_id = od.order_id
	where order_date >= to_date('1997', 'YYYY') and order_date <
to_date('1998', 'YYYY')
	group by "employee", "month"
)
select t.employee, t.month, t.total_paid
from (
	select *, row_number() over (partition by "month" order by total_paid
desc) as "rank" from q
) as t
	where "rank" <= 5;
	

/* 5 product por forosh bar asase category */
with q as (
	select p.product_name as "product", c.category_name as "category",
	sum(od.unit_price * od.quantity * (1-od.discount)) as "total_cost"
from products p
	inner join categories c on p.category_id = c.category_id 
	inner join order_details od on p.product_id = od.product_id 
	group by "product", "category"
)
select t.product, t.category, t.total_cost
from (
	select *, row_number() over (partition by "category" order by total_cost
desc) as "rank" from q
) as t
	where "rank" <= 5;