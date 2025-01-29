with September_average AS (
    select 
    c.id,
     avg(i.quantity) september_average
    from
    pora-academy-cohort3.jubilee_groceries.customer c
    join
    pora-academy-cohort3.jubilee_groceries.invoice i
    on i.customer_id = c.id
    where 
    c.is_in_force = 1 AND 
    i.created_on BETWEEN '2024-09-01' AND '2024-09-30'
    group by c.id
   )
   select * from September_average