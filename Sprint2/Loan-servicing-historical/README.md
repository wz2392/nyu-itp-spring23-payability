# First Step: Understanding the business model of Payability
## Investigation on the business model of Payability
Payability is a financial technology (FinTech) company that provides funding and payment solutions to small businesses, particularly those who sell on online marketplaces like Amazon, Walmart, and Shopify. Their business model centers around providing fast and flexible access to cash flow for these businesses, which often face long payment cycles from their online marketplaces.

Payability offers two main products: Instant Access and Instant Advance. Instant Access allows businesses to receive their marketplace payouts the next day, rather than waiting up to two weeks for funds to clear. Instant Advance provides businesses with a lump sum of cash based on their marketplace sales, which is repaid over time using a percentage of future sales.

In exchange for these services, Payability charges a fee or a percentage of the funding provided, depending on the product and the amount of funding needed. Overall, Payability's business model is designed to help small businesses manage their cash flow more effectively and grow their online sales without being limited by slow payment cycles.
## Loan service historical data
Apart from Payability's service, some customers use the Amazon loan services. Merchants apply for a small business loan based on the credits of their store. And Amazon take a set amount of money in a certain time period.
In this data set:
- Amount: The amount of money transactions between Amazon and merchants.
- Currency: The type of currency used.
- Posted_date: Timestamp for each transaction.
- Type: There are two types of transaction.LoanPayment means the repayment of loans to the Amazon platform. LoanAdvance means the new loan created by the merchant
- Path_golden: The unique path for each transaction.
## Basic queries on the data
- [How many merchant use Amazon’s loan service? ](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint2/Loan-servicing-historical/merchant_num_with_loan.sql)
- [loan statement for a particular merchant](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint2/Loan-servicing-historical/Loan-by-merchant.sql)
- [what the merchant is selling](https://github.com/wz2392/nyu-itp-spring23-payability/blob/main/Sprint2/Loan-servicing-historical/Listing-by-merchant.sql)
