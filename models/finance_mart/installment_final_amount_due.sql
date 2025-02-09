final_amount_due AS (
SELECT 
    pi.id,
    pi.customer_id,
    pi.created_on,
    ist.number_of_instalments AS no_of_instalments,
    SUM(i.quantity * b.product_price) AS Original_amount_due,
    CASE
        WHEN ist.number_of_instalments = 1 AND DATE_DIFF(pi.instalment_1_payment_date, pi.created_on, DAY) > 1 THEN 
            SUM(i.quantity * b.product_price) + (SUM(i.quantity * b.product_price) * 0.005)
        
        WHEN ist.number_of_instalments = 2 THEN 
            CASE 
                WHEN DATE_DIFF(pi.instalment_2_payment_date, pi.created_on, DAY) > 60 THEN 
                    SUM(i.quantity * b.product_price) + (SUM(i.quantity * b.product_price) * 0.01) + (SUM(i.quantity * b.product_price) * 0.005)
                ELSE 
                    SUM(i.quantity * b.product_price) + (SUM(i.quantity * b.product_price) * 0.01)
            END
        
        WHEN ist.number_of_instalments = 3 THEN 
            CASE 
                WHEN DATE_DIFF(pi.instalment_3_payment_date, pi.created_on, DAY) > 90 THEN 
                    SUM(i.quantity * b.product_price) + (SUM(i.quantity * b.product_price) * 0.015) + (SUM(i.quantity * b.product_price) * 0.01)
                ELSE 
                    SUM(i.quantity * b.product_price) + (SUM(i.quantity * b.product_price) * 0.015)
            END
        
        ELSE 
            SUM(i.quantity * b.product_price)
    END AS final_amount_due
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
    pora-academy-cohort3.jubilee_groceries.installment ist
ON pi.instalment_id = ist.id
GROUP BY 
    pi.id, pi.customer_id, pi.created_on, ist.number_of_instalments, 
    pi.instalment_1_payment_date, pi.instalment_2_payment_date, pi.instalment_3_payment_date
),
