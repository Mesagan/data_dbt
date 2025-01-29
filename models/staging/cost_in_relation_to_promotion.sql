with cost_of_items_purchased_with_promo_applied AS (
SELECT 
    pi.id,
    pi.customer_id,
    pr.promo_code,
    SUM(i.quantity * b.product_price) AS amount_due,
    CASE 
        WHEN pr.promo_code = 0 THEN 0
        WHEN pr.promo_code = 101 THEN SUM(i.quantity * b.product_price) * 0.05
        WHEN pr.promo_code = 1001 THEN SUM(i.quantity * b.product_price) * 0.03
        WHEN pr.promo_code = 10001 THEN SUM(i.quantity * b.product_price) * 0.07
        ELSE 0
    END AS discount
FROM
    pora-academy-cohort3.jubilee_groceries.parent_invoice pi
LEFT JOIN 
    pora-academy-cohort3.jubilee_groceries.invoice i
ON 
    pi.id = i.parent_invoice_id
LEFT JOIN 
    pora-academy-cohort3.jubilee_groceries.product_base_table b
ON 
    i.product_id = b.product_id
LEFT JOIN
    pora-academy-cohort3.jubilee_groceries.promotion pr
ON pi.promo_code = pr.promo_code
GROUP BY 
    pi.id, pi.customer_id, pr.promo_code
)
select * from cost_of_items_purchased_with_promo_applied
