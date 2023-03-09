SELECT
  s.mp_sup_key,
  ABS(l.loan_payment_amount /s.transperd_fund_amount) AS proportion
FROM (
  SELECT
    mp_sup_key,
    SUM(original_total_amount) AS transperd_fund_amount
  FROM
    `bigqueryexport-183608.amazon.statements`
  WHERE
    processing_status ='Closed'
    AND fund_transfer_status ='Succeeded'
    AND DATE(fund_transfer_date) >= '2021-01-01'
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
    AND DATE(day) >= '2021-01-01'
  GROUP BY
    mp_sup_key) AS l
ON
  s.mp_sup_key =l.mp_sup_key
