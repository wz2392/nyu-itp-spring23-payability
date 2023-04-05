-- Sprint 6 data validation 

-- d3727236-53ab-45fc-81a2-bba077c33074
-- 0ea018e0-3f3e-4132-ae5b-cf119d480528
-- b80e94c4-c376-413a-88b4-e2a1ddd980d9
-- 1ee02181-2249-4cc9-92c4-c988c5f8b029

-- new query to test partition_date value
SELECT *
FROM `bigqueryexport-183608.amazon.listings`
WHERE mp_sup_key = 'd3727236-53ab-45fc-81a2-bba077c33074'
  AND partition_date = (
    SELECT MAX(partition_date)
    FROM `bigqueryexport-183608.amazon.listings`
    WHERE mp_sup_key = 'd3727236-53ab-45fc-81a2-bba077c33074'
      AND asin = 'B0727YNVVB'
      AND LEFT(open_date, 10) = '2019-01-03'
  )
  AND asin = 'B0727YNVVB'
  AND LEFT(open_date, 10) = '2019-01-03';

--B0727YNVVB
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = 'd3727236-53ab-45fc-81a2-bba077c33074' 
AND asin = 'B0727YNVVB'
AND LEFT(open_date,10) = '2019-01-03'
order by partition_date desc;

-- general check for d3727236-53ab-45fc-81a2-bba077c33074
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = 'd3727236-53ab-45fc-81a2-bba077c33074' 
AND asin = 'B0727YNVVB'
AND LEFT(open_date,10) = '2019-01-03'
order by partition_date desc;

-- general check for d3727236-53ab-45fc-81a2-bba077c33074
select * from `bigqueryexport-183608.amazon.listings`
where mp_sup_key = '0ea018e0-3f3e-4132-ae5b-cf119d480528' 
AND asin = 'B075GY666X'
AND LEFT(open_date,10) = '2019-11-06'
order by partition_date desc;

-- find some new sellers for validation 
select mp_sup_key, count(*) AS total,
COUNT(IF(fulfillment_channel='AMAZON_NA', 1, NULL)) as fba_fulfilled,
COUNT(IF(fulfillment_channel='DEFAULT', 1, NULL)) as self_fulfilled
from `bigqueryexport-183608.amazon.listings`
where status = 'Active'
AND quantity <> ''
group by mp_sup_key
order by fba_fulfilled desc,total desc;

select count(distinct mp_sup_key) from `bigqueryexport-183608.amazon.listings`; -- 16669

-- cb860960-4bb7-4b07-a6fa-070a4d7cb3cb
-- dd6a7093-b12e-4f27-b5bd-a8524fc63e88
-- 21a27ed1-5fb0-4e6a-986d-4a8170f80bbc

