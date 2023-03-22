
--how do shipping level affect order_status 
SELECT DISTINCT
  mp_sup_key,
  asin,
  amazon_order_id,
  ship_service_level, 
  order_status
FROM 
  `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE
  purchase_day > '2021-12-31' AND purchase_day < '2022-12-31'
  AND item_price IS NOT NULL AND item_price <> 0
  AND quantity IS NOT NULL
  AND sales_channel = 'Amazon.com'
  AND fulfillment_channel = 'Amazon'
GROUP BY 
  mp_sup_key,
  asin,
  amazon_order_id,
  ship_service_level,
  order_status 
ORDER BY 
  mp_sup_key;



--total sales from shipped orders in 2022 
SELECT DISTINCT
  mp_sup_key,
  purchase_day,
  asin,
  amazon_order_id,
  avg(item_price) AS average_price,
  avg(quantity) AS average_quantity,
  avg(item_price) * avg(quantity) AS total_sales
FROM 
  `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE
  purchase_day > '2021-12-31' AND purchase_day < '2022-12-31'
  AND item_price IS NOT NULL AND item_price <> 0
  AND quantity IS NOT NULL
  AND sales_channel = 'Amazon.com'
  AND order_status = 'Shipped'
  AND fulfillment_channel = 'Amazon'
GROUP BY 
  mp_sup_key,
  purchase_day,
  asin,
  amazon_order_id
ORDER BY 
  mp_sup_key,purchase_day;

  