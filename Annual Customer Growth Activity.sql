-- Annual Customer Growth Activity Analysis

-- Calculate Average of Monthly Active User per year
with mau as (
Select year, round(avg(Total_Customer)) as avg_MAU
from (
	select date_part('year', o.order_purchase_timestamp) as year,
 		   date_part('month', o.order_purchase_timestamp) as month,
 	count(distinct c.customer_unique_id) as Total_Customer
	from orders_dataset as o
	join customers_dataset as c 
	on o.customer_id = c.customer_id
	group by 1,2
	) sub
group by 1
order by 1),

-- Calculate Total New Customers per Year
new_cust as (
select year, count(customer_unique_id) as Total_New_Customers
from (
	select
			min(date_part('year', o.order_purchase_timestamp)) as year,
			c.customer_unique_id
	from orders_dataset as o
	join customers_dataset as c
	on c.customer_id = o.customer_id
	group by 2
	) sub
group by 1
order by 1),

-- Calculate Number of Customer Who Make Repeat Order per Year
repeat as (
select year, count(customer_unique_id) as Total_Repeat_Order
from (
	select date_part('year', o.order_purchase_timestamp) as year,
	c.customer_unique_id,
	count(o.order_id) as total_order
	from orders_dataset as o
	join customers_dataset as c
	on c.customer_id = o.customer_id
	group by 1, 2
	having count(2) > 1
	)sub
group by 1
order by 1),

-- Calculate Average of Customers Order Frequency per Year
freq as (
select year, round(avg(Order_Freq)) as avg_Order_Freq
from (
	select date_part('year', o.order_purchase_timestamp) as year,
	c.customer_unique_id,
	count(o.order_id) as Order_Freq
	from orders_dataset as o
	join customers_dataset as c
	on c.customer_id = o.customer_id
	group by 1, 2
	)sub
group by 1
order by 1)

-- Combine All Metrics
select m.year, m.avg_MAU, n.Total_New_Customers, r.Total_Repeat_Order, f.avg_Order_Freq
from mau as m
join new_cust as n on m.year = n.year
join repeat as r on m.year = r.year
join freq as f on m.year = f.year
;