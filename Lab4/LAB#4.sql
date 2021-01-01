/*1*/
select * from "Northwind".public.region r;

/*2*/
/*a*/
select r.region_description , t.territory_description 
from "Northwind".public.region r inner join "Northwind".public.territories t on r.region_id = t.region_id;
/*b*/
select r.region_description , count(et.employee_id)  
from "Northwind".public.region r inner join "Northwind".public.territories t on r.region_id = t.region_id
inner join "Northwind".public.employee_territories et on t.territory_id = et.territory_id 
group by r.region_description; 

/*3*/
select r.region_description , t.territory_description , count(et.employee_id)  
from "Northwind".public.region r inner join "Northwind".public.territories t on r.region_id = t.region_id
inner join "Northwind".public.employee_territories et on t.territory_id = et.territory_id 
group by r.region_description , t.territory_description;

/*4*/
select e.first_name , e.last_name 
from "Northwind".public.employees e inner join "Northwind".public.employee_territories et on e.employee_id = et.employee_id 
inner join "Northwind".public.territories t on et.territory_id = t.territory_id
where t.territory_description = 'Orlando';

/*5*/
select count(*)
from "Northwind".public.customers c 
where c.country <> 'USA';

/*6*/
select p.product_name , p.units_in_stock 
from "Northwind".public.products p 
where p.units_in_stock < p.reorder_level 
order by p.units_in_stock ;

/*7*/
select od.unit_price * (1-od.discount) as price
from "Northwind".public.orders o 
inner join "Northwind".public.order_details od on o.order_id = od.order_id 
where o.order_id = 10412;

/*8*/
select p.product_id , p.product_name
from "Northwind".public.orders o inner join "Northwind".public.order_details od on o.order_id = od.order_id
inner join "Northwind".public.products p on p.product_id = od.product_id 
where o.order_date > '1996-07-01' and o.order_date < '1996-08-01'
group by p.product_id 
order by sum(od.quantity) desc
limit 1;

/*9*/
select o.ship_country , sum(od.quantity) 
from "Northwind".public.orders o inner join "Northwind".public.order_details od on o.order_id = od.order_id
where o.ship_country <> 'USA'
group by o.ship_country;

/*10*/
select c.category_name , sum(od.quantity) 
from "Northwind".public.orders o inner join "Northwind".public.order_details od on o.order_id = od.order_id
inner join "Northwind".public.products p on p.product_id = od.product_id 
inner join "Northwind".public.categories c on c.category_id = p.category_id 
where o.ship_country = 'France'
group by c.category_name ;

/*11*/
select c.customer_id 
from "Northwind".public.customers c 
where c.fax is NULL;

/*12*/
select o.employee_id 
from "Northwind".public.orders o 
where date_part('year', o.order_date) = '1996'
group by o.employee_id 
order by count(*)
limit 3;

/*13*/
select distinct s.company_name 
from "Northwind".public.orders o inner join "Northwind".public.shippers s on o.ship_via = s.shipper_id 
where o.ship_country = 'France' or o.ship_country = 'Germany';

/*14*/
with germany_categories as (
	select distinct c.category_name 
	from "Northwind".public.orders o inner join "Northwind".public.order_details od on o.order_id = od.order_id 
	inner join "Northwind".public.products p on od.product_id = p.product_id 
	inner join "Northwind".public.categories c on c.category_id = p.category_id 
	where o.ship_country = 'Germany'
)
select c2.category_name
from "Northwind".public.categories c2
where c2.category_name not in (select category_name from germany_categories);

/*15*/
update "Northwind".public.employee_territories 
set territory_id = (
	select t.territory_id 
	from "Northwind".public.territories t 
	where t.territory_description = 'New York'
	limit 1
)
where employee_id = (
	select et.employee_id
	from "Northwind".public.employee_territories et
	inner join "Northwind".public.employees e on et.employee_id = e.employee_id 
	inner join "Northwind".public.territories t on t.territory_id = et.territory_id 
	where t.territory_description = 'Orlando'
)
and territory_id = (
	select et.territory_id 
	from "Northwind".public.employee_territories et
	inner join "Northwind".public.employees e on et.employee_id = e.employee_id 
	inner join "Northwind".public.territories t on t.territory_id = et.territory_id 
	where t.territory_description = 'Orlando'
);

/*16*/
create view employees_age as
select *, floor(EXTRACT(DAY FROM NOW()-e.birth_date)/365) AS Age
from "Northwind".public.employees e ;

select ea.employee_id, ea.age from employees_age ea;

select r.region_description, avg(ea.age)
from "Northwind".public.region r
inner join "Northwind".public.territories t on r.region_id = t.region_id 
inner join "Northwind".public.employee_territories et on et.territory_id = t.territory_id 
inner join employees_age ea on ea.employee_id = et.employee_id 
group by r.region_description ;

/*17*/
select c.contact_name || ' - ' || c.contact_title as "customer",
to_char(order_date, 'month') as "month", sum(od.unit_price * od.quantity * (1-
od.discount)) as "total_paid"
from orders o
inner join customers c on o.customer_id = c.customer_id
inner join order_details od on o.order_id = od.order_id
where order_date >= to_date('1997', 'YYYY') and order_date <
to_date('1998', 'YYYY')
group by "customer", "month";

with q as (
select c.contact_name || ' - ' || c.contact_title as "customer",
to_char(order_date, 'month') as "month", sum(od.unit_price * od.quantity * (1-
od.discount)) as "total_paid"
from orders o
inner join customers c on o.customer_id = c.customer_id
inner join order_details od on o.order_id = od.order_id
where order_date >= to_date('1997', 'YYYY') and order_date <
to_date('1998', 'YYYY')
group by "customer", "month"
)
select t.customer, t.month, t.total_paid
from (
select *, row_number() over (partition by "month" order by total_paid
desc) as "rank" from q
) as t
where "rank" <= 5;




