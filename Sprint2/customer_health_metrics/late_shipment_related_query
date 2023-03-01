SELECT lateShipmentRate_status, 
    COUNT(*) AS CountNum,
    ROUND(AVG(lateShipment_30_rate),3) AS Avg_LateShipment_Rate, 
    ROUND(AVG(preFulfillmentCancellation_30_rate),3) AS Avg_preFulfillmentCancellation_Rate,
    ROUND(AVG(onTimeDelivery_rate_30),3) AS Avg_OnTimeDelivery_Rate,
    ROUND(AVG(validTracking_rate_30),3) AS Avg_ValidTracking_Rate
FROM `bigqueryexport-183608.amazon.customer_health_metrics` 
WHERE DATE(snapshot_date) > DATE_ADD(current_date('America/Indiana/Indianapolis'),INTERVAL -1 MONTH) 
    AND orders_count_30 > 500
GROUP BY lateShipmentRate_status
ORDER BY CASE WHEN lateShipmentRate_status = 'Good' THEN 1
              WHEN lateShipmentRate_status = 'Fair' THEN 2
              WHEN lateShipmentRate_status = 'Bad' THEN 3 
              ELSE 4 END;
