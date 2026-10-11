-- =====================================================
-- CUSTOMER CHURN ANALYSIS & PREDICTION
-- SQL ANALYSIS
-- =====================================================
--
-- Database: telco_churn_db
-- Table: telco_churn_cleaned
--
-- Objective:
-- Analyze customer churn patterns and identify customer
-- segments associated with higher churn.
--
-- Key SQL techniques used:
--   - SELECT and WHERE
--   - COUNT, SUM, AVG, MIN, MAX
--   - GROUP BY
--   - CASE WHEN
--   - HAVING
--   - ORDER BY
--   - LIMIT
--   - Multi-column aggregation
--   - SQL Views
--
-- Dataset size: 7,043 customers
--
-- =====================================================

USE telco_churn_db;

-- =====================================================
-- 1. DATASET OVERVIEW
-- =====================================================

-- Total number of customers
SELECT COUNT(*) AS total_customers
FROM telco_churn_cleaned;


-- Preview the dataset
SELECT *
FROM telco_churn_cleaned
LIMIT 10;


-- Inspect table structure
DESCRIBE telco_churn_cleaned;


-- =====================================================
-- 2. OVERALL CHURN ANALYSIS
-- =====================================================

SELECT 
    Churn,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM telco_churn_cleaned),
        2
    ) AS percentage
FROM telco_churn_cleaned
GROUP BY Churn;

-- =====================================================
-- 3. CHURN BY CONTRACT TYPE
-- =====================================================

SELECT
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn_cleaned
GROUP BY Contract
ORDER BY churn_rate DESC;


-- =====================================================
-- 4. CHURN BY INTERNET SERVICE
-- =====================================================

SELECT
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn_cleaned
GROUP BY InternetService
ORDER BY churn_rate DESC;


-- =====================================================
-- 5. CHURN BY TECH SUPPORT
-- =====================================================

SELECT
    TechSupport,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn_cleaned
GROUP BY TechSupport
ORDER BY churn_rate DESC;


-- =====================================================
-- 6. CHURN BY PAYMENT METHOD
-- =====================================================

SELECT
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn_cleaned
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;

-- =====================================================
-- 7. TENURE ANALYSIS BY CHURN STATUS
-- =====================================================

SELECT
    Churn,
    COUNT(*) AS total_customers,
    ROUND(AVG(tenure), 2) AS avg_tenure,
    MIN(tenure) AS min_tenure,
    MAX(tenure) AS max_tenure
FROM telco_churn_cleaned
GROUP BY Churn
ORDER BY Churn;


-- =====================================================
-- 8. MONTHLY CHARGES BY CHURN STATUS
-- =====================================================

SELECT
    Churn,
    COUNT(*) AS total_customers,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
    ROUND(MIN(MonthlyCharges), 2) AS min_monthly_charge,
    ROUND(MAX(MonthlyCharges), 2) AS max_monthly_charge
FROM telco_churn_cleaned
GROUP BY Churn
ORDER BY Churn;


-- =====================================================
-- 9. CHURN BY INTERNET SERVICE AND CONTRACT
-- =====================================================

SELECT
    InternetService,
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn_cleaned
GROUP BY InternetService, Contract
ORDER BY InternetService, churn_rate DESC;


-- =====================================================
-- 10. CHURN BY PAYMENT METHOD AND CONTRACT
-- =====================================================

SELECT
    PaymentMethod,
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn_cleaned
GROUP BY PaymentMethod, Contract
ORDER BY PaymentMethod, churn_rate DESC;

-- =====================================================
-- 11. CHURN RATE BY TENURE GROUP
-- =====================================================

SELECT
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49-72 months'
    END AS tenure_group,

    COUNT(*) AS total_customers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate

FROM telco_churn_cleaned

GROUP BY
    CASE
        WHEN tenure <= 12 THEN '0-12 months'
        WHEN tenure <= 24 THEN '13-24 months'
        WHEN tenure <= 48 THEN '25-48 months'
        ELSE '49-72 months'
    END

ORDER BY MIN(tenure);


-- =====================================================
-- 12. TOP 10 HIGH-RISK CUSTOMER SEGMENTS
-- =====================================================

SELECT
    Contract,
    InternetService,
    PaymentMethod,
    COUNT(*) AS total_customers,

    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        AS churned_customers,

    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*),
        2
    ) AS churn_rate

FROM telco_churn_cleaned

GROUP BY
    Contract,
    InternetService,
    PaymentMethod

HAVING COUNT(*) >= 50

ORDER BY churn_rate DESC

LIMIT 10;

-- =====================================================
-- 13. TOP 10 CHURNED CUSTOMERS BY TOTAL CHARGES
-- =====================================================

SELECT
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges,
    Contract,
    InternetService,
    PaymentMethod
FROM telco_churn_cleaned
WHERE Churn = 'Yes'
ORDER BY TotalCharges DESC
LIMIT 10;


-- =====================================================
-- 14. CREATE CUSTOMER CHURN SUMMARY VIEW
-- =====================================================

CREATE OR REPLACE VIEW customer_churn_summary AS
SELECT
    customerID,
    tenure,
    Contract,
    InternetService,
    PaymentMethod,
    TechSupport,
    MonthlyCharges,
    TotalCharges,
    Churn
FROM telco_churn_cleaned;


-- Test the view
SELECT *
FROM customer_churn_summary
LIMIT 10;

-- =====================================================
-- KEY BUSINESS FINDINGS
-- =====================================================
--
-- 1. Overall churn rate: 26.54%
--
-- 2. Month-to-month customers had the highest contract
--    churn rate: 42.71%.
--
-- 3. Fiber optic customers had the highest internet
--    service churn rate: 41.89%.
--
-- 4. Customers without Tech Support had a churn rate
--    of 41.64%, compared with 15.17% for customers
--    with Tech Support.
--
-- 5. Electronic check customers had the highest
--    payment-method churn rate: 45.29%.
--
-- 6. Customers with 0-12 months tenure had a churn
--    rate of 47.44%, compared with 9.51% for customers
--    with 49-72 months tenure.
--
-- 7. The highest-risk sizeable segment was:
--    Month-to-month + Fiber optic + Electronic check
--    Churn rate: 60.37%
--
-- Note:
-- These results describe associations in the dataset
-- and should not be interpreted as causal relationships.
--
-- =====================================================
-- END OF SQL ANALYSIS
-- =====================================================
