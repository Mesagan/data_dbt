with cost_joins as (select
    EXTRACT(YEAR from fad.created_on) Year,
    FORMAT_TIMESTAMP('%B', fad.created_on) Month,
    ROUND(SUM(fad.final_amount_due),2) Revenue,
    ROUND(SUM(fad.final_amount_due) - SUM(pr.discount),2) Net_Revenue,
    SUM(oc.Quantity) as Sales_Volume,
    ROUND(SUM(pr.discount),2) Discount, 
from  
    {{ ref('final_amount_due') }} fad
join 
    {{ ref('original_cost_of_item') }} oc
on fad.id = oc.id
join 
    {{ ref('cost_in_relation_to_promotion') }} pr
on fad.id = pr.id
join 
    {{ ref('amount_paid_by-customers') }} fap
on  fad.id = fap.id
group by 
    Year, Month
order by 
   MIN(fad.created_on)
   )
select * from cost_joins

   