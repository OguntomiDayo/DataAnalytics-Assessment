-- Assessment_Q3.sql
-- Question 3: Account Inactivity Alert

WITH latest_tx AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY plan_id
)

SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    l.last_transaction_date,
    DATEDIFF(NOW(), l.last_transaction_date) AS inactivity_days
FROM plans_plan p
JOIN latest_tx l ON p.id = l.plan_id
WHERE 
    DATEDIFF(NOW(), l.last_transaction_date) > 365
    AND (
        p.is_regular_savings = 1
        OR p.is_a_fund = 1
    )
ORDER BY inactivity_days DESC;
