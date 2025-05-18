-- Assessment_Q4.sql
-- Question 4: Customer Lifetime Value (CLV) Estimation

WITH customer_transactions AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        ROUND(AVG(confirmed_amount * 0.001) / 100, 2) AS avg_profit_per_transaction  -- from kobo to naira
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY owner_id
),
customer_tenure AS (
    SELECT 
        id AS customer_id,
        CONCAT_WS(' ', first_name, last_name) AS name,
        TIMESTAMPDIFF(MONTH, date_joined, NOW()) AS tenure_months
    FROM users_customuser
),
clv_calc AS (
    SELECT 
        t.owner_id AS customer_id,
        c.name,
        c.tenure_months,
        t.total_transactions,
        ROUND((t.total_transactions / c.tenure_months) * 12 * t.avg_profit_per_transaction, 2) AS estimated_clv
    FROM customer_transactions t
    JOIN customer_tenure c ON t.owner_id = c.customer_id
    WHERE c.tenure_months > 0  -- prevent divide-by-zero
)

SELECT * 
FROM clv_calc
ORDER BY estimated_clv DESC;
