-- Annual Payment Type Usage Analysis

-- The total usage of each payment method, sorted by the most favored over all time
with tu as (select payment_type,
	count(payment_type) as total_usage
from order_payments_detail
group by 1
order by 2 desc),

-- Detailed information about the total usage of each payment method per year
u as (select payment_type,
	sum(case when year = 2016 then total_usage else 0 end) y2016,
	sum(case when year = 2017 then total_usage else 0 end) y2017,
	sum(case when year = 2018 then total_usage else 0 end) y2018
from (
	select date_part('year',o.order_purchase_timestamp) as year,
		p.payment_type,
		count(p.payment_type) as total_usage
	from orders_dataset as o
	join order_payments_detail as p
	on o.order_id = p.order_id
	group by 1,2
	order by 1)sub
group by 1
order by 2 desc)

select u.payment_type,
	tu.total_usage,
	u.y2016,
	u.y2017,
	u.y2018
from u
join tu
	on u.payment_type = tu.payment_type
