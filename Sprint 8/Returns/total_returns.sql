SELECT
  mp_sup_key,
  DATE_TRUNC(DATE(TIMESTAMP(order_date)), MONTH) AS month,
  SUM(return_quantity) as number_of_refund
FROM
  `bigqueryexport-183608.amazon.returns`
WHERE
  return_request_status ='Approved'
  AND DATE(TIMESTAMP(order_date)) >= DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR)
GROUP BY
  mp_sup_key,
  month
ORDER BY
  mp_sup_key,
  month
