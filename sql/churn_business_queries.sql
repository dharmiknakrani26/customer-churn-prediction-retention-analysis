/*
Project: Customer Churn Analytics, Revenue Risk & Retention Optimization

Business Goal:
Analyze customer churn patterns, identify high-risk customer segments,
estimate revenue at risk, and support retention strategy decisions.

Dataset:
Cleaned Telco Customer Churn dataset

Assumed SQL Server Database:
CustomerChurnDB

Assumed Table Name:
cleaned_customer_churn
*/

USE CustomerChurnDB;
GO

-- 1. View sample data
SELECT TOP 10 *
FROM cleaned_customer_churn;
GO

-- 2. Count total customers
SELECT COUNT(*) AS total_customers
FROM cleaned_customer_churn;
GO

-- 3. Churn count
SELECT 
    CASE WHEN ChurnFlag = 1 THEN 'Yes' ELSE 'No' END AS Churn_Status,
    COUNT(*) AS customer_count
FROM cleaned_customer_churn
GROUP BY ChurnFlag;
GO

-- 4. Overall churn rate
SELECT 
    CAST(
        AVG(CASE WHEN ChurnFlag = 1 THEN 1.0 ELSE 0.0 END) * 100 
        AS DECIMAL(10,2)
    ) AS churn_rate_percentage
FROM cleaned_customer_churn;
GO

-- 5. Churn rate by contract type
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN ChurnFlag = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(AVG(CASE WHEN ChurnFlag = 1 THEN 1.0 ELSE 0.0 END) * 100 AS DECIMAL(10,2)) AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY Contract
ORDER BY churn_rate_percentage DESC;
GO

-- 6. Churn rate by payment method
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN ChurnFlag = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(AVG(CASE WHEN ChurnFlag = 1 THEN 1.0 ELSE 0.0 END) * 100 AS DECIMAL(10,2)) AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_percentage DESC;
GO

-- 7. Churn rate by tenure group
SELECT 
    TenureGroup,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN ChurnFlag = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(AVG(CASE WHEN ChurnFlag = 1 THEN 1.0 ELSE 0.0 END) * 100 AS DECIMAL(10,2)) AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY TenureGroup
ORDER BY churn_rate_percentage DESC;
GO

-- 8. Total estimated annual revenue
SELECT CAST(SUM(EstimatedAnnualRevenue) AS DECIMAL(18,2)) AS total_estimated_annual_revenue
FROM cleaned_customer_churn;
GO

-- 9. Total estimated annual revenue at risk
SELECT CAST(SUM(RevenueAtRisk) AS DECIMAL(18,2)) AS total_revenue_at_risk
FROM cleaned_customer_churn;
GO

-- 10. Customer count by risk segment
SELECT 
    CustomerRiskSegment,
    COUNT(*) AS total_customers
FROM cleaned_customer_churn
GROUP BY CustomerRiskSegment
ORDER BY total_customers DESC;
GO

-- 11. Churn rate by customer risk segment
SELECT 
    CustomerRiskSegment,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN ChurnFlag = 1 THEN 1 ELSE 0 END) AS churned_customers,
    CAST(AVG(CASE WHEN ChurnFlag = 1 THEN 1.0 ELSE 0.0 END) * 100 AS DECIMAL(10,2)) AS churn_rate_percentage
FROM cleaned_customer_churn
GROUP BY CustomerRiskSegment
ORDER BY churn_rate_percentage DESC;
GO

-- 12. Revenue at risk by customer risk segment
SELECT 
    CustomerRiskSegment,
    CAST(SUM(RevenueAtRisk) AS DECIMAL(18,2)) AS total_revenue_at_risk
FROM cleaned_customer_churn
GROUP BY CustomerRiskSegment
ORDER BY total_revenue_at_risk DESC;
GO

-- 13. High-value churned customers
SELECT TOP 20
    customerID,
    Contract,
    PaymentMethod,
    tenure,
    MonthlyCharges,
    EstimatedAnnualRevenue,
    TotalCharges,
    CustomerRiskSegment,
    ChurnFlag
FROM cleaned_customer_churn
WHERE ChurnFlag = 1
ORDER BY EstimatedAnnualRevenue DESC;
GO

-- 14. Retention priority customers
SELECT TOP 20
    customerID,
    Contract,
    PaymentMethod,
    tenure,
    MonthlyCharges,
    EstimatedAnnualRevenue,
    CustomerRiskSegment,
    ChurnFlag
FROM cleaned_customer_churn
WHERE ChurnFlag = 0
  AND CustomerRiskSegment IN ('High Risk', 'Medium Risk')
ORDER BY EstimatedAnnualRevenue DESC;
GO
