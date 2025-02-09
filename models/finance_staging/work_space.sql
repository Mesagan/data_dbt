
 --FINAL_AMOUNT_DUE(INSTALMENT_AND_PENALTY_FACTORED)--

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
SQL


 --INSTALMENT_AND_PENALTY_FACTORED--
interest_on_instalment AS (
SELECT 
    pi.id,
    pi.customer_id,
    pi.created_on,
    ist.number_of_instalments AS no_of_instalments,
    SUM(i.quantity * b.product_price) AS Original_amount_due,
    CASE
        WHEN ist.number_of_instalments = 1 AND DATE_DIFF(pi.instalment_1_payment_date, pi.created_on, DAY) > 1 THEN 
            SUM(i.quantity * b.product_price) * 0.005
        
        WHEN ist.number_of_instalments = 2 THEN 
            CASE 
                WHEN DATE_DIFF(pi.instalment_2_payment_date, pi.created_on, DAY) > 60 THEN 
                     (SUM(i.quantity * b.product_price) * 0.01) + (SUM(i.quantity * b.product_price) * 0.005)
                ELSE 
                     SUM(i.quantity * b.product_price) * 0.01
            END
        
        WHEN ist.number_of_instalments = 3 THEN 
            CASE 
                WHEN DATE_DIFF(pi.instalment_3_payment_date, pi.created_on, DAY) > 90 THEN 
                     (SUM(i.quantity * b.product_price) * 0.015) + (SUM(i.quantity * b.product_price) * 0.01)
                ELSE 
                    SUM(i.quantity * b.product_price) * 0.015
            END
        
        ELSE 0
            
    END AS interest_on_instalment
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

    --COST IN RELATION TO PROMOTION-- 

 cost_of_items_purchased_with_promo_applied AS (
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
),


--AMOUNT PAID BY CUSTOMERS--
amount_paid_by_customer AS (
    SELECT 
    pi.id,
    pi.customer_id,
    pi.instalment_1_amount_paid,
    pi.instalment_2_amount_paid,
    pi.instalment_3_amount_paid,
    CASE
        WHEN ist.number_of_instalments = 1 THEN pi.instalment_1_amount_paid
        WHEN ist.number_of_instalments = 2 THEN pi.instalment_1_amount_paid + pi.instalment_2_amount_paid
        WHEN ist.number_of_instalments = 3 THEN pi.instalment_1_amount_paid + pi.instalment_2_amount_paid + pi.instalment_3_amount_paid
        ELSE 0
    END AS total_amount_paid_by_customer
FROM
    pora-academy-cohort3.jubilee_groceries.parent_invoice pi
LEFT JOIN
    pora-academy-cohort3.jubilee_groceries.installment ist
ON pi.instalment_id = ist.id)
SQL


SELECT
    EXTRACT(YEAR FROM fad.created_on) Year,
    FORMAT_TIMESTAMP('%B', fad.created_on) Month,
   Sum(fap.total_amount_paid_by_customer) amount_paid_by_customer, 
  Sum(fad.final_amount_due) Revenue,
  Sum(pr.discount) Discount,
  Sum(fad.final_amount_due)-Sum(pr.discount) Net_revenue,
  Sum(int.interest_on_instalment) Interest_on_instalment,
   Sum(fad.final_amount_due)-Sum(pr.discount) + Sum(int.interest_on_instalment) Margin
FROM   
    final_amount_due fad
JOIN 
    original_cost_of_items_purchased oc
ON fad.id = oc.id
JOIN 
    cost_of_items_purchased_with_promo_applied pr
ON fad.id = pr.id
JOIN 
    amount_paid_by_customer fap
ON  fad.id = fap.id
JOIN
interest_on_instalment int
ON fap.id = int.id 
GROUP BY 
    Year, Month
ORDER BY 
   MIN(fad.created_on);