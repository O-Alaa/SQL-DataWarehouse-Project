/*
=================================================================================
DDL Script : Create Gold Views
=================================================================================
Script Purpose :
  This script defines the Gold layer views in the Data Warehouse.

  The Gold layer represents the final presentation layer, structured as a 
  star schema (dimensions and fact tables) optimized for analytical querying.

  These views aggregate, enrich, and reshape data from the Silver layer into
  business-ready datasets, ensuring consistency and usability for reporting.

Usage :
  - Intended for direct consumption by BI tools, dashboards, and analytical queries.
=================================================================================
*/

--------------------------------------------------------------------------------
-- Dimension: Customers
-- Combines CRM (primary source) with ERP enrichment for demographics + location
-- Grain: One record per customer (latest snapshot from Silver layer)
--------------------------------------------------------------------------------
CREATE VIEW gold.dim_customers AS
SELECT
    -- Surrogate key generated for dimensional modeling (stable ordering assumed)
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,

    ci.cst_id        AS customer_id,
    ci.cst_key       AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname  AS last_name,

    -- Country sourced from ERP system (not available in CRM)
    la.cntry         AS country,

    ci.cst_marital_status AS marital_status,

    -- Gender prioritization:
    -- CRM is treated as the authoritative source; fallback to ERP if missing
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    ca.bdate            AS brithdate,
    ci.cst_create_date  AS create_date

FROM silver.crm_cust_info ci

-- Enrich with additional demographic attributes
LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.cid

-- Enrich with geographic attributes
LEFT JOIN silver.erp_loc_a101 la
    ON ci.cst_key = la.cid;


-- ================================================================================
-- Dimension: Products
-- Combines product master data with category hierarchy
-- Grain: Current active product version only (SCD filtered)
--------------------------------------------------------------------------------
CREATE VIEW gold.dim_products AS
SELECT
    -- Surrogate key ordered by business-relevant attributes for consistency
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,

    pn.prd_id   AS product_id,
    pn.prd_key  AS product_number,
    pn.prd_nm   AS product_name,

    pn.cat_id   AS category_id,
    pc.cat      AS category,
    pc.subcat   AS subcategory,
    pc.maintenance,

    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date

FROM silver.crm_prd_info pn

-- Attach category hierarchy from ERP reference table
LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pn.cat_id = pc.id

-- Retain only the current active product record (exclude historical versions)
WHERE prd_end_dt IS NULL;


-- ================================================================================
-- Fact: Sales
-- Transactional fact table linking customers and products
-- Grain: One row per sales transaction line
--------------------------------------------------------------------------------
CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,

    -- Foreign keys referencing dimension tables (star schema design)
    pr.product_key,
    cu.customer_key,

    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,

    -- Measures (validated in Silver layer)
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price

FROM silver.crm_sales_details sd

-- Resolve product surrogate key via business key mapping
LEFT JOIN gold.dim_products pr
    ON sd.sls_prd_key = pr.product_number

-- Resolve customer surrogate key via business key mapping
LEFT JOIN gold.dim_customers cu
    ON sd.sls_cust_id = cu.customer_id;
