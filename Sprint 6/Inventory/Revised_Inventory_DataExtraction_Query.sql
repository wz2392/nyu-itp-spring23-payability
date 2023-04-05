
-- naive approach; getting price and quantity and not average 
SELECT 
  partition_date,
  CAST(LEFT(open_date,10) AS DATE) AS open_date,
  mp_sup_key,
  status,
  sku,
  asin,
  SAFE_CAST(quantity AS INT64) AS recent_quantity,
  SAFE_CAST(price AS FLOAT64) AS recent_price,
  (SAFE_CAST(quantity AS INT64)) * (SAFE_CAST(price AS FLOAT64)) AS Inventory_Value
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  mp_sup_key = '1ee02181-2249-4cc9-92c4-c988c5f8b029'
  AND asin = 'B096XPFVLL'
  AND CAST(LEFT(open_date,10) AS DATE) = '2023-02-26'
GROUP BY 
  listing_id,
  mp_sup_key,
  asin,
  open_date,
  partition_date,
  status,
  sku,
  quantity,
  price
ORDER BY 
  partition_date DESC,open_date DESC;

-- main query to calculate inventory value using most recent
-- partition date 
SELECT * FROM (
SELECT 
  mp_sup_key,
  status,
  sku,
  asin,
  SAFE_CAST(quantity AS INT64) AS recent_quantity,
  SAFE_CAST(price AS FLOAT64) AS recent_price,
  (SAFE_CAST(quantity AS INT64)) * (SAFE_CAST(price AS FLOAT64)) AS Inventory_Value,
  RANK() OVER (PARTITION BY listing_id,mp_sup_key,asin, status ORDER BY MAX(partition_date) DESC) AS rnk,
  CAST(LEFT(open_date,10) AS DATE) AS open_date,
  partition_date,
  fulfillment_channel
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  mp_sup_key IS NOT NULL
  AND CAST(LEFT(open_date,10) AS DATE) > '2019-12-31'
  AND open_date <> ''
GROUP BY 
  listing_id,
  mp_sup_key,
  asin,
  open_date,
  partition_date,
  fulfillment_channel,
  status,
  sku,
  price,
  quantity
ORDER BY 
  open_date DESC)
WHERE rnk = 1;
