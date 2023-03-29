SELECT *, lateShipment_30_rate/100 AS LateShipmetnRate_30, validTracking_rate_30/100 AS VaildTrackingRate_30,
preFulfillmentCancellation_7_rate/100 AS preFulfillment_7rate
FROM `bigqueryexport-183608.amazon.customer_health_metrics` 
WHERE DATE(_PARTITIONTIME) = '2023-03-27'
