SELECT distinct quantity, count(*) AS total FROM `bigqueryexport-183608.amazon.listings`
group by quantity
order by total desc;

-- Inventory Dashboard data extract 
SELECT 
  status,
  sku,
  asin,
  CAST(LEFT(open_date,10) AS DATE) AS open_date,
  AVG(IFNULL(SAFE_CAST(quantity AS INT64), 0)) as avg_Quantity,
  AVG(IFNULL(SAFE_CAST(price AS FLOAT64), 0.0)) as avg_Price,
  AVG(IFNULL(SAFE_CAST(price AS FLOAT64), 0.0)) * 
  AVG(IFNULL(SAFE_CAST(quantity AS INT64), 0.0)) AS Inventory_Value
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  mp_sup_key IS NOT NULL
  AND mp_sup_key IN ('d3727236-53ab-45fc-81a2-bba077c33074','0ea018e0-3f3e-4132-ae5b-cf119d480528','b80e94c4-c376-413a-88b4-e2a1ddd980d9','1ee02181-2249-4cc9-92c4-c988c5f8b029')
  AND SAFE_CAST(LEFT(open_date,10) AS DATE) > '2017-12-31'
GROUP BY 
  listing_id,
  mp_sup_key,
  asin,
  open_date,
  status,
  sku
ORDER BY 
  open_date DESC;

-- to get distinct data 
SELECT DISTINCT 
count(*) AS total_listings,
mp_sup_key,
status,
sku,
asin,
SAFE_CAST(LEFT(open_date,10) AS DATE) AS open_date,
AVG(IFNULL(SAFE_CAST(quantity AS INT64), 0)) as avg_Quantity,
AVG(IFNULL(SAFE_CAST(price AS FLOAT64), 0.0)) as avg_Price,
AVG(IFNULL(SAFE_CAST(price AS FLOAT64), 0.0)) * 
AVG(IFNULL(SAFE_CAST(quantity AS INT64), 0.0)) AS Inventory_Value,
fulfillment_channel 
FROM `bigqueryexport-183608.amazon.listings`
WHERE 
mp_sup_key IN ('d3727236-53ab-45fc-81a2-bba077c33074','0ea018e0-3f3e-4132-ae5b-cf119d480528','b80e94c4-c376-413a-88b4-e2a1ddd980d9','1ee02181-2249-4cc9-92c4-c988c5f8b029')
GROUP BY listing_id, open_date, mp_sup_key,asin,sku,fulfillment_channel,status;
