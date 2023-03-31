SELECT
  s.mp_sup_key AS merchant_key,
  ABS(l.loan_payment_amount) /(s.transfered_fund_amount+ABS(l.loan_payment_amount)) AS proportion,
  transfered_fund_amount,
  ABS(loan_payment_amount) AS loan_payment_amount,
FROM (
  SELECT
    mp_sup_key,
    SUM(original_total_amount) AS transfered_fund_amount
  FROM (
    SELECT
      mp_sup_key,
      original_total_amount,
      RANK() OVER (PARTITION BY mp_sup_key ORDER BY CAST(LEFT(fund_transfer_date,10) AS DATE) DESC) AS rnk
    FROM
      `bigqueryexport-183608.amazon.statements`
    WHERE
      processing_status ='Closed'
      AND fund_transfer_status ='Succeeded'
      AND CAST(LEFT(fund_transfer_date,10) AS DATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH) ) subquery
  WHERE
    rnk = 1
  GROUP BY
    mp_sup_key) AS s
INNER JOIN (
  SELECT
    mp_sup_key,
    SUM(amount) AS loan_payment_amount
  FROM (
    SELECT
      mp_sup_key,
      amount,
      RANK() OVER (PARTITION BY mp_sup_key ORDER BY day DESC) AS rnk
    FROM
      `bigqueryexport-183608.amazon.vbq_loanservicingevent_historical`
    WHERE
      type = 'LoanPayment'
      AND DATE(day) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH) ) subquery
  WHERE
    rnk = 1
  GROUP BY
    mp_sup_key) AS l
ON
  s.mp_sup_key =l.mp_sup_key
