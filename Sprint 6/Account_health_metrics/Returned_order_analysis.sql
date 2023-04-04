SELECT O.mp_sup_key, O.Number_Order_Shipped, R.Number_Return_Approved, ROUND(R.Number_Return_Approved/O.Number_Order_Shipped,3) AS Periodical_Return_Rate, R.Total_Return_Amount,
R.Total_Return_Amount/R.Number_Return_Approved AS AvgReturnAmount_per_Return
FROM
(SELECT mp_sup_key, COUNT(*) AS Number_Order_Shipped
FROM (
  SELECT DISTINCT amazon_order_id,mp_sup_key,order_status,purchase_date
  FROM `bigqueryexport-183608.amazon.customer_order_metrics`
  WHERE DATE(purchase_date) BETWEEN '2022-01-01' AND CURRENT_DATE('America/Indiana/Indianapolis') 
) 
WHERE order_status = "Shipped"
GROUP BY mp_sup_key) AS O
INNER JOIN
(SELECT mp_sup_key, COUNT(*) AS Number_Return_Approved, SUM(order_amount) AS Total_Return_Amount
FROM (
  SELECT DISTINCT order_id,mp_sup_key,return_request_status, order_amount
  FROM`bigqueryexport-183608.amazon.returns` 
  WHERE DATE(order_date) BETWEEN '2022-01-01' AND CURRENT_DATE('America/Indiana/Indianapolis')
)
  WHERE return_request_status = "Approved"
GROUP BY mp_sup_key) AS R
ON O.mp_sup_key = R.mp_sup_key
ORDER BY Periodical_Return_Rate DESC
