SELECT F.date, F.mp_sup_key AS mp_sup_key, F.rating, F.count, M.negativeFeedbacks_60_rate/100 AS Negative_Feedback_Rate_60
FROM
(SELECT date, mp_sup_key,rating,COUNT(*) AS count
FROM `bigqueryexport-183608.amazon.customer_feedback_metrics` 
WHERE parse_date('%m/%d/%y',date) >= '2022-01-01'
GROUP BY date,mp_sup_key,rating
) AS F
INNER JOIN
(SELECT mp_sup_key,negativeFeedbacks_60_rate
FROM `bigqueryexport-183608.amazon.customer_health_metrics` 
WHERE DATE(snapshot_date) = CURRENT_DATE('America/Indiana/Indianapolis')
) AS M
ON M.mp_sup_key = F.mp_sup_key

ORDER BY date DESC, mp_sup_key DESC, rating DESC
