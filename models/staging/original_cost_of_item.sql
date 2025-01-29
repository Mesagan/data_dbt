With original_cost_of_items_purchased AS (
SELECT 
    pi.id,
    pi.customer_id,
    SUM(i.quantity) Quantity,
    SUM(i.quantity * b.product_price) AS Base_Amount
FROM
    pora-academy-cohort3.jubilee_groceries.parent_invoice pi
LEFT JOIN 
    pora-academy-cohort3.jubilee_groceries.invoice i
ON 
    pi.id = i.parent_invoice_id and pi.customer_id = i.customer_id
LEFT JOIN 
    pora-academy-cohort3.jubilee_groceries.product_base_table b
ON 
    i.product_id = b.product_id
GROUP BY 
    pi.id, pi.customer_id)
select * from original_cost_of_items_purchased