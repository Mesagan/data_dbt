Select  pi.customer_id, pi.mode_of_payment,
 pi.instalment_id, 
pi.instalment_1_amount_paid, pi.instalment_2_amount_paid, pi.instalment_3_amount_paid,
--fad.Original_amount_due,
od.days_overdue,
fad.final_amount_due,
SUM(tip.Total_amount_paid_by_customer) as Total_amount_paid,
(fad.final_amount_due - SUM(tip.Total_amount_paid_by_customer)) As Receivables
 from pora-academy-cohort3.jubilee_groceries.parent_invoice pi
join
total_installment_payment tip on pi.id = tip.id
join
final_amount_due fad on pi.id=fad.id
join
overdue_date od on pi.id = od.id
where final_amount_due > Total_amount_paid_by_customer
--And pi.customer_id = 'cus-62613'
Group by pi.customer_id, pi.mode_of_payment, pi.instalment_id, 
fad.final_amount_due, fad.Original_amount_due, od.days_overdue,
pi.instalment_1_amount_paid, pi.instalment_2_amount_paid, pi.instalment_3_amount_paid
order by od.days_overdue Desc;