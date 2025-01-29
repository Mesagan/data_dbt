with total_installment_payment AS(
     Select id, instalment_id, customer_id, mode_of_payment, 
instalment_1_amount_paid, instalment_2_amount_paid, instalment_3_amount_paid,
SUM(IFNULL (instalment_1_amount_paid, 0) + IFNULL (instalment_2_amount_paid, 0)
 + IFNULL(instalment_3_amount_paid, 0)) as Total_amount_paid_by_customer
from pora-academy-cohort3.jubilee_groceries.parent_invoice
group by id, customer_id, instalment_id,  mode_of_payment, 
instalment_1_amount_paid, instalment_2_amount_paid, instalment_3_amount_paid)
select * from total_installment_payment