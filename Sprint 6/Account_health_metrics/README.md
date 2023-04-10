## Step 5: Integrate the Timeseries Charts of Health Metrics to Dashboard
This week's job was to integrate all of last week's health numerical indicators in timeline charts in the dashboard. This can be done by setting a past period of time to see the overall suppliers account health, or the trend of one or more metrics for individual supplier over time.
### Dashboard 1: Customer Service Performance part and Policy Compliance part: <br>
![image](https://user-images.githubusercontent.com/99241150/230806632-732dd680-c6b5-4320-b68f-3c80f960dfe2.png)
### Dashboard 2: Shipping Performance part: <br>
![image](https://user-images.githubusercontent.com/99241150/230855875-ba0df727-d1d8-48ff-8981-877360a0d70d.png) <br>
**Added the control of filtering supplier key and the control of adjusting date range to the dashboards above. <br>
### Cross Validation on Unusual Point in the Chart [BigQuery](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%206/Account_health_metrics/Unusual%20Data%20Point%20Check.sql) <br>
- For the line of the Number of Listing Violation.
- Found ed5d6081-5d64-4e0f-8f91-07f41bae41d1 had a very large number of listing policy violations on 2022-12-06.
- Its number of the active listed asin (products) significantly decrease after that day, which may be majorly caused by these violations.


