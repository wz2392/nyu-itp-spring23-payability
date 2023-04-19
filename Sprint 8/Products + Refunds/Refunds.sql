#EDA
SELECT * FROM `bigqueryexport-183608.amazon.vbq_refundevent_historical` 
LIMIT 10;

#iDENTIFY THE NUMBER OF REFUNDS AND AMOUNT CHARGED
SELECT MP_SUP_KEY AS SELLER_ID, DATE(posted_date) as POSTED_DATE, amazon_order_id AS AMAZON_ORDER_ID, 
SUM(ITEM_CHARGE_AMOUNT) OVER (PARTITION BY MP_SUP_KEY, DATE(posted_date)) AS CHARGED_AMOUNT,
COUNT(amazon_order_id) OVER (PARTITION BY MP_SUP_KEY, DATE(posted_date)) AS NUMBER_OF_REFUNDS,
FROM `bigqueryexport-183608.amazon.vbq_refundevent_historical` 
WHERE EXTRACT(YEAR FROM posted_date) IN (2022, 2023);

#Duplication check
SELECT * FROM `bigqueryexport-183608.amazon.vbq_refundevent_historical`
WHERE MP_SUP_KEY= '003a8c69-233f-4451-98db-7ea5a952efc6' AND DATE(posted_date)='2022-04-06';


#item_charge_Type column 
SELECT DISTINCT ITEM_CHARGE_TYPE FROM `bigqueryexport-183608.amazon.vbq_refundevent_historical` ;

#Adding row_number to remove Duplication
SELECT SELLER_ID, POSTED_DATE, AMAZON_ORDER_ID,  CHARGED_AMOUNT, NUMBER_OF_REFUNDS
FROM
(SELECT MP_SUP_KEY AS SELLER_ID, DATE(posted_date) as POSTED_DATE, amazon_order_id AS AMAZON_ORDER_ID, 
SUM(ITEM_CHARGE_AMOUNT) OVER (PARTITION BY MP_SUP_KEY, DATE(posted_date)) AS CHARGED_AMOUNT,
COUNT(amazon_order_id) OVER (PARTITION BY MP_SUP_KEY, DATE(posted_date)) AS NUMBER_OF_REFUNDS,
ROW_NUMBER() OVER (PARTITION BY MP_SUP_KEY, DATE(posted_date), AMAZON_ORDER_ID) as rn
FROM `bigqueryexport-183608.amazon.vbq_refundevent_historical` 
WHERE EXTRACT(YEAR FROM posted_date) IN (2022, 2023))
where rn=1;


#Max_quantity added
SELECT SELLER_ID, POSTED_DATE, AMAZON_ORDER_ID,  CHARGED_AMOUNT, NUMBER_OF_REFUNDS
FROM
(SELECT MP_SUP_KEY AS SELLER_ID, DATE(posted_date) as POSTED_DATE, amazon_order_id AS AMAZON_ORDER_ID, 
SUM(ITEM_CHARGE_AMOUNT) OVER (PARTITION BY MP_SUP_KEY, DATE(posted_date)) AS CHARGED_AMOUNT,
MAX(quantity) OVER (PARTITION BY MP_SUP_KEY, DATE(posted_date), AMAZON_ORDER_ID ) AS NUMBER_OF_REFUNDS,
ROW_NUMBER() OVER (PARTITION BY MP_SUP_KEY, DATE(posted_date), AMAZON_ORDER_ID) as rn
FROM `bigqueryexport-183608.amazon.vbq_refundevent_historical` 
WHERE EXTRACT(YEAR FROM posted_date) IN (2022, 2023))
where rn=1 ;