select * from {{ ref('eligible_bouncers') }}
union all 
select * from {{ ref('bulk_buzzers') }}
union all
select * from {{ ref('inactive_customers') }}
order by customer_id, promo_code