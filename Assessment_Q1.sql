-- Question 1: High-Value Customers with Multiple Products
-- Objective: Identify customers with at least one funded savings plan AND one funded investment plan

-- Find customers with both funded savings and investment plans
SELECT 
    u.id AS owner_id,
    CONCAT_WS(' ', u.first_name, u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits  -- Convert kobo to Naira
FROM savings_savingsaccount s
JOIN plans_plan p ON s.plan_id = p.id
JOIN users_customuser u ON s.owner_id = u.id
WHERE s.confirmed_amount > 0
GROUP BY u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) > 0
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) > 0
ORDER BY total_deposits DESC;
