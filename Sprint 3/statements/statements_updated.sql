##### STATEMENTS#####


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
WHERE financial_event_group_start > "2022-01-01" AND original_total_currency= 'USD'AND processing_status= 'Closed'
GROUP BY mp_sup_key 
ORDER BY avg_time_unpaid DESC;

#Find maximum start date and end date
SELECT MAX(financial_event_group_start) AS FINANCIAL_EVENT_START_DATE_MAX , MAX(financial_event_group_end) AS FINANCIAL_EVENT_END_DATE_MAX
FROM `bigqueryexport-183608.amazon.statements`;

#Find number of dates in an event by ordering descending end date
SELECT financial_event_group_id , financial_event_group_start, financial_event_group_end, DATE_DIFF(financial_event_group_end , financial_event_group_start, DAY ) AS NO_OF_DAYS_IN_AN_EVENT
FROM `bigqueryexport-183608.amazon.statements`
ORDER BY financial_event_group_end DESC ;

#from 2023 
SELECT financial_event_group_id , financial_event_group_start, financial_event_group_end, DATE_DIFF(financial_event_group_end , financial_event_group_start, DAY ) AS NO_OF_DAYS_IN_AN_EVENT
FROM `bigqueryexport-183608.amazon.statements`
WHERE EXTRACT(YEAR FROM financial_event_group_start) = 2023
ORDER BY financial_event_group_end DESC ;


# GROUP BY EVENT IN 2023
SELECT financial_event_group_id, COUNT(*) AS COUNTER FROM `bigqueryexport-183608.amazon.statements` 
WHERE EXTRACT(YEAR FROM financial_event_group_start) = 2023
GROUP BY financial_event_group_id 
ORDER BY COUNTER DESC ;

#DISTINCT
SELECT DISTINCT financial_event_group_id, mp_sup_key, original_total_amount, original_total_currency, financial_event_group_start, financial_event_group_end FROM `bigqueryexport-183608.amazon.statements`
WHERE EXTRACT(YEAR FROM financial_event_group_start) IN (2021 ,2022, 2023);

#GROUP BY STATEMENTID, SELLER
SELECT financial_event_group_id AS STATEMENT_ID , mp_sup_key AS SELLER_ID , SUM(original_total_amount) AS TOTAL_ORIGINAL_AMOUNT , MAX(financial_event_group_end) AS END_DATE
FROM `bigqueryexport-183608.amazon.statements` 
WHERE EXTRACT(YEAR FROM financial_event_group_start) IN (2021 ,2022, 2023) AND original_total_currency= 'USD'
GROUP BY financial_event_group_id , mp_sup_key
ORDER BY END_DATE ;

#INNERJOIN 
SELECT financial_event_group_id AS STATEMENT_ID , mp_sup_key AS SELLER_ID , SUM(original_total_amount) AS TOTAL_ORIGINAL_AMOUNT , MAX(financial_event_group_end) AS END_DATE
FROM `bigqueryexport-183608.amazon.statements` 
WHERE EXTRACT(YEAR FROM financial_event_group_start) IN (2021 ,2022, 2023) AND original_total_currency= 'USD'
GROUP BY financial_event_group_id , mp_sup_key


#Worked inner join
SELECT A.financial_event_group_id AS STATEMENT_ID, A.mp_sup_key AS SELLER_ID, A.original_total_amount AS ORIGINAL_TOTAL_AMOUNT, A.processing_status AS PROCESSING_STATUS,  B.END_DATE AS END_DATE
FROM `bigqueryexport-183608.amazon.statements` A
INNER JOIN 
(SELECT financial_event_group_id AS STATEMENT_ID , mp_sup_key AS SELLER_ID, MAX(financial_event_group_end) AS END_DATE 
FROM `bigqueryexport-183608.amazon.statements` 
WHERE EXTRACT(YEAR FROM financial_event_group_start) IN (2021 ,2022, 2023) AND original_total_currency= 'USD'
GROUP BY financial_event_group_id , mp_sup_key
ORDER BY financial_event_group_id) B
ON A.financial_event_group_id= B.STATEMENT_ID AND A.mp_sup_key= B.SELLER_ID
ORDER BY END_DATE;

#Complex
SELECT C.financial_event_group_id AS STATEMENT_ID, C.mp_sup_key AS SELLER_ID, C.original_total_amount AS ORIGINAL_AMOUNT, C.processing_status AS PROCESSING_STATUS,  D.END_DATE AS END_DATE , D.AVERAGE_AMOUNT
FROM `bigqueryexport-183608.amazon.statements` C
INNER JOIN 
(SELECT END_DATE AS END_DATE, AVG(ORIGINAL_AMOUNT) AS AVERAGE_AMOUNT
FROM 
(SELECT A.financial_event_group_id AS STATEMENT_ID, A.mp_sup_key AS SELLER_ID, A.original_total_amount AS ORIGINAL_AMOUNT, A.processing_status AS PROCESSING_STATUS,  B.END_DATE AS END_DATE
FROM `bigqueryexport-183608.amazon.statements` A
INNER JOIN 
(SELECT financial_event_group_id AS STATEMENT_ID , mp_sup_key AS SELLER_ID, MAX(financial_event_group_end) AS END_DATE 
FROM `bigqueryexport-183608.amazon.statements` 
WHERE EXTRACT(YEAR FROM financial_event_group_start) IN (2021 ,2022, 2023) AND original_total_currency= 'USD'
GROUP BY financial_event_group_id , mp_sup_key
ORDER BY financial_event_group_id) B
ON A.financial_event_group_id= B.STATEMENT_ID AND A.mp_sup_key= B.SELLER_ID
ORDER BY END_DATE)
GROUP BY END_DATE) D
ON C.financial_event_group_end= D.END_DATE
ORDER BY STATEMENT_ID ;
