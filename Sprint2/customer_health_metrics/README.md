# Payability's Business Model and Customer Dynamic Operating Conditions (Amazon Customer)
Payability offers customers, particularly those who are Amazon sellers, an advance cash access on order sales with a percentage of the service fee. The revenue from this service depends heavily on the behavioral health of the customer on the Amazon platform. If a customer's orders on Amazon have a tendency to be refunded in large numbers, or if the sales have a particularly long payback cycle due to customer service issues, this can affect Payability's operation profitability.

## Look on the Amazon Sellers' Health Metrics Table:
In this customer_health_metrics dataset, you can get the information (More than 140 fields) of the related suppliers in terms of their Amazon account performance of sellings and policies, and this data is updated daily. These mainly includes three areas:<br>
```
1.Customer Service Performance:<br>
Like Negative Feedbacks Rate or Response Hours<br>
2.Product policy compliance<br>
Like Intellectual Property Status or Defect Listing Count<br>
3.Shipping Performance<br>
Like Late Shipment Rate or On-time Delivery Rate<br>
```
## Focused Varibales and futher Observations
### Variables:
```
1.lateShipmentRate_status: The status of late shipment rate of market suppliers, classified as good, fair and bad.<br>
2.lateShipment_30_rate: The last 30 days of the supplier's late shipment rate.<br>
3.preFulfillmentCancellation_30_rate: Rate of cancellation of orders before shipment for the supplier in the last thirty days.<br>
4.onTimeDelivery_Rate_30: On-time delivery rate of orders in the past 30 days.<br>
5.validTracking_Rate_30: Rate of orders with valid tracking information for the past thirty days.
```
### Observations:
1. [Relation between defective rate and cancellation rate](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint2/customer_health_metrics/defect_cancellation_flag_supplier_query)
2. [How are the status of sellers' order shipments?](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint2/customer_health_metrics/late_shipment_related_query)
3. [Classify the policy violation level and their average violation number.](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint2/customer_health_metrics/policy_violation_flag_query)
