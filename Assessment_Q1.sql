-- Question 1: High-Value Customers with Multiple Products
-- Objective: Identify customers with at least one funded savings plan AND one funded investment plan
-- Find customers with both funded savings and investment plans

SELECT 
    u.id AS owner_id,
    -- Merge first and last name for clearer identification
    CONCAT_WS(' ', u.first_name, u.last_name) AS name,
    -- Count number of funded savings plans per customer
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    -- Count number of funded investment plans per customer
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    -- Total deposits converted from kobo to naira
    ROUND(SUM(s.confirmed_amount) / 100, 2) AS total_deposits
FROM savings_savingsaccount s
-- Join plan details to access savings/investment type
JOIN plans_plan p ON s.plan_id = p.id
-- Join user table to get customer info
JOIN users_customuser u ON s.owner_id = u.id
-- Only include confirmed (funded) transactions
WHERE s.confirmed_amount > 0
-- Group by customer for aggregation
GROUP BY u.id, u.first_name, u.last_name
-- Only include customers with at least one of each plan type
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) > 0
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) > 0
-- Sort from highest to lowest total deposits
ORDER BY total_deposits DESC;

