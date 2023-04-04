SELECT
  mp_sup_key,
  DATE_TRUNC(DATE(TIMESTAMP(day)), MONTH) AS month,
  SUM(ABS(amount)) AS sum_amount
FROM
  bigqueryexport-183608.amazon.vbq_loanservicingevent_historical
WHERE
  type = 'LoanPayment'
  AND DATE(TIMESTAMP(day)) >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
GROUP BY
  mp_sup_key,
  month
ORDER BY
  mp_sup_key,
  month
