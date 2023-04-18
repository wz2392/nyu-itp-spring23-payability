SELECT order_id, mp_sup_key,order_date, 
  SUM(refunded_amount) AS refunded_amount_per_order, 
  SUM(order_amount) AS total_order_amount,
  (SUM(refunded_amount)/SUM(order_amount)) AS refund_percent_of_order
FROM`bigqueryexport-183608.amazon.returns` 
WHERE DATE(order_date) BETWEEN '2022-01-01' AND CURRENT_DATE('America/Indiana/Indianapolis')
  AND return_request_status = "Approved" 
GROUP BY order_id, mp_sup_key,order_date
