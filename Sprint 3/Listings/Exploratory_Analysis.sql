SELECT DISTINCT IFNULL(SAFE_CAST(quantity AS FLOAT64), 0.0) AS quantity
FROM `bigqueryexport-183608.amazon.listings`
order by quantity desc;
 
 -- 998654833023.95
SELECT *
FROM `bigqueryexport-183608.amazon.listings`
where price = '998654833023.95'
order by partition_date desc;

select distinct quantity 
from `bigqueryexport-183608.amazon.listings`
where quantity IS NOT NULL AND quantity NOT IN ('y','B098VS2ZKT','DEFAULT','AMAZON_NA','B01LY6ZYWU','B000MN0O6A')
order by quantity desc
limit 50;

--- LISTING ID
SELECT * 
FROM `bigqueryexport-183608.amazon.listings` 
WHERE listing_id = '0219Y070KBV';

select distinct listing_id, count(*) FROM `bigqueryexport-183608.amazon.listings` 
group by listing_id;

-- mp_sup_key
select * from `bigqueryexport-183608.amazon.listings`
where asin = 'B07YRY28CV' AND mp_sup_key = '1134fcd3-ebad-4750-8490-abf840129c62';

select count(distinct mp_sup_key)/count(distinct listing_id) * 100
from `bigqueryexport-183608.amazon.listings`;

-- total no. of listings for of all the clients based on status
SELECT 
  mp_sup_key, 
  asin,
  COUNT(*) as total_listings,
  ROUND(COUNT(IF(status='Active', 1, NULL))/COUNT(*) * 100, 2) as active_listings,
  ROUND(COUNT(IF(status='Inactive', 1, NULL))/COUNT(*) * 100, 2) as inactive_listings
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  --mp_sup_key = 'ce60c2fb-3e7b-49da-8a45-9ce41f439618' 
  asin IS NOT NULL
  AND LEFT(open_date, 7) = '2021-01'
GROUP BY 
  listing_id,
  mp_sup_key,
  asin
ORDER BY 
  total_listings desc
LIMIT 500;


-- % of a particular channel 
 SELECT 
  listing_id,
  mp_sup_key, 
  asin,
  COUNT(*) as total_listings,
  COUNT(IF(fulfillment_channel='DEFAULT', 1, NULL)) as default_shipping,
  COUNT(IF(fulfillment_channel='AMAZON_NA', 1, NULL)) as amazon_na,
  COUNT(IF(fulfillment_channel='FREE SHIPPING', 1, NULL)) as free_shipping, 
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  mp_sup_key IS NOT NULL 
  AND asin IS NOT NULL
  AND listing_id IS NOT NULL
  AND listing_id <> ''
GROUP BY 
  listing_id,
  mp_sup_key,
  asin
ORDER BY total_listings desc;

  -- fulfillment channel : 139873138 / 227856645
  SELECT 
  listing_id,
  mp_sup_key, 
  asin,
  fulfillment_channel,
  IFNULL(SAFE_CAST(quantity AS INT64), 0.0) as quantity
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  --mp_sup_key IS NOT NULL 
  mp_sup_key = 'f945c1ac-3a5b-4ae1-a701-fca79955f0a7'
  AND asin IS NOT NULL
  AND listing_id IS NOT NULL
  AND listing_id <> ''
GROUP BY 
  listing_id,
  mp_sup_key,
  asin,
  fulfillment_channel, 
  quantity
ORDER BY quantity desc;


-- fulfillment channels used in 2021
  SELECT 
  listing_id,
  mp_sup_key, 
  fulfillment_channel
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  --mp_sup_key IS NOT NULL 
  asin IS NOT NULL
  AND listing_id IS NOT NULL AND listing_id <> ''
  AND LEFT(open_date, 4) = '2021'
GROUP BY 
  listing_id,
  mp_sup_key, 
  fulfillment_channel;

-- date 
SELECT CAST(LEFT(open_date,10) AS DATE) AS date
FROM `bigqueryexport-183608.amazon.listings`
WHERE LEFT(open_date, 4) = '2020'
OR LEFT(open_date, 4) = '2021'
LIMIT 100;


