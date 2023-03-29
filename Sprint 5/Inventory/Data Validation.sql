-- d3727236-53ab-45fc-81a2-bba077c33074
-- 0ea018e0-3f3e-4132-ae5b-cf119d480528

-- b80e94c4-c376-413a-88b4-e2a1ddd980d9
-- 1ee02181-2249-4cc9-92c4-c988c5f8b029

SELECT 
  CAST(LEFT(open_date,10) AS DATE) AS open_date,
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
  mp_sup_key = '0ea018e0-3f3e-4132-ae5b-cf119d480528' 
GROUP BY 
  listing_id,
  mp_sup_key,
  asin,
  open_date
ORDER BY 
  open_date DESC, Active_listings DESC,total_listings DESC;

-- general check for B075GY666X for 0ea018e0-3f3e-4132-ae5b-cf119d480528 on 2019-11-06
-- 38 listings 
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = '0ea018e0-3f3e-4132-ae5b-cf119d480528' 
AND asin = 'B075GY666X'
AND LEFT(open_date,10) = '2019-11-06';

-- B09SR6YVDJ for 0ea018e0-3f3e-4132-ae5b-cf119d480528 on 2022-02-18
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = '0ea018e0-3f3e-4132-ae5b-cf119d480528' 
AND asin = 'B09SR6YVDJ'
AND LEFT(open_date,10) = '2022-02-18';

-- what is wrong with quantity fields?
-- B086NCDS8Z for 1ee02181-2249-4cc9-92c4-c988c5f8b029 on 2023-02-26
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = '1ee02181-2249-4cc9-92c4-c988c5f8b029' 
AND asin = 'B07XP8K162'
AND LEFT(open_date,10) = '2023-03-18';

-- B096XPFVLL
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = '1ee02181-2249-4cc9-92c4-c988c5f8b029' 
AND asin = 'B096XPFVLL'
AND status = 'Active'
AND LEFT(open_date,10) = '2023-02-26';

--B000F4Y8CW
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = '1ee02181-2249-4cc9-92c4-c988c5f8b029' 
AND asin = 'B000F4Y8CW'
AND LEFT(open_date,10) = '2023-01-27';

--B000V87C2U
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = '1ee02181-2249-4cc9-92c4-c988c5f8b029' 
AND asin = 'B000V87C2U'
AND status = 'Active'
AND LEFT(open_date,10) = '2023-03-11';
