## Updated query for 1 and 2 (Ordered items and fulfillment channel scorecards)

SELECT SELLER_ID ,DATE_OF_PURCHASE, AMAZON_ORDER_ID, SALES_FULFILLMENT_CHANNEL, ORDER_STATUS, SALES, TOTAL_ORDERS, UNITS_ORDERED
FROM
(SELECT MP_SUP_KEY AS SELLER_ID , purchase_day AS DATE_OF_PURCHASE, amazon_order_id AS AMAZON_ORDER_ID,  fulfillment_channel as SALES_FULFILLMENT_CHANNEL, ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id ) AS SALES,
COUNT(amazon_order_id) OVER (PARTITION BY MP_SUP_KEY) AS TOTAL_ORDERS,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id ) AS UNITS_ORDERED,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1;

# Seperate query to keep a track of all scorecards - Finalized 
SELECT SELLER_ID , TOTAL_SALES, TOTAL_ORDERS, UNITS_ORDERED
FROM
(SELECT MP_SUP_KEY AS SELLER_ID , amazon_order_id AS AMAZON_ORDER_ID, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY MP_SUP_KEY) AS TOTAL_SALES,
COUNT(amazon_order_id) OVER (PARTITION BY MP_SUP_KEY) AS TOTAL_ORDERS,
SUM(QUANTITY) OVER (PARTITION BY MP_SUP_KEY ) AS UNITS_ORDERED,
ROW_NUMBER() OVER (PARTITION BY MP_SUP_KEY) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1;


#Main Data Connection
SELECT SELLER_ID ,DATE_OF_PURCHASE, AMAZON_ORDER_ID, SALES_FULFILLMENT_CHANNEL, ORDER_STATUS, SALES, ORDERED_UNITS
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id AS AMAZON_ORDER_ID, fulfillment_channel as SALES_FULFILLMENT_CHANNEL, ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id ) AS SALES,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id ) AS ORDERED_UNITS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1;


## With Partition Date
SELECT SELLER_ID ,DATE_OF_PURCHASE, AMAZON_ORDER_ID,  SALES_FULFILLMENT_CHANNEL, ORDER_STATUS, SALES, ORDERED_UNITS, 
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id AS AMAZON_ORDER_ID, fulfillment_channel as SALES_FULFILLMENT_CHANNEL, ORDER_STATUS,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id, partition_date ) AS SALES,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id, partition_date ) AS ORDERED_UNITS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1;

# Seperate query to keep a track of all scorecards - WITH PARTITION DATE - EXTREMELY WROMG
SELECT SELLER_ID , TOTAL_SALES, TOTAL_ORDERS, UNITS_ORDERED
FROM
(SELECT MP_SUP_KEY AS SELLER_ID , amazon_order_id AS AMAZON_ORDER_ID, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY MP_SUP_KEY, partition_date) AS TOTAL_SALES,
COUNT(amazon_order_id) OVER (PARTITION BY MP_SUP_KEY, partition_date) AS TOTAL_ORDERS,
SUM(QUANTITY) OVER (PARTITION BY MP_SUP_KEY, partition_date ) AS UNITS_ORDERED,
ROW_NUMBER() OVER (PARTITION BY MP_SUP_KEY) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1;


#Compare average with average - not sure 
SELECT SELLER_ID , CONCAT(CAST(MONTH AS STRING), '-' , CAST(YEAR AS STRING)) AS MONTH_YEAR,
DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, AVG_SALES_SELLER, TOTAL_SALES, COUNT_SELLERS, AVG_TOTAL_SALES
FROM
(SELECT EXTRACT(MONTH FROM purchase_day) AS MONTH,
EXTRACT(YEAR FROM purchase_day) AS YEAR,
MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, partition_date,
AVG(ITEM_PRICE * QUANTITY) OVER (PARTITION BY EXTRACT(MONTH FROM purchase_day) ,EXTRACT(YEAR FROM purchase_day), mp_sup_key) AS AVG_SALES_SELLER,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY EXTRACT(MONTH FROM purchase_day) , EXTRACT(YEAR FROM purchase_day)) AS TOTAL_SALES,
COUNT(MP_SUP_KEY) OVER (PARTITION BY EXTRACT(MONTH FROM purchase_day) , EXTRACT(YEAR FROM purchase_day)) AS COUNT_SELLERS,
CAST((SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY EXTRACT(MONTH FROM purchase_day) , EXTRACT(YEAR FROM purchase_day))/ COUNT(MP_SUP_KEY) OVER (PARTITION BY EXTRACT(MONTH FROM purchase_day) , EXTRACT(YEAR FROM purchase_day)) ) AS FLOAT64) AS AVG_TOTAL_SALES,
ROW_NUMBER() OVER (PARTITION BY EXTRACT(MONTH FROM purchase_day) , EXTRACT(YEAR FROM purchase_day), mp_sup_key) as row_day
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE row_day=1;