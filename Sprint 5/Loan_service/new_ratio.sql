SELECT
  s.mp_sup_key AS merchant_key,
  ABS(l.loan_payment_amount) /(s.transferd_fund_amount+ABS(l.loan_payment_amount)) AS proportion,
  transferd_fund_amount,
  ABS(loan_payment_amount) AS loan_payment_amount,
  status
FROM (
  SELECT
    mp_sup_key,
    SUM(original_total_amount) AS transferd_fund_amount
  FROM
    `bigqueryexport-183608.amazon.statements`
  WHERE
    processing_status ='Closed'
    AND fund_transfer_status ='Succeeded'
    AND CAST(LEFT(fund_transfer_date,10) AS DATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 2 MONTH)
  GROUP BY
    mp_sup_key) AS s
INNER JOIN (
  SELECT
    mp_sup_key,
    SUM(amount) AS loan_payment_amount
  FROM
    `bigqueryexport-183608.amazon.vbq_loanservicingevent_historical`
  WHERE
    type='LoanPayment'
    AND DATE(day) >= DATE_SUB(CURRENT_DATE(), INTERVAL 2 MONTH)
  GROUP BY
    mp_sup_key) AS l
ON
  s.mp_sup_key =l.mp_sup_key
INNER JOIN (
  SELECT
    mp_sup_key,
    status
  FROM
    `bigqueryexport-183608.amazon.account_status` ) AS a
ON
  l.mp_sup_key =a.mp_sup_key
