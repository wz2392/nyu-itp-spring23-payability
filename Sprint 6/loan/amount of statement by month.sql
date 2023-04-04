SELECT
  mp_sup_key,
  DATE_TRUNC(DATE(TIMESTAMP(fund_transfer_date)), MONTH) AS month,
  SUM(original_total_amount) AS sum_amount
FROM
  bigqueryexport-183608.amazon.statements
WHERE
  fund_transfer_status = 'Succeeded'
  AND processing_status = 'Closed'
  AND DATE(TIMESTAMP(fund_transfer_date)) >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
GROUP BY
  mp_sup_key,
  month
ORDER BY
  mp_sup_key,
  month
