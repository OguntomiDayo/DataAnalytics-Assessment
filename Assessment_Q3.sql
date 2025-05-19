-- Assessment_Q3.sql
-- Question 3: Account Inactivity Alert
-- Objective: Find active savings or investment plans with no inflow in over 1 year


-- Step 1: Get latest confirmed deposit date per plan
WITH latest_tx AS (
    SELECT 
        plan_id,
        MAX(transaction_date) AS last_transaction_date
    FROM savings_savingsaccount
    WHERE confirmed_amount > 0
    GROUP BY plan_id
)

-- Step 2: Join plans and filter for inactive ones
SELECT 
    p.id AS plan_id,
    p.owner_id,
    -- Identify plan type for reporting
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    l.last_transaction_date,
    -- Calculate inactivity in days
    DATEDIFF(NOW(), l.last_transaction_date) AS inactivity_days    
FROM plans_plan p
-- Join to get last transaction per plan
JOIN latest_tx l ON p.id = l.plan_id
-- Filter to only savings/investment plans with no deposit in 365+ days
WHERE 
    DATEDIFF(NOW(), l.last_transaction_date) > 365
    AND (
        p.is_regular_savings = 1
        OR p.is_a_fund = 1
    )

ORDER BY inactivity_days DESC;
