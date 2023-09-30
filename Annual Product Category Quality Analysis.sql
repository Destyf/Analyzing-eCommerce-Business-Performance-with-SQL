-- Annual Product Category Quality Analysis

-- Table Total Revenue per Year
create table total_revenue as (
	select date_part('year',o.order_purchase_timestamp) as year,
		round(sum(oi.price + oi.freight_value)) as revenue
	from orders_dataset as o
	join order_item_dataset as oi
		on o.order_id = oi.order_id
	where o.order_status = 'delivered'
	group by 1
	order by 1);
select * from total_revenue

-- Table Total Number of Canceled Order per Year
create table total_cancel_order as (
	select date_part('year',order_purchase_timestamp) as year,
		count(order_status) as total_cancel_order
	from orders_dataset
	where order_status = 'canceled'
	group by 1
	order by 1);
select * from total_cancel_order

-- Table Top Product Category with Highest Total Revenue per Year
create table top_product_category as (
	select year, top_product_category, revenue
	from(
		select date_part('year',o.order_purchase_timestamp) as year,
			p.product_category_name as top_product_category,
			round(sum(oi.price + oi.freight_value)) as revenue,
			rank()over(partition by date_part('year',o.order_purchase_timestamp) order by round(sum(oi.price + oi.freight_value))desc) as ranking
		from orders_dataset as o
		join order_item_dataset as oi
			on o.order_id = oi.order_id
		join product_dataset as p
			on oi.product_id = p.product_id
		where o.order_status = 'delivered'
		group by 1, 2
		order by 1)sub
	where ranking = 1);
select * from top_product_category;

-- Table Top Product Category with Highest Total Canceled Order per Year
create table top_canceled_product as (
	select year, top_canceled_product, canceled
	from(
		select date_part('year',o.order_purchase_timestamp) as year,
			p.product_category_name as top_canceled_product,
			count(order_status) as canceled,
			rank()over(partition by date_part('year',o.order_purchase_timestamp) order by count(order_status) desc) as ranking
		from orders_dataset as o
		join order_item_dataset as oi
			on o.order_id = oi.order_id
		join product_dataset as p
			on oi.product_id = p.product_id
		where o.order_status = 'canceled'
		group by 1, 2
		order by 1)sub
	where ranking = 1);
select * from top_canceled_product;

-- Combine All Tables
select tr.year,
	tr.total_revenue,
	co.total_cancel_order,
	tp.top_product_category,
	tp.revenue,
	tc.top_canceled_product,
	tc.canceled
from total_revenue as tr
join total_cancel_order as co
	on tr.year = co.year
join top_product_category as tp
	on co.year = tp.year
join top_canceled_product as tc
	on tp.year = tc.year
order by 1,2,3,4,5,6,7;