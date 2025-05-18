## Question 1: High-Value Customers with Multiple Products

**Objective**  
Identify customers who have at least one funded savings plan (`is_regular_savings = 1`) and at least one funded investment plan (`is_a_fund = 1`), using deposit transactions as a funding indicator.

**Approach**  
I joined `savings_savingsaccount` with `plans_plan` using `plan_id` to access plan types, and with `users_customuser` using `owner_id` to retrieve customer information. I filtered for records with `confirmed_amount > 0` (funded plans) and grouped the results by customer.

To get the customer's full name, I concatenated `first_name` and `last_name` using `CONCAT_WS`. Distinct plan IDs were counted separately for savings and investment plans. The `confirmed_amount` was aggregated and converted from kobo to naira by dividing by 100.

**Key SQL Techniques Used**  
- `CASE WHEN` within `COUNT(DISTINCT ...)` for conditional aggregation  
- `HAVING` clause to ensure presence of both product types  
- Use of `ROUND()` and monetary conversion  
- Use of `CONCAT_WS()` to construct full names when `name` is null

**Challenges**  
The `name` column was null for all records, so I constructed the customer name using `first_name` and `last_name`. Ensuring accurate counts of distinct plan IDs for each type was also critical.


## Question 2: Transaction Frequency Analysis

**Objective**  
To segment customers by how frequently they transact each month, using deposit records in `savings_savingsaccount`.

**Approach**  
- First, I grouped transactions by customer and by month (`%Y-%m`) to calculate the number of transactions each month.
- Then, I computed the average monthly transaction rate per customer by dividing total monthly transactions by the number of distinct months.
- Based on the average, each customer was classified into:
  - **High Frequency** (≥10/month)
  - **Medium Frequency** (3–9/month)
  - **Low Frequency** (≤2/month)
- Finally, I aggregated these categories to get the number of customers and their average monthly transaction volume.

**Key SQL Techniques Used**  
- Common Table Expressions (CTEs)
- `DATE_FORMAT()` for monthly grouping
- `CASE WHEN` for frequency labeling
- `ROUND()` for clean formatting
- `FIELD()` to maintain a custom order of categories

**Challenges**  
Ensuring time-aware aggregation meant properly grouping transactions by month before computing averages. This avoided inflating transaction counts for customers with long histories but low activity.


## Question 3: Account Inactivity Alert

**Objective**  
To identify all active savings and investment plans that have had no confirmed deposit transactions in the last 365 days.

**Approach**  
1. Queried the `savings_savingsaccount` table to get the most recent `transaction_date` per plan with confirmed inflows.
2. Joined the result with the `plans_plan` table to get the plan type and owner.
3. Filtered for plans of type Savings (`is_regular_savings = 1`) or Investment (`is_a_fund = 1`).
4. Calculated the inactivity period using `DATEDIFF(NOW(), last_transaction_date)` and kept only those with more than 365 days of inactivity.

**Key SQL Techniques Used**  
- `MAX()` for last transaction
- `DATEDIFF()` for calculating inactivity in days
- `CASE` to classify plan type

**Challenges**  
Care was taken to ensure only funded plans were included by filtering on `confirmed_amount > 0`. We interpreted “active” as being of relevant type (not archived or deleted), but additional plan flags like `is_archived` could be added for stricter logic if needed.



## Question 4: Customer Lifetime Value (CLV) Estimation

**Objective**  
Estimate the Customer Lifetime Value (CLV) for each user based on their transaction volume and account tenure.

**Approach**  
1. From `savings_savingsaccount`, I calculated:
   - Total number of confirmed transactions per customer
   - Average profit per transaction (0.1% of transaction value)
2. From `users_customuser`, I calculated account tenure in months using `TIMESTAMPDIFF(MONTH, date_joined, NOW())`.
3. The CLV was computed using the formula:


