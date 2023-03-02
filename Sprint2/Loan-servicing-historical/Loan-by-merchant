SELECT *
FROM
  (
    SELECT amount, currency, posted_date, type,SPLIT(SPLIT(path_golden, '/')[OFFSET(3)], '=')[OFFSET(1)] AS mp_sup_key 
  FROM `bigqueryexport-183608.amazon.loanservicingevent_historical` 
  ) 
where mp_sup_key ='01a778b1-6087-43fb-8eea-0ac9b0fab52b'
