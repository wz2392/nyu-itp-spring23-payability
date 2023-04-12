#EDA on CP 

#path_golden
SELECT ASIN, PATH_GOLDENN FROM bigqueryexport-183608.amazon.competitive_pricing` LIMIT 100;


SELECT SAFE_CAST(LEFT(open_date,10) AS DATE) AS open_date, REGEXP_EXTRACT(open_date, r'\d{4}') AS YEAR, price as LISTING_TABLE_PRICE, mp_sup_key AS SELLER_ID, ASIN AS ASIN
FROM `bigqueryexport-183608.amazon.listings`
WHERE REGEXP_EXTRACT(open_date, r'\d{4}') IN ('2022', '2023');


#Joining with the listings table
SELECT open_date, YEAR, LISTING_TABLE_PRICE, SELLER_ID, CP.asin AS ASIN, CP.new_buy_box_listing_price_amount ,CP.listing_count_offers, CP.path_golden
FROM
(SELECT SAFE_CAST(LEFT(open_date,10) AS DATE) AS open_date, REGEXP_EXTRACT(open_date, r'\d{4}') AS YEAR, price as LISTING_TABLE_PRICE, mp_sup_key AS SELLER_ID, ASIN AS ASIN
FROM `bigqueryexport-183608.amazon.listings` WHERE REGEXP_EXTRACT(open_date, r'\d{4}') IN ('2022', '2023')) L
INNER JOIN `bigqueryexport-183608.amazon.competitive_pricing` CP  ON L.ASIN = CP.ASIN;


#Data Validation 

SELECT * FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022) AND EXTRACT(MONTH FROM purchase_date) IN (1) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled')
AND MP_SUP_KEY= '0ea018e0-3f3e-4132-ae5b-cf119d480528'
AND amazon_order_id IN ('112-5069070-9937838', '114-6000086-4229040', '111-0656666-7545021', '112-7001776-3673816', '113-8549665-5494618') ;


SELECT SELLER_ID ,DATE_OF_PURCHASE, AMAZON_ORDER_ID,  SALES_FULFILLMENT_CHANNEL, ORDER_STATUS, SALES, ORDERED_UNITS, 
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id AS AMAZON_ORDER_ID, fulfillment_channel as SALES_FULFILLMENT_CHANNEL, ORDER_STATUS,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id, partition_date ) AS SALES,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id, partition_date ) AS ORDERED_UNITS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022)  AND EXTRACT(MONTH FROM purchase_date) IN (1) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled') AND MP_SUP_KEY = '0ea018e0-3f3e-4132-ae5b-cf119d480528')
WHERE rn=1;


SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id AS AMAZON_ORDER_ID, fulfillment_channel as SALES_FULFILLMENT_CHANNEL, ORDER_STATUS,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id, partition_date ) AS SALES,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id, partition_date ) AS ORDERED_UNITS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022)  AND EXTRACT(MONTH FROM purchase_date) IN (1) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled') AND MP_SUP_KEY = '0ea018e0-3f3e-4132-ae5b-cf119d480528'
ORDER BY DATE_OF_PURCHASE;


#sorted by date total 31st dec
SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id AS AMAZON_ORDER_ID, fulfillment_channel as SALES_FULFILLMENT_CHANNEL, ORDER_STATUS,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id, partition_date ) AS SALES,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id, partition_date ) AS ORDERED_UNITS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022)  AND EXTRACT(MONTH FROM purchase_date) IN (1) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled') AND MP_SUP_KEY = '0ea018e0-3f3e-4132-ae5b-cf119d480528'
ORDER BY DATE_OF_PURCHASE ;



# Issue Spreadsheet Link: https://docs.google.com/spreadsheets/d/1ruYp6XxppAC5kTZMKK2mfYZW2Mf9f2LuUlViTOGCuWk/edit?usp=sharing
#Please Refer to documentation because more work was done on google sheets to find the data issue than querying.

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