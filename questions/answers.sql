
-- PART 2a

-- first question

select
	p.id as product_id,
	p."name" as product_name,
	COUNT(*) as num_times_in_successful_orders
from
	alt_school.events e
join alt_school.customers c on
	e.customer_id = c.customer_id
join alt_school.orders o on
	c.customer_id = o.customer_id
join alt_school.line_items li on
	o.order_id = li.order_id
join alt_school.products p on
	li.item_id = p.id
where
	o.status = 'success'
	and e.event_data->>'event_type' = 'add_to_cart'
group by
	p.id,
	p."name"
order by
	num_times_in_successful_orders desc
limit 1;


-- second question

select
	c.customer_id,
	c.location,
	sum(p.price) as total_spend
from
	alt_school.customers c
join alt_school.orders o on
	c.customer_id = o.customer_id
join alt_school.line_items li on
	o.order_id = li.order_id
join alt_school.products p on
	li.item_id = p.id
group by
	c.customer_id,
	c.location
order by
	total_spend desc
limit 5;



-- PART 2b

-- first question

select
	c.location as country,
	count(o.status) as checkout_count
from
	alt_school.events e
join alt_school.customers c on
	e.customer_id = c.customer_id
join alt_school.orders o on
	c.customer_id = o.customer_id
where
	o.status = 'success'
group by
	c."location" ,
	o.status
order by
	checkout_count desc;

-- second question

select
	e.customer_id,
	COUNT(*) as num_events
from
	alt_school.events e
join 
    alt_school.orders o on
	e.customer_id = o.customer_id
where
	(event_data->>'event_type' = 'add_to_cart'
		or event_data->>'event_type' = 'remove_from_cart')
	and o.status = 'cancelled'
	and e.event_timestamp < o.checked_out_at
group by
	e.customer_id;



-- third question

SELECT 
    AVG(num_visits) AS average_visits
FROM (
    SELECT 
        e.customer_id,
        COUNT(*) AS num_visits
    FROM 
        alt_school.events e
    JOIN 
        alt_school.orders o ON e.customer_id = o.customer_id
    WHERE 
        event_data->>'event_type' = 'visit' 
        AND o.status = 'success'
    GROUP BY 
        e.customer_id
);

