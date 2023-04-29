# Step 7: Modify according to comments and new table
## Additional modifications on loan table
In this sprint, based on the suggestions from Payability team, I rebuilt the time serise chart. 
The past version is the loan and statement amount by month while the sales team want it show the contrast of the total sales and the loan amount. 
From my perspective, the sales amount is complicated and hard to evaluate by simple adds up. 
But the rough number may be close. So I created the calculated feild for the sum on Looker studio show it on the new time series chart.

Besides of that, I created a new KPI which shows [the most recent loan advance amount](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%207/loan-statement/most%20recent%20loan%20advance.sql).
We will know in the most recent loan cycle, how much money the merchant own to Amazon.

## New table: status table
For this table, the main kpi is the status of the merchant. Whether it is NORMAL, DEACTIVATED or AT_RISK. Based on the selection [status query](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%207/loan-statement/heath-status.sql), I created a new chart.
However, the Looker studio crashed when I try to merge it to the whole dashboard, this situation is unsloved by now.
