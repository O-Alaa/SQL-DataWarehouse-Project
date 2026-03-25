/*
===============================================================================
Quality Checks - Gold Layer
===============================================================================
Script Purpose:
    Validates structural integrity and model consistency of the Gold layer,
    ensuring it is reliable for analytical consumption.

    Focus areas:
    - Surrogate key uniqueness in dimension tables
    - Referential integrity between fact and dimensions
    - Completeness of dimensional mappings (no orphan fact records)

Usage Notes:
    - Any returned rows indicate data model issues that may impact reporting
    - Should be executed after Gold layer views are refreshed
===============================================================================
*/


-- ============================================================================
-- dim_customers
-- ============================================================================
-- Validate surrogate key uniqueness (dimension integrity requirement)
-- Expectation: 0 rows
SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY 
    customer_key
HAVING 
    COUNT(*) > 1;


-- ============================================================================
-- dim_products
-- ============================================================================
-- Validate surrogate key uniqueness for product dimension
-- Ensures stable joins from fact table
-- Expectation: 0 rows
SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY 
    product_key
HAVING 
    COUNT(*) > 1;


-- ============================================================================
-- fact_sales
-- ============================================================================
-- Validate referential integrity between fact and dimensions
-- Detects orphan records where foreign keys fail to resolve
-- Expectation: 0 rows
SELECT 
    * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE 
    p.product_key IS NULL 
    OR c.customer_key IS NULL;
