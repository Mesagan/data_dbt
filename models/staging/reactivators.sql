with Reactivators AS
(select 
    customer_id
    FROM pora-academy-cohort3.jubilee_groceries.invoice
    group by customer_id
    HAVING
    max(created_on) < '2024-08-01'
    )
    select * from Reactivators