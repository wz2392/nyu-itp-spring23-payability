SELECT
  amount,
  day,
  type,
  mp_sup_key,
  CAST((day - LAG(day) OVER (ORDER BY day)) AS INTERVAL) AS diff
FROM
  `bigqueryexport-183608.amazon.vbq_loanservicingevent_historical`
WHERE
  mp_sup_key ='68cf5c85-421f-40ab-bf73-7219e2b99852'
ORDER BY
  day asc
