SELECT *, lateShipment_30_rate/100 AS LateShipmetnRate_30, validTracking_rate_30/100 AS VaildTrackingRate_30,
preFulfillmentCancellation_7_rate/100 AS preFulfillment_7rate
FROM `bigqueryexport-183608.amazon.customer_health_metrics`
inner join
(
SELECT max(snapshot_date) AS LatestDate, mp_sup_key AS suppliers
  FROM`bigqueryexport-183608.amazon.customer_health_metrics`
  GROUP BY mp_sup_key) AS submax
  on snapshot_date = submax.LatestDate AND mp_sup_key = submax.suppliers

