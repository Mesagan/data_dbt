select penalty_pct*0.01 as penalty_1
from pora-academy-cohort3.jubilee_groceries.installment
where number_of_instalments in (1,2)