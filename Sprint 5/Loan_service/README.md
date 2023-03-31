# Step 5: Data validation and merging the dashboard
## Modificate the query and validate the data
In this sprint, I continue to modificate the query about the rate between the fund and loan. After discussion with Gregor, I changed my calculation fomula from SUM(amount of money to Amazon) /SUM(amount of money to Payability) to SUM(amount of money to Amazon) /[SUM(amount of money to Payability)+SUM(amount of money to Amazon)]. Because the loan amount is deducted before the payment is made, and I should add that to the calculation of ratio.

Beside of that, I narrowed the date range from the past year to the most recent record in the active customers in past 3 months. The reason for this modification is Payability only cares about the active users and only the latest records can shows the status of the account for now. Therefore [the final edition of query](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%205/Loan_service/new_ratio.sql) is done.

When validating the data with Amazon, I use the dashboards provided by the Payablity and managed to make the amount to payability match the amount to Amazon.
## Created health status calculated field in Looker Studio
In looker studio, I created a new calculated field called 'health status'. If the ratio of fund and loan is larger than 0.5, the account is in danger. Otherwise it is safe. The threshold is settled by the Payability team. They believe that when a customer give money to Amazon more than Payability, they are under too much presure.
