WITH eligible_bouncers AS 
(SELECT 
    id as customer_id,
    '101' as promo_code
FROM
    pora-academy-cohort3.jubilee_groceries.customer AS C
WHERE 
    is_in_force=1
    and id not in (
        select DISTINCT customer_id from pora-academy-cohort3.jubilee_groceries.invoice)
    order by customer_id)
   select * from eligible_bouncers