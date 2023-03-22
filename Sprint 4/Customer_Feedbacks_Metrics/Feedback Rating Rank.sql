SELECT F.rating, count(*) AS Cnt
FROM
(SELECT partition_date, mp_sup_key,rating,COUNT(*) AS count
FROM `bigqueryexport-183608.amazon.customer_feedback_metrics` 
WHERE parse_date('%m/%d/%y',date) >= DATE_ADD(CURRENT_DATE('America/Indiana/Indianapolis'), INTERVAL -90 DAY)
GROUP BY partition_date,mp_sup_key,rating
) AS F
INNER JOIN
(SELECT mp_sup_key,negativeFeedbacks_90_rate
FROM `bigqueryexport-183608.amazon.customer_health_metrics` 
WHERE DATE(snapshot_date) = CURRENT_DATE('America/Indiana/Indianapolis')
) AS M
ON M.mp_sup_key = F.mp_sup_key
GROUP BY rating
ORDER BY rating ASC
