# Data Analytics SQL Assessment

This repository contains solutions to a SQL assessment designed to evaluate my ability to query relational databases, perform aggregations, subqueries, filtering, and business logic transformations. The task was based on a schema that includes:

- `users_customuser`: Customer demographic and signup data
- `savings_savingsaccount`: Deposit transaction records
- `plans_plan`: Details of savings and investment plans
- `withdrawals_withdrawal`: Withdrawal transaction records

Each question's solution is provided as a `.sql` file, and sample results are accessible via shared Google Sheets for easy verification.

---

## 📊 Question 1: High-Value Customers with Multiple Products

**Objective**  
Identify customers with at least one funded savings plan and one funded investment plan, and rank them by total deposit value.

**Approach**  
- Joined `savings_savingsaccount` with `plans_plan` and `users_customuser`.
- Filtered only funded plans (`confirmed_amount > 0`).
- Counted distinct savings and investment plan IDs per customer.
- Calculated total deposits in naira (from kobo).

**Challenge**  
The `name` column in the users table was often null, so I used `CONCAT_WS(first_name, last_name)`.

**Sample Output**

| Owner ID | Name            | Savings | Investments | Total Deposits (₦) |
|----------|------------------|---------|-------------|---------------------|
| 1909df3e | Chima Ataman     | 2       | 8           | ₦890,312,200.00     |
| 5572810f | Obi David        | 82      | 45          | ₦389,632,600.00     |

**📎 [View full output](https://docs.google.com/spreadsheets/d/1oFtV2Y2KdefCac8WJucZh7DpLsneG2ut22ik01w5iKs/edit?usp=sharing)**

---

## 📊 Question 2: Transaction Frequency Analysis

**Objective**  
Segment customers based on how frequently they transact per month:
- High (≥10/month)
- Medium (3–9/month)
- Low (≤2/month)

**Approach**  
- Grouped transactions by customer and month using `DATE_FORMAT`.
- Calculated average monthly transaction rate per customer.
- Categorized customers with a `CASE` statement.

**Challenge**  
Accurately computing average frequency across multiple months and correctly grouping customers.

**Sample Output**

| Frequency Category | Customer Count | Avg Tx/Month |
|--------------------|----------------|--------------|
| High Frequency     | 141            | 44.72        |
| Medium Frequency   | 181            | 4.66         |
| Low Frequency      | 551            | 1.33         |

**📎 [View full output](https://docs.google.com/spreadsheets/d/1HaVbzbTq0scQvwq4ZjeOsiHSUQdqvsiGJe4F6zJOdGE/edit?usp=sharing)**

---

## 📊 Question 3: Account Inactivity Alert

**Objective**  
Flag active accounts with no deposit inflows in the past 365 days.

**Approach**  
- Selected max transaction date per plan (`MAX(transaction_date)`).
- Filtered plans inactive for over 1 year.
- Classified plan types using flags `is_regular_savings` and `is_a_fund`.

**Challenge**  
Handling plans with multiple transactions and accurately calculating inactivity using `DATEDIFF`.

**Sample Output**

| Plan ID         | Owner ID        | Type      | Last Tx Date        | Inactivity Days |
|------------------|------------------|-----------|----------------------|-----------------|
| ba6cda07...      | 0257625a...      | Savings   | 2016-09-18 19:07:14  | 3165            |
| c4f47b82...      | 0257625a...      | Savings   | 2016-10-08 15:03:45  | 3145            |

**📎 [View full output](https://docs.google.com/spreadsheets/d/1U50oCq-pocqK6nLhODVPZkTUP9GhTdfByQhuBbGLRaQ/edit?usp=sharing)**

---

## 📊 Question 4: Customer Lifetime Value (CLV) Estimation

**Objective**  
Estimate CLV using a simplified model based on tenure and transaction volume.

**Formula**  
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

**Approach**  
- Tenure = months since signup (`TIMESTAMPDIFF`).
- Profit = 0.1% of transaction value.
- Grouped by customer, calculated averages and applied formula.

**Challenge**  
Avoiding divide-by-zero for new customers with tenure of 0 months.

**Sample Output**

| Customer ID | Name              | Tenure (Months) | Total Tx | Estimated CLV (₦) |
|-------------|-------------------|------------------|----------|-------------------|
| 1909df3e... | Chima Ataman      | 33               | 1254     | ₦323,750.88       |
| 3097d111... | Obi Obi           | 25               | 583      | ₦103,778.66       |

**📎 [View full output](https://docs.google.com/spreadsheets/d/17kf1ODK4yAAjPRKw4Cpaid3NaYfe1cU4DQY4xmNZYOw/edit?usp=sharing)**

---