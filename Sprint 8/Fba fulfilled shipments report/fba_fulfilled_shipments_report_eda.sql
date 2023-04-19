SELECT * 
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
WHERE DATE(_PARTITIONTIME) = "2023-04-18" 
LIMIT 20;

-- EACH RECORD REFERS TO ONE ITEM PER ORDER. 
-- is quantity_shipped more than 1? YES. 
SELECT * 
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
WHERE SAFE_CAST(quantity_shipped AS INT64) > 1;

-- what are the types of fulfillment channel? ONLY AFN probably because this table is 
-- about fba fulfilled records 
SELECT distinct(fulfillment_channel), count(*) AS total
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
GROUP BY fulfillment_channel
ORDER BY total desc;

-- what are the types of sales channel? 
SELECT distinct(sales_channel), count(*) AS total
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
GROUP BY sales_channel
ORDER BY total desc;

-- what are the types of carriers? 50 different; also includes country specific. 
SELECT distinct(carrier), count(*) AS total
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
GROUP BY carrier
ORDER BY total desc;

-- can one amazon_order_id have multiple amazon_order_item_ids? 
-- yes. 111-0612762-9885061 has 9072
SELECT amazon_order_id, COUNT(*) as record_count
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports`
GROUP BY amazon_order_id
HAVING record_count > 1
ORDER BY record_count DESC;

-- 60a9135d-f5c4-473a-8b9f-32f1e2f35a81
-- 810 records for the most recent partition date value
SELECT * 
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
WHERE amazon_order_id = '111-0612762-9885061' 
AND partition_date = '2021-11-25'
ORDER BY payments_date desc;

-- how many different shippment_ids are associated with this? 
-- 6 in total
SELECT DISTINCT(shipment_id)
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
WHERE amazon_order_id = '111-0612762-9885061' 
AND partition_date = '2021-11-25';

-- how many shipment_item_id s?
-- 9 in total 
SELECT DISTINCT(shipment_item_id)
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
WHERE amazon_order_id = '111-0612762-9885061' 
AND partition_date = '2021-11-25';

-- for one shipment_item_id, there is only one shipment_id
SELECT DISTINCT(shipment_id)
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports` 
WHERE amazon_order_id = '111-0612762-9885061' 
AND partition_date = '2021-11-25'
AND shipment_item_id = 'Db1kw3DFR';

-- is that true for all? NO
SELECT shipment_id, COUNT( DISTINCT shipment_item_id) as shipment_count
FROM `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports`
WHERE amazon_order_id = '111-0612762-9885061'
AND partition_date = '2021-11-25'
GROUP BY shipment_id;

-- how to calculate price of an item?  
-- SAFE_CAST(item_price AS FLOAT64) + SAFE_CAST(item_tax AS FLOAT64) + SAFE_CAST(shipping_price AS FLOAT64) + 
-- SAFE_CAST(shipping_tax AS FLOAT64) + SAFE_CAST(gift_wrap_price AS FLOAT64) + SAFE_CAST(gift_wrap_tax AS FLOAT64)
-- - SAFE_CAST(item_promotion_discount AS FLOAT64) - SAFE_CAST(ship_promotion_discount AS FLOAT64)

-- Main query to get sales value
SELECT * FROM (
SELECT 
  mp_sup_key, 
  amazon_order_id, 
  sku,
  shipment_id,
  shipment_item_id,
  sales_channel,
  SAFE_CAST(quantity_shipped AS INT64) AS quantity, 
  (SAFE_CAST(item_price AS FLOAT64) + SAFE_CAST(item_tax AS FLOAT64) + SAFE_CAST(shipping_price AS FLOAT64) + 
  SAFE_CAST(shipping_tax AS FLOAT64) + SAFE_CAST(gift_wrap_price AS FLOAT64) + SAFE_CAST(gift_wrap_tax AS FLOAT64)
  - SAFE_CAST(item_promotion_discount AS FLOAT64) - SAFE_CAST(ship_promotion_discount AS FLOAT64)) AS price,
  RANK() OVER (PARTITION BY amazon_order_id,mp_sup_key,sku,shipment_item_id ORDER BY MAX(partition_date) DESC) AS rnk,
  partition_date
FROM 
  `bigqueryexport-183608.amazon.fba_fulfilled_shipments_reports`
WHERE 
  sales_channel = 'Amazon.com'
GROUP BY 
  mp_sup_key,
  amazon_order_id,
  shipment_id, 
  shipment_item_id,
  sku,
  partition_date,
  sales_channel,
  quantity,
  price)
WHERE rnk = 1;