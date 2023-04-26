SELECT *
FROM
(SELECT SELLER_ID ,DATE_OF_PURCHASE, AMAZON_ORDER_ID,  SALES_FULFILLMENT_CHANNEL, ORDER_STATUS, SALES, ORDERED_UNITS, 
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id AS AMAZON_ORDER_ID, fulfillment_channel as SALES_FULFILLMENT_CHANNEL, ORDER_STATUS,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id, partition_date ) AS SALES,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id, partition_date ) AS ORDERED_UNITS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1) AS S
LEFT JOIN
(SELECT order_id, mp_sup_key,order_date, currency_code,a_to_z_claim,
  SUM(refunded_amount) AS refunded_amount, 
  SUM(order_amount) AS total_order_amount
FROM`bigqueryexport-183608.amazon.returns` 
WHERE DATE(order_date) BETWEEN '2022-01-01' AND CURRENT_DATE('America/Indiana/Indianapolis')
  AND return_request_status = "Approved" 
GROUP BY order_id, mp_sup_key,order_date,currency_code,a_to_z_claim) AS R
ON S.AMAZON_ORDER_ID = R.order_id
ORDER BY R.refunded_amount DESC
