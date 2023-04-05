#EDA

#For the latest parition date - records 43913
SELECT * FROM `bigqueryexport-183608.amazon.competitive_pricing` 
WHERE DATE(partition_date) ='2022-08-28';

#LISTING COUNT OFFERS FOR A ASIN WITH PARITION DATE to see how the value also changes with time
SELECT ASIN, STATUS, new_buy_box_landed_price_amount, new_buy_box_landed_price_currency_code,listing_count_offers, partition_date
FROM
(SELECT ASIN, STATUS, new_buy_box_landed_price_amount, new_buy_box_landed_price_currency_code, SAFE_CAST(listing_count_offers AS INT64) as listing_count_offers, DATE(partition_date) as partition_date,
ROW_NUMBER() OVER (PARTITION BY asin, partition_date) as rn
FROM `bigqueryexport-183608.amazon.competitive_pricing`
WHERE EXTRACT(YEAR FROM partition_date) IN (2022,2023))
WHERE rn=1
ORDER BY listing_count_offers DESC;


#Listing count offers only with asin without partition and categorzing into categories
SELECT ASIN, STATUS, new_buy_box_landed_price_amount, new_buy_box_landed_price_currency_code, partition_date, listing_count_offers_number, category ,
FROM
(SELECT ASIN, STATUS, new_buy_box_landed_price_amount, new_buy_box_landed_price_currency_code, 
SAFE_CAST(listing_count_offers AS INT64) as listing_count_offers_number, 
DATE(partition_date) as partition_date,
ROW_NUMBER() OVER (PARTITION BY asin, partition_date) as rn, 
CASE
WHEN SAFE_CAST(listing_count_offers AS INT64) = 1 THEN 'No Competition'
WHEN SAFE_CAST(listing_count_offers AS INT64) IN (2,3, 4)  THEN 'Medium Competition'
WHEN SAFE_CAST(listing_count_offers AS INT64) >=5 and SAFE_CAST(listing_count_offers AS INT64) <=20 THEN 'High Competition'
WHEN SAFE_CAST(listing_count_offers AS INT64) >21 THEN 'High Outliers'
END AS category
FROM `bigqueryexport-183608.amazon.competitive_pricing`
WHERE EXTRACT(YEAR FROM partition_date) IN (2022,2023))
WHERE rn=1;


#final

SELECT ASIN, STATUS, new_buy_box_landed_price_amount, new_buy_box_landed_price_currency_code, partition_date, listing_count_offers_number, category ,
FROM
(SELECT ASIN, STATUS, SAFE_CAST(new_buy_box_landed_price_amount AS FLOAT64) AS new_buy_box_landed_price_amount, new_buy_box_landed_price_currency_code, 
SAFE_CAST(listing_count_offers AS INT64) as listing_count_offers_number, 
DATE(partition_date) as partition_date,
ROW_NUMBER() OVER (PARTITION BY asin, partition_date) as rn, 
CASE
WHEN SAFE_CAST(listing_count_offers AS INT64) = 1 THEN 'No Competition'
WHEN SAFE_CAST(listing_count_offers AS INT64) IN (2,3, 4)  THEN 'Medium Competition'
WHEN SAFE_CAST(listing_count_offers AS INT64) >=5 and SAFE_CAST(listing_count_offers AS INT64) <=20 THEN 'High Competition'
WHEN SAFE_CAST(listing_count_offers AS INT64) >21 THEN 'High Outliers'
END AS category
FROM `bigqueryexport-183608.amazon.competitive_pricing`
WHERE EXTRACT(YEAR FROM partition_date) IN (2022,2023))
WHERE rn=1;