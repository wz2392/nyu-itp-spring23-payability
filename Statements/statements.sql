#IDENTIFY THE TOP SELLERS FOR A GIVEN TIME PERIOD
SELECT mp_sup_key, SUM(original_total_amount) AS amount_paid FROM `bigqueryexport-183608.amazon.statements` 
WHERE financial_event_group_start > "2023-01-01" AND original_total_currency= 'USD'
GROUP BY mp_sup_key 
ORDER BY amount_paid DESC;


#IDENTIFY THE SELLERS HAVING MANY OPEN TRANSACTIONS AND NOT BEING PAID  
SELECT mp_sup_key, COUNT(*) AS number_of_open_transactions, SUM(original_total_amount) AS amount_due_from_amazon FROM `bigqueryexport-183608.amazon.statements` 
WHERE financial_event_group_start > "2023-01-01" AND original_total_currency= 'USD'AND processing_status= 'Open'
GROUP BY mp_sup_key 
ORDER BY amount_due_from_amazon DESC

#IDENTIFY THE AVERAGE NUMBER OF DAYS THE SELLERS ARE BEING UNPAID
SELECT mp_sup_key, AVG(DATE_DIFF(financial_event_group_end, financial_event_group_start, DAY)) AS avg_time_unpaid FROM `bigqueryexport-183608.amazon.statements` 
WHERE financial_event_group_start > "2023-01-01" AND original_total_currency= 'USD'AND processing_status= 'Closed'
GROUP BY mp_sup_key 
ORDER BY avg_time_unpaid DESC;

#FOR THE LAST ONE YEAR
SELECT mp_sup_key, AVG(DATE_DIFF(financial_event_group_end, financial_event_group_start, DAY)) AS avg_time_unpaid FROM `bigqueryexport-183608.amazon.statements` 
WHERE financial_event_group_start > "2023-01-01" AND original_total_currency= 'USD'AND processing_status= 'Closed'
GROUP BY mp_sup_key 
ORDER BY avg_time_unpaid DESC;




