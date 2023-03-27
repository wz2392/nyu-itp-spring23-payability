# Step 3: Rebuild the queries and confirm the relation
## Deep talk with the Payability team and found more tech issues in this part
I had a talk with Gregor, the CTO of Payability and Amy from sales team. The tranactions between Amazon and customers is far more complicated than I thought.
Regarding loan repayment, it is not a percentage of the current statement sales. It is usually a set amount that Amazon will take. The repayment rate is not a fixed percentage.
In a happy path scenario (the seller sold enough in 1 statement to cover the repayment of the loan) Amazon will not take repayment of the loan if that statement closes before next billing date on Amazon.
If the customer cycle has a bi-weekly loan, the repayment cycle is always every 14 days (assuming that the customer does not click the Pay Now button on Amazon.
The problem with the Pay Now button on Amazon is that it will close the current statement early and start a new 14-day statement. This becomes very problematic because creates discrepancies with payment cycles.
The situation is even worst when it is a monthly repayment schedule because repayments can get pushed out 40 days and then the following repayment cycle will be shorten to less than 28 days.
So for customer's level, I think my target is to find out which customer is at risk of not being able to repay the loan, and set an alert. For portfolio level, the purpose is finding all the customers with Amazon Loan what is our risk exposure on this portfolio at any given point in time.
