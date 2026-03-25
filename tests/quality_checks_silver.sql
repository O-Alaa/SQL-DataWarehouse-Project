/*
===============================================================================
Quality Checks - Silver Layer
===============================================================================
Script Purpose:
    Validates data quality post Silver load by identifying violations in:
    - Key integrity (nulls / duplicates)
    - String cleanliness (leading/trailing spaces)
    - Domain standardization (categorical values)
    - Temporal validity (date logic and ranges)
    - Business rule consistency across measures

Usage Notes:
    - Intended to run immediately after Silver load completion
    - Any returned records represent data quality issues requiring investigation
===============================================================================
*/

-- ============================================================================
-- crm_cust_info
-- ============================================================================
-- Validate uniqueness and presence of business key (cst_id)
-- Expectation: 0 rows
SELECT 
    cst_id,
    COUNT(*) 
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 
    OR cst_id IS NULL;

-- Detect residual whitespace that may break joins or aggregations
-- Expectation: 0 rows
SELECT 
    cst_key 
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Verify controlled domain values after standardization
SELECT DISTINCT 
    cst_marital_status 
FROM silver.crm_cust_info;


-- ============================================================================
-- crm_prd_info
-- ============================================================================
-- Ensure product identifier integrity (no duplicates or nulls)
-- Expectation: 0 rows
SELECT 
    prd_id,
    COUNT(*) 
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 
    OR prd_id IS NULL;

-- Detect formatting inconsistencies in product names
-- Expectation: 0 rows
SELECT 
    prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Validate cost completeness and enforce non-negative values
-- Expectation: 0 rows
SELECT 
    prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 
   OR prd_cost IS NULL;

-- Validate product line normalization output
SELECT DISTINCT 
    prd_line 
FROM silver.crm_prd_info;

-- Ensure temporal consistency for derived SCD boundaries
-- Expectation: 0 rows
SELECT 
    * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


-- ============================================================================
-- crm_sales_details
-- ============================================================================
-- Identify invalid raw date values prior to transformation logic
-- (useful for tracing upstream data issues)
SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
   OR LEN(sls_due_dt) != 8 
   OR sls_due_dt > 20500101 
   OR sls_due_dt < 19000101;

-- Validate chronological order of transactional events
-- Expectation: 0 rows
SELECT 
    * 
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Enforce derived business rule: sales = quantity * price
-- Also surfaces null/invalid numeric scenarios
-- Expectation: 0 rows
SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY 
    sls_sales, 
    sls_quantity, 
    sls_price;


-- ============================================================================
-- erp_cust_az12
-- ============================================================================
-- Validate realistic birthdate range (data sanity check)
-- Expectation: within acceptable historical bounds
SELECT DISTINCT 
    bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Validate gender normalization results
SELECT DISTINCT 
    gen 
FROM silver.erp_cust_az12;


-- ============================================================================
-- erp_loc_a101
-- ============================================================================
-- Verify country standardization output
SELECT DISTINCT 
    cntry 
FROM silver.erp_loc_a101
ORDER BY 
    cntry;


-- ============================================================================
-- erp_px_cat_g1v2
-- ============================================================================
-- Detect whitespace issues across categorical attributes
-- Expectation: 0 rows
SELECT 
    * 
FROM silver.erp_px_cat_g1v2
WHERE cat         != TRIM(cat) 
   OR subcat      != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Validate maintenance category domain
SELECT DISTINCT 
    maintenance 
FROM silver.erp_px_cat_g1v2;
