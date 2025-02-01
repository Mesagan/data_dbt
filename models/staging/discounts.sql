with discount_101 as (select rate_pct*0.01 from pora-academy-cohort3.jubilee_groceries.promotion
where promo_code = 101)
select * from discount_101