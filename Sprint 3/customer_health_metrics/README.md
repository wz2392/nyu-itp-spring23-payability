# Step 2: Foucus on the Amazon Suppliers' Return Analysis
This week is to explore the status of return orders for each suppliers. In this dataset, the return_order’s data for each supplier is zero, which doesn’t make sense. To analyze the number of recent return orders for each supplier, I use the data from “returns” dataset to make calculation.
[## Query the Order Return Statistics for Each Supplier](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%203/customer_health_metrics/30days_return_analysis.sql)
1. Join the “returns” and “Cutomer_Health_Metrics” tables. <br>
2. Calculate the Return Rate for each supplier in last 30 days.<br>
3. Calculate the Return Amount for each supplier in last 30 days.<br>

