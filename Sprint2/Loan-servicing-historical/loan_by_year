SELECT SPLIT(SPLIT(path_golden, '/')[OFFSET(3)], '=')[OFFSET(1)] AS mp_sup_key,amount, type
FROM `bigqueryexport-183608.amazon.loanservicingevent_historical` 
WHERE DATE(_PARTITIONTIME) >= "2023-01-01" AND DATE(_PARTITIONTIME) <="2023-01-31";
