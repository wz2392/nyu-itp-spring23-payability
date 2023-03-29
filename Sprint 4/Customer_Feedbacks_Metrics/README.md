## Step 3: Explore the Suppliers' Customer Feedbacks Details
This table gives us the detail of each feedback customer given to the seller.From this table we can get an idea of 
what kind of customer feedback each supplier has received in the recent past, the reasons why customers leave feedback with certain rating 
or the rating habits of customers leaving feedback.<br>
The two key features of this table are: 
- Rating: The rating of customer feedback on orders, 1 being the lowest 3 being the best.
- Order ID: Unique identification for each order
# Basic Findings:
**1.** To see the recent feedbacks details among all the suppliers, setting the where clause to show only last 90-day records. [BigQuery Code](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%204/Customer_Feedbacks_Metrics/Feedback%20Rating%20Rank.sql)<br>

From the result, we believe feedbacks are mostly given with lower ratings, as customers may not provide feedback if there are not major problems with the order.<br>

**2.** Querying to see the top sellers who have received the most rating 1 in the last 90 days. [BigQuery Code](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint%204/Customer_Feedbacks_Metrics/Feedback%20Rating%20Timeseries.sql)<br>

However, we cannot only see the total number of the lowest rating feedbacks for each supplier to evaluate the supplier's service or selling behavior. Considering with their vary order volumes, the rate of negative feedback is the indicator for evaluating.<br>

# Dashoboard Making Logic:




