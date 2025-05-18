-- Assessment_Q2.sql
-- Question 2: Transaction Frequency Analysis

WITH monthly_tx_per_customer AS (
    SELECT 
        owner_id,
        DATE_FORMAT(transaction_date, '%Y-%m') AS tx_month,
        COUNT(*) AS monthly_tx_count
    FROM savings_savingsaccount
    GROUP BY owner_id, DATE_FORMAT(transaction_date, '%Y-%m')
),

avg_tx_per_customer AS (
    SELECT 
        owner_id,
        ROUND(SUM(monthly_tx_count) / COUNT(DISTINCT tx_month), 2) AS avg_tx_per_month
    FROM monthly_tx_per_customer
    GROUP BY owner_id
),

categorized_customers AS (
    SELECT 
        owner_id,
        CASE 
            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
            WHEN avg_tx_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_tx_per_month
    FROM avg_tx_per_customer
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_tx_per_month), 2) AS avg_transactions_per_month
FROM categorized_customers
GROUP BY frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');