# Step 2: The relationship between statement and loan
## A potential rivalry
Payment to Amazon loan negatively correlated to Payment to Payability. 
The customer's ability to repay the debt is limited. The greater the debt repayment pressure from Amazon, the more likely it is to overdue repayment to the platform.
## Calculate the ratio between net balance of customer's account and the repayment
AS there are lots of duplicates in statement table, it is hard to calculate the sales for the customer. So I calculated the net balance of customer's account instead. By join the two queries of selecting net balance of customer's account and selecting the repayment amount, I come up with [the ratio](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%203/loan_service_historical/repayment_rate.sql).
But there are still some inadequacies:
- We need up to date data for these metric, but there are discrepancies between payment cycles and repayment cycles. So how to pridict the next payment date is crucial.
- To pridict next month's condition, we need the latest data, but the historical data is not updated in time.
Besides, I found that there are some customers that paid the Amazon loan but failed in paying the fund of payability. And I treated the customers who only use Amazon's services as [abnormal customers](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%203/loan_service_historical/abnormal_customer.sql). And in the meeting with Payability, they told me that some customers may not shut the API connection with Payability after they stop the service. So this guess is incorrect.
