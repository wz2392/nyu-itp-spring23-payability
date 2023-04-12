-- Data validation --

-- 18021 \\ 869
select distinct listing_id, asin, max(partition_date), count(*) AS recent_date from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = '0ea018e0-3f3e-4132-ae5b-cf119d480528'
group by asin, listing_id 
order by recent_date desc;

SELECT *
FROM `bigqueryexport-183608.amazon.listings`
WHERE mp_sup_key = '0ea018e0-3f3e-4132-ae5b-cf119d480528'
  AND partition_date = (
    SELECT MAX(partition_date)
    FROM `bigqueryexport-183608.amazon.listings`
    WHERE mp_sup_key = 'd3727236-53ab-45fc-81a2-bba077c33074'
      AND asin = 'B0727YNVVB'
      AND LEFT(open_date, 10) = '2019-01-03'
  )
  AND asin = 'B0727YNVVB'
  AND LEFT(open_date, 10) = '2019-01-03';

-- EDA on Competitative pricing ---

SELECT * FROM `bigqueryexport-183608.amazon.competitive_pricing` 
LIMIT 10;

-- only Success (1 value)
select distinct status FROM `bigqueryexport-183608.amazon.competitive_pricing` ;

-- empty
select distinct error FROM `bigqueryexport-183608.amazon.competitive_pricing` ;

-- asin: 1586174878
-- path_golden: schema=amazon/table=competitive_pricing/date=2022-01-02/1586174878_1641114129.csv
-- status: Success
-- partition_date: 2022-01-02 00:00:00 UTC

-- only 1 record 
SELECT * FROM `bigqueryexport-183608.amazon.competitive_pricing` 
WHERE asin = '1586174878';
--AND status = 'Success';

-- different = used_buy_box_landed_price_amount; used_buy_box_listing_price_amount; used_buy_box_shipping_price_amount; listing_count_offers
SELECT * FROM `bigqueryexport-183608.amazon.competitive_pricing` 
WHERE asin = 'B01DMLV926';
--AND status = 'Success';

-- count how many records per asin 
-- B01DMLV926 = 79 ; B0094B94BM = 79 ; B01CVF7E28 = 77 (no. of records)
SELECT distinct asin, count(*) AS total FROM `bigqueryexport-183608.amazon.competitive_pricing` 
GROUP BY asin
order by total desc;

-- there are no duplicate ????
SELECT * FROM (
SELECT 
asin, 
status, 
used_buy_box_landed_price_currency_code,
used_buy_box_landed_price_amount, 
used_buy_box_listing_price_currency_code,
used_buy_box_listing_price_amount,  
used_buy_box_shipping_price_currency_code,
used_buy_box_shipping_price_amount,
RANK() OVER (PARTITION BY asin, partition_date ORDER BY MAX(partition_date) DESC) AS rank, 
FROM `bigqueryexport-183608.amazon.competitive_pricing`
GROUP BY 
asin, 
status,
used_buy_box_landed_price_currency_code,
used_buy_box_landed_price_amount, 
used_buy_box_listing_price_currency_code,
used_buy_box_listing_price_amount,  
used_buy_box_shipping_price_currency_code,
used_buy_box_shipping_price_amount,
partition_date)
WHERE rank=2;
