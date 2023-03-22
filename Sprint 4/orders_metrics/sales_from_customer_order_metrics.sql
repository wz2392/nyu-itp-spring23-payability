###### CUSTOMER ORDER METRICS ######

SELECT DISTINCT SALES_CHANNEL FROM `bigqueryexport-183608.amazon.customer_order_metrics` ;
# Ouput contains - Amazon.com.br - brazil , Amazon.ca - canada , Amazon.com - general , Non-Amazon ,SI CA Prod Marketplace- dontknow , Amazon.com.mx - mexico

SELECT DISTINCT order_status FROM `bigqueryexport-183608.amazon.customer_order_metrics` ;
# Output - 19 categories in shipped, pending and complete : DOUBT : Confirm which one to consider 

#Group by seller to find the sales
SELECT MP_SUP_KEY AS SELLER_ID ,purchase_day as DATE_PURCHASED,  SUM(item_price * quantity) as SALES  FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE EXTRACT(YEAR FROM purchase_date) IN (2021 ,2022, 2023) AND SALES_CHANNEL = 'Amazon.com' AND ORDER_STATUS IN ('Complete', 'Shipped - Delivered to Buyer')
GROUP BY MP_SUP_KEY, purchase_day
ORDER BY MP_SUP_KEY, DATE_PURCHASED;


## P.SELLER_ID AS SELLER_ID, P.ORIGINAL_AMOUNT AS ORIGINAL_AMOUNT, P.PROCESSING_STATUS AS PROCESSING_STATUS, P.END_DATE AS END_DATE, COM.DATE_PURCHASED AS DATE_PURCHASED , COM.SALES AS TOTAL_SALES

##GROUP BY PURCHASE DATE
SELECT purchase_day as DATE_PURCHASED,  SUM(item_price * quantity) AS TOTAL_SALES  FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE EXTRACT(YEAR FROM purchase_date) IN (2021 ,2022, 2023) AND SALES_CHANNEL = 'Amazon.com' AND ORDER_STATUS IN ('Complete', 'Shipped - Delivered to Buyer')
GROUP BY purchase_day
ORDER BY purchase_day;

##CHECK - SHOW WHY NOT POSSIBLE
SELECT MP_SUP_KEY AS SELLER,
COUNTIF(ORDER_STATUS IN ('Shipped - Rejected by Buyer', 'Shipped - Lost in Transit', 'Shipped - Returning to Seller', 'Shipped - Damaged', 'Cancelled')) AS UNSUCCESSFUL_ORDERS,
COUNTIF(ORDER_STATUS IN ('Complete', 'Shipped - Delivered to Buyer')) as SUCCESSFUL_ORDERS 
FROM `bigqueryexport-183608.amazon.customer_order_metrics`
WHERE EXTRACT(YEAR FROM purchase_date) IN (2021 ,2022, 2023) AND SALES_CHANNEL = 'Amazon.com'
GROUP BY MP_SUP_KEY
order by SUCCESSFUL_ORDERS DESC;


## WORKED 
SELECT A.MP_SUP_KEY, A.item_price, A.quantity , B.DATE_PURCHASED, B.TOTAL_SALES
FROM `bigqueryexport-183608.amazon.customer_order_metrics` A
INNER JOIN
(SELECT purchase_day as DATE_PURCHASED,  SUM(item_price * quantity) AS TOTAL_SALES  
FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE EXTRACT(YEAR FROM purchase_date) IN (2021 ,2022, 2023) AND SALES_CHANNEL = 'Amazon.com' AND ORDER_STATUS IN ('Complete', 'Shipped - Delivered to Buyer')
GROUP BY purchase_day
ORDER BY purchase_day) B
ON A.purchase_day = B.DATE_PURCHASED;

##WORKED ANOTHER 
SELECT MP_SUP_KEY AS SELLER_ID , DATE_PURCHASED,  SUM(item_price * quantity) as SALES  
FROM
(SELECT A.MP_SUP_KEY, A.item_price, A.quantity , B.DATE_PURCHASED, B.TOTAL_SALES
FROM `bigqueryexport-183608.amazon.customer_order_metrics` A
INNER JOIN
(SELECT purchase_day as DATE_PURCHASED,  SUM(item_price * quantity) AS TOTAL_SALES  
FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE EXTRACT(YEAR FROM purchase_date) IN (2021 ,2022, 2023) AND SALES_CHANNEL = 'Amazon.com' AND ORDER_STATUS IN ('Complete', 'Shipped - Delivered to Buyer')
GROUP BY purchase_day
ORDER BY purchase_day) B
ON A.purchase_day = B.DATE_PURCHASED) B
GROUP BY MP_SUP_KEY, DATE_PURCHASED
ORDER BY SELLER_ID

##FINALLLL
SELECT MP_SUP_KEY AS SELLER_ID ,
PURCHASE_DAY AS DATE_OF_PURCHASE,
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY,MP_SUP_KEY ) AS SALES, 
SUM(ITEM_PRICE * QUANTITY) OVER (PARTITION BY PURCHASE_DAY) AS TOTAL_SALES
FROM `bigqueryexport-183608.amazon.customer_order_metrics` 
WHERE EXTRACT(YEAR FROM purchase_date) IN (2021 ,2022, 2023) AND SALES_CHANNEL = 'Amazon.com' AND ORDER_STATUS IN ('Complete', 'Shipped - Delivered to Buyer')
ORDER BY DATE_OF_PURCHASE DESC; 

