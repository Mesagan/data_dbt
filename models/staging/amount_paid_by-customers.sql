with amount_paid_by_customer AS (
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
select * from amount_paid_by_customer