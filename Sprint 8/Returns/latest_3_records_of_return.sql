SELECT *
FROM (
  SELECT
    *,
    RANK() OVER (PARTITION BY mp_sup_key ORDER BY order_date DESC) AS rnk
  FROM
    `bigqueryexport-183608.amazon.returns`
  WHERE
    return_request_status ='Approved'
    AND order_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
)
WHERE
  rnk <= 3
ORDER BY
  mp_sup_key, order_date DESC
