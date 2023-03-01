-- To filter out the irrelevant values from fulfillment_channel column <9 types>
SELECT distinct fulfillment_channel
  FROM `bigqueryexport-183608.amazon.listings`
  WHERE fulfillment_channel NOT IN ('0','');

-- To filter out the irrelevant values from status column <16 types>
SELECT distinct status
  FROM `bigqueryexport-183608.amazon.listings`
  WHERE status NOT IN ('0','');

-- To filter out the irrelevant values from item_condition column <29 types>
SELECT distinct item_condition
  FROM `bigqueryexport-183608.amazon.listings`
  WHERE item_condition IS NOT NULL 
  AND item_condition <> '';

SELECT count(*) FROM `bigqueryexport-183608.amazon.listings`;

--  listing_id,open_date,asin,sku,price,fulfillment_channel,status,mp_sup_key,partition_date

-- number of clients: 16399
SELECT distinct mp_sup_key
  FROM `bigqueryexport-183608.amazon.listings`
  WHERE mp_sup_key IS NOT NULL 
  AND mp_sup_key <> '';

-- Date Range of our dataset : 2019-09-20 (September,2019) to 2023-03-01 (March,2023) 
SELECT MAX(partition_date), MIN(partition_date) 
  FROM `bigqueryexport-183608.amazon.listings`;

-- Number of listings for each client
SELECT mp_sup_key,count(listing_id) AS NUMBER_OF_LISTINGS
  FROM `bigqueryexport-183608.amazon.listings`
  WHERE status NOT IN ('0','') 
  AND fulfillment_channel NOT IN ('0','')
  AND item_condition IS NOT NULL 
  AND item_condition <> '' 
  GROUP BY mp_sup_key
  ORDER BY COUNT(listing_id) DESC;

-- General select for client 0f191dec-c666-4060-b001-a373f4899d72
 SELECT 
    listing_id,
    open_date,
    sku,
    price,
    fulfillment_channel,
    status
  FROM `bigqueryexport-183608.amazon.listings`
  WHERE mp_sup_key = '0f191dec-c666-4060-b001-a373f4899d72'
  AND status NOT IN ('0','') 
  AND fulfillment_channel NOT IN ('0','')
  AND item_condition IS NOT NULL 
  AND item_condition <> '' ; 



-- To track inventory levels and monitor product availability
SELECT 
  open_date, 
  fulfillment_channel, 
  mp_sup_key,
  COUNT(*) as total_listings,
  COUNT(IF(status='Active', 1, NULL)) as active_listings,
  COUNT(IF(status='Inactive', 1, NULL)) as inactive_listings,
  COUNT(IF(status='Incomplete', 1, NULL)) as incomplete_listings
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  open_date IS NOT NULL 
  AND fulfillment_channel NOT IN ('0','')
  AND status NOT IN ('0','') 
GROUP BY 
  open_date, 
  fulfillment_channel,
  mp_sup_key
ORDER BY 
  open_date DESC 
LIMIT 1000;


SELECT 
  mp_sup_key, 
  asin,
  COUNT(*) as total_listings,
  (CAST('quantity'AS INT64)) as quantity
  --COUNT(IF(status='Active', 1, NULL)) as active_listings,
  --AVG(SAFE_CAST('price'AS FLOAT64)) as avg_price
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  mp_sup_key IS NOT NULL 
  AND fulfillment_channel NOT IN ('0','')
  AND status NOT IN ('0','') 
  AND price <> ''
GROUP BY 
  mp_sup_key,
  asin, 
  (CAST('quantity'AS INT64)) 
ORDER BY 
  total_listings DESC, (CAST('quantity'AS INT64)) DESC
  LIMIT 15;

