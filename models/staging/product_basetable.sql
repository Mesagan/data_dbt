
with product_basetable AS (
 select 
  p.id AS product_id, 
  p.name as product_name, 
  p.selling_price as product_price,
  p.currency as currency,
  p.unit_of_measurement_id as uom_id,
  c.name as category_name,
  s.name as sub_category_name,
 from 
  pora-academy-cohort3.jubilee_groceries.product p
 left join 
  pora-academy-cohort3.jubilee_groceries.category c
  --pora-academy-cohort3.jubilee_groceries.sub_category s
 on p.id = c.id
 left join
  pora-academy-cohort3.jubilee_groceries.sub_category s
  --pora-academy-cohort3.jubilee_groceries.unit_of_measurement u
on p.sub_category_id = s.id)
--left join 
 -- pora-academy-cohort3.jubilee_groceries.unit_of_measurement u
   --pora-academy-cohort3.jubilee_groceries.category c
--on c.id = s.category_id )

SELECT 
 p.product_id, 
 p.product_name, 
 p.product_price,
 p.currency as currency,
 u.short_name as uom,
 p.category_name,
 p.sub_category_name
FROM 
 product_basetable p
left join 
 pora-academy-cohort3.jubilee_groceries.unit_of_measurement u
on u.id = p.uom_id