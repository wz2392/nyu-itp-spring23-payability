SELECT
  COUNT(DISTINCT mp_sup_key)
FROM
  `bigqueryexport-183608.amazon.vbq_loanservicingevent_historical`
WHERE
  DATE(day) >= '2021-01-01'
  AND mp_sup_key NOT IN(
  SELECT
    mp_sup_key
  FROM
    `bigqueryexport-183608.amazon.statements` )
