-- original query for data extraction
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
  SAFE_CAST(LEFT(open_date,10) AS DATE) > '2021-12-31' 
  AND open_date NOT IN ('3','','50','1','927.66','100','y')
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
  quantity)
WHERE rnk = 1;

-- testing to find top 15 sellers --
SELECT 
  mp_sup_key,
  status,
  SUM(Inventory_Value) AS total_value
  FROM (
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
  SAFE_CAST(LEFT(open_date,10) AS DATE) > '2021-12-31' 
  AND open_date NOT IN ('3','','50','1','927.66','100','y')
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
  quantity)
WHERE rnk = 1
AND status = 'Active' AND status <> 'Incomplete'
GROUP BY mp_sup_key, status
ORDER BY total_value desc;

--testing for price to find amazon fulfilled among top 15 sellers --
SELECT 
  mp_sup_key,
  status,
  SUM(recent_price) AS total_price
  FROM (
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
  SAFE_CAST(LEFT(open_date,10) AS DATE) > '2021-12-31' 
  AND open_date NOT IN ('3','','50','1','927.66','100','y')
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
  quantity)
WHERE rnk = 1
AND status = 'Active' AND status <> 'Incomplete'
AND fulfillment_channel = 'AMAZON_NA'
GROUP BY mp_sup_key, status
ORDER BY total_price desc;
