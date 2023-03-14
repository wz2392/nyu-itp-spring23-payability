SELECT M.mp_sup_key, M.orders_count_60, ROUND(R.Return_Order_60/M.orders_count_60*100,3) AS Return_Rate_60, R.Return_Amount_60,
    ROUND(R.Return_Amount_60/R.Return_Order_60,2) AS Average_Return_Amount_per_return
FROM
(SELECT mp_sup_key, orders_count_60 
FROM `bigqueryexport-183608.amazon.customer_health_metrics` 
WHERE DATE(snapshot_date) = CURRENT_DATE('America/Indiana/Indianapolis') 
) AS M
INNER JOIN
(SELECT mp_sup_key, COUNT(*) AS Return_Order_60, SUM(order_amount) AS Return_Amount_60
FROM `bigqueryexport-183608.amazon.returns` 
WHERE DATE(order_date) >= DATE_ADD(CURRENT_DATE('America/Indiana/Indianapolis'), INTERVAL -60 DAY)
GROUP BY mp_sup_key) AS R
ON M.mp_sup_key = R.mp_sup_key
WHERE M.orders_count_60 > 0
ORDER BY Return_Rate_60 DESC
