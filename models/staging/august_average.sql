with August_average AS (
    select 
    c.id,
    avg(i.quantity) august_average
    from
    pora-academy-cohort3.jubilee_groceries.customer c
    join
    pora-academy-cohort3.jubilee_groceries.invoice i
    on i.customer_id = c.id
    where 
    c.is_in_force = 1 AND 
    i.created_on BETWEEN '2024-08-01' AND '2024-08-31'
    group by c.id
    )
    select * from August_average