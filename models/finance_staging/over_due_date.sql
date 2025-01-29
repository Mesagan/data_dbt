with over_due_date AS (
    SELECT i.id, i.customer_id, i.created_on, i.instalment_1_payment_date, 
i.instalment_2_payment_date, i.instalment_3_payment_date,
CASE 
WHEN ist.number_of_instalments = 1 THEN DATE_DIFF(instalment_1_payment_date, i.created_on, DAY) 
        WHEN ist.number_of_instalments = 2 THEN DATE_DIFF(instalment_2_payment_date, i.created_on, DAY) 
        WHEN ist.number_of_instalments = 3 THEN DATE_DIFF(instalment_3_payment_date, i.created_on, DAY) 
        ELSE 0
    END AS days_overdue
from pora-academy-cohort3.jubilee_groceries.parent_invoice i
JOIN
pora-academy-cohort3.jubilee_groceries.installment ist
ON  i.instalment_id = ist.id
group by i.id, customer_id, i.created_on, ist.number_of_instalments, 
instalment_1_payment_date, instalment_2_payment_date, instalment_3_payment_date
order by days_overdue Desc)
select * from over_due_date