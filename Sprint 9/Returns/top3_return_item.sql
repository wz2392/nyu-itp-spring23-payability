WITH top_items AS (
  SELECT 
    mp_sup_key,
    item_name,
    asin,
    COUNT(*) AS `Number of Returns`
  FROM 
    `bigqueryexport-183608.amazon.returns`
  GROUP BY 
    mp_sup_key,
    item_name,
    asin
  ORDER BY 
    mp_sup_key,
    `Number of Returns` DESC
),
merchant_items AS (
  SELECT 
    ti.mp_sup_key,
    ti.item_name,
    ti.asin,
    ti.`Number of Returns`,
    ROW_NUMBER() OVER (PARTITION BY ti.mp_sup_key ORDER BY ti.`Number of Returns` DESC) AS `rank`
  FROM 
    top_items ti
)
SELECT 
  mp_sup_key,
  item_name,
  asin,
  `Number of Returns`
FROM 
  merchant_items
WHERE 
  `rank` <= 3;
