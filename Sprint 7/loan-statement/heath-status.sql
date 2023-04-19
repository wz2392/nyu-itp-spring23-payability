SELECT ts, mp_sup_key,
  CASE status
    WHEN 'NORMAL' THEN 1
    WHEN 'DEACTIVATED' THEN 0
    WHEN 'AT_RISK' THEN -1
    ELSE NULL 
  END AS status_value
FROM bigqueryexport-183608.amazon.account_status
