use insurance_analytics;
show tables;
select * from meeting;

-- 1.
SELECT 
    `Account Executive`,
    COUNT(policy_number) AS total_invoices
FROM invoice
GROUP BY `Account Executive`
ORDER BY total_invoices DESC;

-- 2.
SELECT 
    YEAR(meeting_date) AS year,
    COUNT(*) AS meeting_count
FROM meeting
GROUP BY  YEAR(meeting_date)
ORDER BY year, meeting_count DESC;

-- 3,4,5

-- KPI: Target vs Achieved vs New (All Categories)

-- 🟠 CROSS SELL
WITH 
cross_target AS (
    SELECT SUM(`Cross sell bugdet`) AS Target
    FROM target
),
cross_achieved AS (
    SELECT SUM(Amount) AS Achieved
    FROM brokerage
    WHERE TRIM(UPPER(income_class)) = 'CROSS SELL'
),
cross_new AS (
    SELECT SUM(Amount) AS NewBusiness
    FROM invoice
    WHERE TRIM(UPPER(income_class)) = 'CROSS SELL'
),

-- 🔵 NEW
new_target AS (
    SELECT SUM(`New Budget`) AS Target
    FROM target
),
new_achieved AS (
    SELECT SUM(Amount) AS Achieved
    FROM brokerage
    WHERE TRIM(UPPER(income_class)) = 'NEW'
),
new_new AS (
    SELECT SUM(Amount) AS NewBusiness
    FROM invoice
    WHERE TRIM(UPPER(income_class)) = 'NEW'
),

-- 🟢 RENEWAL
renewal_target AS (
    SELECT SUM(`Renewal Budget`) AS Target
    FROM target
),
renewal_achieved AS (
    SELECT SUM(Amount) AS Achieved
    FROM brokerage
    WHERE TRIM(UPPER(income_class)) = 'RENEWAL'
),
renewal_new AS (
    SELECT SUM(Amount) AS NewBusiness
    FROM invoice
    WHERE TRIM(UPPER(income_class)) = 'RENEWAL'
)

-- 🧾 FINAL OUTPUT (Combine all 3 categories)
SELECT 
    'Cross Sell' AS Category,
    COALESCE(cross_target.Target, 0) AS Target,
    COALESCE(cross_achieved.Achieved, 0) AS Achieved,
    COALESCE(cross_new.NewBusiness, 0) AS NewBusiness
FROM cross_target
CROSS JOIN cross_achieved
CROSS JOIN cross_new

UNION ALL

SELECT 
    'New' AS Category,
    COALESCE(new_target.Target, 0),
    COALESCE(new_achieved.Achieved, 0),
    COALESCE(new_new.NewBusiness, 0)
FROM new_target
CROSS JOIN new_achieved
CROSS JOIN new_new

UNION ALL

SELECT 
    'Renewal' AS Category,
    COALESCE(renewal_target.Target, 0),
    COALESCE(renewal_achieved.Achieved, 0),
    COALESCE(renewal_new.NewBusiness, 0)
FROM renewal_target
CROSS JOIN renewal_achieved
CROSS JOIN renewal_new;

-- 6
SELECT 
    stage,
    SUM(revenue_amount) AS total_revenue
FROM opportunity
GROUP BY stage
ORDER BY FIELD(stage, 'Qualify Opportunity', 'Propose Solution', 'Negotiate');

-- 7.

SELECT 
    `Account Executive`,
    COUNT(*) AS total_meetings
FROM meeting
GROUP BY `Account Executive`
ORDER BY total_meetings DESC;

-- 8

SELECT 
    opportunity_name,
    `Account Executive`,
    revenue_amount,
    stage
FROM opportunity
WHERE stage IN ('Qualify Opportunity', 'Propose Solution', 'Negotiate')
ORDER BY revenue_amount DESC
LIMIT 10;


