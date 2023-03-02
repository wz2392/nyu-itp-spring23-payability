SELECT count(distinct mp_sup_key)
FROM
  (
    SELECT amount, currency, posted_date, type,SPLIT(SPLIT(path_golden, '/')[OFFSET(3)], '=')[OFFSET(1)] AS mp_sup_key 
  FROM `bigqueryexport-183608.amazon.loanservicingevent_historical` 
  ) 
WHERE DATE(posted_date) >= "2022-01-01" and DATE(posted_date) <= "2022-12-31"
