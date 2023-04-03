
#Statements for customer 1
SELECT financial_event_group_id, financial_event_group_start, financial_event_group_end, original_total_amount,processing_status,beginning_balance_amount
FROM `bigqueryexport-183608.amazon.statements` 
WHERE EXTRACT(YEAR FROM financial_event_group_start) IN (2022, 2023) AND MP_SUP_KEY= 'd3727236-53ab-45fc-81a2-bba077c33074'
ORDER BY financial_event_group_start DESC, financial_event_group_end DESC;


#Sales for Customer 1
SELECT MP_SUP_KEY AS SELLER_ID ,
PURCHASE_DAY AS DATE_OF_PURCHASE,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY,MP_SUP_KEY ) AS SALES,
ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_SALES
FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022, 2023)  AND MP_SUP_KEY= 'd3727236-53ab-45fc-81a2-bba077c33074'
ORDER BY DATE_OF_PURCHASE DESC;




#In general checking order history to manually look how sales is being calculated in the above query
SELECT *
FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022, 2023)  AND MP_SUP_KEY= 'd3727236-53ab-45fc-81a2-bba077c33074'
ORDER BY purchase_day ASC;

	
#Updated query to remove duplication and check for one day, also include the ORDERED_UNITS
SELECT MP_SUP_KEY AS SELLER_ID ,
purchase_day AS DATE_OF_PURCHASE,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id ) AS ORDERED_UNITS,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id ) AS SALES,
ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_SALES
FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE purchase_day= '2023-03-27'  AND MP_SUP_KEY= 'd3727236-53ab-45fc-81a2-bba077c33074' AND ORDER_STATUS NOT IN ('Pending', 'Cancelled')
ORDER BY DATE_OF_PURCHASE DESC;

#just the rn subquery work - check
SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id ) AS SALES,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022) AND EXTRACT(MONTH FROM purchase_date) IN (4) AND MP_SUP_KEY= 'd3727236-53ab-45fc-81a2-bba077c33074' AND ORDER_STATUS NOT IN ('Pending', 'Cancelled') ;

#Assigning row numbers and selecting only row number = 1 
SELECT SELLER_ID ,DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, SALES,
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE,amazon_order_id, ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY ) AS SALES,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE purchase_day= '2023-03-27'  AND MP_SUP_KEY= 'd3727236-53ab-45fc-81a2-bba077c33074' AND ORDER_STATUS NOT IN ('Pending', 'Cancelled') )
WHERE rn=1;

#Updating the amazon_order_id in partition to remove more duplicates
SELECT SELLER_ID ,DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, SALES
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id ) AS SALES,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022) AND EXTRACT(MONTH FROM purchase_date) IN (4) AND MP_SUP_KEY= 'd3727236-53ab-45fc-81a2-bba077c33074' AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1 ;

#Updated Query
SELECT SELLER_ID ,DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, SALES, ORDERED_UNITS
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id ) AS SALES,
SUM(QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id ) AS ORDERED_UNITS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1;

#Adding other parameters -  global sales and orders , changing quantity to orders
SELECT SELLER_ID ,DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, SALES, TOTAL_SALES, TOTAL_ORDERS, ORDERS
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id ) AS SALES,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_SALES,
COUNT(amazon_order_id) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_ORDERS,
COUNT(amazon_order_id) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id ) AS ORDERS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id) as rn
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2022,2023) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE rn=1;

##Above query check for two sellers
SELECT SELLER_ID ,DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, TOTAL_SALES, TOTAL_ORDERS
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, 
-- SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id ) AS SALES,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_SALES,
COUNT(amazon_order_id) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_ORDERS,
-- COUNT(amazon_order_id) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id ) AS ORDERS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY) as row_day
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE  EXTRACT(YEAR FROM purchase_date) IN (2022) AND MP_SUP_KEY IN ('d3727236-53ab-45fc-81a2-bba077c33074', '0ea018e0-3f3e-4132-ae5b-cf119d480528') AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE row_day=1;

#Custom Query added for total
SELECT SELLER_ID ,DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, TOTAL_SALES, TOTAL_ORDERS
FROM
(SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day AS DATE_OF_PURCHASE, amazon_order_id, ORDER_STATUS, 
-- SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY, amazon_order_id ) AS SALES,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_SALES,
COUNT(amazon_order_id) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_ORDERS,
-- COUNT(amazon_order_id) OVER (PARTITION BY PURCHASE_DAY, MP_SUP_KEY , amazon_order_id ) AS ORDERS,
ROW_NUMBER() OVER (PARTITION BY PURCHASE_DAY) as row_day
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE  EXTRACT(YEAR FROM purchase_date) IN (2022) AND ORDER_STATUS NOT IN ('Pending', 'Cancelled'))
WHERE row_day=1;
