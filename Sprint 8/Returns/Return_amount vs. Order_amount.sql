SELECT order_id, mp_sup_key,order_date, 
  SUM(refunded_amount) AS refunded_amount_per_order, 
  SUM(order_amount) AS total_order_amount,
  (SUM(refunded_amount)/SUM(order_amount)) AS refund_percent_of_order
FROM`bigqueryexport-183608.amazon.returns` 
WHERE DATE(order_date) BETWEEN '2022-01-01' AND CURRENT_DATE('America/Indiana/Indianapolis')
  AND return_request_status = "Approved" 
GROUP BY order_id, mp_sup_key,order_date

### Returns by Categories
SELECT R.order_id,R.mp_sup_key,R.order_date,R.a_to_z_claim,R.in_policy,R.is_prime,IFNULL(P.product_group,"Unknown") AS Product_Group
FROM
(SELECT order_id,asin, mp_sup_key,order_date,a_to_z_claim,in_policy,is_prime
FROM`bigqueryexport-183608.amazon.returns` 
WHERE DATE(order_date) BETWEEN '2022-01-01' AND CURRENT_DATE('America/Indiana/Indianapolis')
  AND return_request_status = "Approved" ) AS R
LEFT JOIN
(SELECT id,product_group
FROM `bigqueryexport-183608.amazon.products` 
WHERE id_type = "ASIN") AS P
ON R.asin = P.id
