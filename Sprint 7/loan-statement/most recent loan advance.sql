SELECT
    mp_sup_key,
    SUM(amount) AS loan_advance_amount
  FROM (
    SELECT
      mp_sup_key,
      amount,
      RANK() OVER (PARTITION BY mp_sup_key ORDER BY day DESC) AS rnk
    FROM
      `bigqueryexport-183608.amazon.vbq_loanservicingevent_historical`
    WHERE
      type = 'LoanAdvance'
      AND DATE(day) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH) ) subquery
  WHERE
    rnk = 1
  GROUP BY
    mp_sup_key
