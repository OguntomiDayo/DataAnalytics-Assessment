-- Assessment_Q4.sql
-- Question 4: Customer Lifetime Value (CLV) Estimation
-- Objective: Estimate CLV for each customer based on transaction volume and tenure


-- Step 1: Calculate total transactions and average profit per customer
WITH customer_transactions AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        -- 0.1% of transaction value in naira
        ROUND(AVG(confirmed_amount * 0.001) / 100, 2) AS avg_profit_per_transaction
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),

-- Step 2: Calculate tenure in months from signup date
customer_tenure AS (
    SELECT 
        id AS customer_id,
        CONCAT_WS(' ', first_name, last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, NOW()) AS tenure_months
    FROM users_customuser
),

-- Step 3: Compute estimated CLV using the formula
clv_calc AS (
    SELECT 
        t.owner_id AS customer_id,
        c.name,
        c.tenure_months,
        t.total_transactions,
        ROUND((t.total_transactions / c.tenure_months) * 12 * t.avg_profit_per_transaction, 2) AS estimated_clv
    FROM customer_transactions t
    JOIN customer_tenure c ON t.owner_id = c.customer_id
    WHERE c.tenure_months > 0  -- avoid divide-by-zero
)

-- Step 4: Present final results ordered by CLV
SELECT * 
FROM clv_calc
ORDER BY estimated_clv DESC;