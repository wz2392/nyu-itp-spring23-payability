SELECT
  s_d.mp_sup_key AS mp_sup_key,
  (CASE
      WHEN p_date <= a_date THEN p_date
    ELSE
    a_date
  END
    ) AS end_date
FROM (
  SELECT
    MAX(CAST (fund_transfer_date AS date)) AS p_date,
    mp_sup_key
  FROM
    `bigqueryexport-183608.amazon.statements`
  GROUP BY
    mp_sup_key ) AS s_d
INNER JOIN (
  SELECT
    mp_sup_key,
    MAX(DATE(day)) AS a_date
  FROM
    `bigqueryexport-183608.amazon.vbq_loanservicingevent_historical`
  GROUP BY
    mp_sup_key ) AS l_d
ON
  s_d.mp_sup_key = l_d.mp_sup_key
