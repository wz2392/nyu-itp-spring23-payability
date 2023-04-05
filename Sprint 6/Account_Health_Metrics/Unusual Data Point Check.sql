## Check each supplier's listing violation situtaion on 2022-12-06

SELECT mp_sup_key, listingPolicyData_defectCount 
FROM `bigqueryexport-183608.amazon.customer_health_metrics` 
WHERE DATE(snapshot_date) = "2022-12-06" 
ORDER BY listingPolicyData_defectCount DESC

## Check the active listing change of specific supplier with unusual data

SELECT partition_date,COUNT(*) AS Active_Listings_Count
FROM `bigqueryexport-183608.amazon.listings` 
WHERE mp_sup_key = "ed5d6081-5d64-4e0f-8f91-07f41bae41d1"
AND status = "Active" 
GROUP BY partition_date
ORDER BY partition_date ASC
