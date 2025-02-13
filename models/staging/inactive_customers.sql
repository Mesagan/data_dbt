with Eligible_inactive_customers AS 
(select
    c.id as customer_id,
    '10001' as promo_code 
FROM
    pora-academy-cohort3.jubilee_groceries.customer c
join
{{ ref('reactivators') }} r
on c.id = r.customer_id
WHERE
c.is_in_force = 1 
order by c.id 
)
select * from Eligible_inactive_customers
