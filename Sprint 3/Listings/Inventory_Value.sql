SELECT 
  CAST(LEFT(open_date,10) AS DATE) AS listing_date,
  mp_sup_key, 
  asin,
  COUNT(*) as total_listings,
  COUNT(IF(status='Active', 1, NULL)) as Active_listings,
  COUNT(IF(status='Inactive', 1, NULL)) as Inactive_listings,
  AVG(IFNULL(SAFE_CAST(quantity AS INT64), 0.0)) as avg_Quantity,
  AVG(IFNULL(SAFE_CAST(price AS FLOAT64), 0.0)) as avg_Price,
  AVG(IFNULL(SAFE_CAST(price AS FLOAT64), 0.0)) * 
  AVG(IFNULL(SAFE_CAST(quantity AS INT64), 0.0)) AS Inventory_Value,
FROM 
  `bigqueryexport-183608.amazon.listings`
WHERE 
  mp_sup_key IS NOT NULL 
  --AND mp_sup_key = '766cc4a5-1239-4caf-9d22-223712e9d343'
  AND asin IS NOT NULL
  AND LEFT(open_date, 4) = '2021'
  AND quantity <> ''
GROUP BY 
  listing_id,
  mp_sup_key,
  asin,
  open_date
ORDER BY 
  active_listings DESC,total_listings DESC;