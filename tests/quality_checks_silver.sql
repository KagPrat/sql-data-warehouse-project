/*
======================================================================
Quality Checks
======================================================================
Scripts Purpose:
  This script performs numerous quality check for data consistency, 
  accuracy and standardization across the 'silver' schema. It checks 
  for:
  - Null or duplicate primary keys.
  - Unwanted spaces in string fields.
  - Data standardization and consistency.
  - Invalid date ranges and orders.
  - Data consistency between related fields.

Usage Example:
  - Run through these checks after loading data into 'silver' layer.
  - Investigate and resolve any discrepencies found during the checks.
=======================================================================
*/

-- =======================================================================
-- Checking silver.crm_cust_info
-- =======================================================================
-- Check for duplicate primary keys or NULLS
-- Expectation: No Results
SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for extra whitspace
-- Expectation: No Results
SELECT
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT
cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

-- Check if data is standardized and consistent
-- Expectation: Standardized readable data
SELECT 
DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT 
DISTINCT cst_gndr
FROM silver.crm_cust_info;

-- Final Encompassing Look at Data
SELECT
*
FROM
silver.crm_cust_info;


-- =======================================================================
-- Checking silver.crm_prd_info
-- =======================================================================
-- Check for duplicate primary keys
-- Expectation: No Results
SELECT 
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for extra whitespace
-- Expectation: No Results
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check for NULLs or negative numbers
-- Expectation: No Results
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check if data is standardized and consistent
-- Expectation: Standardized readable data
SELECT 
DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check invalid date orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt

-- Check data
SELECT *
FROM silver.crm_prd_info

-- =======================================================================
-- Checking silver.crm_sales_details
-- =======================================================================

-- Check for extra whitespace
-- Expectation: No Results
SELECT sls_ord_num
FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num)

-- Check is data is not consistent across tables
-- Expectation: No Result
SELECT *
FROM silver.crm_sales_details
WHERE sls_prd_key NOT IN (
	SELECT prd_key 
	FROM silver.crm_prd_info
)

SELECT *
FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (
	SELECT cst_id 
	FROM silver.crm_cust_info
)

-- Check for invalid dates
-- Expectation: No result
SELECT
	NULLIF(sls_order_dt, 0), sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

-- Check invalid date orders
-- Expectation: No Results
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_due_dt

-- CheckData Consistency: Between Sales, Quantity, and Price
-- >> Sales = Quantity * Price
-- >> Expectation: Values mus not be NULL, zero, or negative
SELECT 
sls_sales, 
sls_quantity, 
sls_price
/* CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
	THEN sls_quantity * ABS(sls_price) 
	ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0  
	THEN CAST(ABS(sls_sales) / sls_quantity  AS NVARCHAR)
	ELSE sls_price	
END AS sls_price*/
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <=0 OR sls_price <=0

-- Check data
SELECT *
FROM silver.crm_sales_details

-- =======================================================================
-- Checking silver.erp_cust_az12
-- =======================================================================
-- Identify Out-of-Range Dates
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1925-01-01' OR bdate > GETDATE()

-- Data Standardization and Consistency
-- Expectation: two categories and 'n/a'
SELECT DISTINCT
CASE
	WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
	WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	ELSE 'n/a'
END AS gen
FROM silver.erp_cust_az12

-- Check data
SELECT *
FROM silver.erp_cust_az12

-- =======================================================================
-- Checking silver.erp_loc_a101
-- =======================================================================
-- Check for id conformity
-- Expectation: No id mismatch or outlier
SELECT
REPLACE (cid, '-', '') cid,
cntry
FROM silver.erp_loc_a101
WHERE REPLACE (cid, '-', '') NOT IN 
	(SELECT cst_key FROM silver.crm_cust_info)

-- Data Standardization and Consistency
SELECT DISTINCT 
CASE 
		WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
		WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		ELSE TRIM(cntry)
END AS cntry
FROM silver.erp_loc_a101
ORDER BY cntry

-- Check data
SELECT *
FROM silver.erp_loc_a101

-- =======================================================================
-- Checking silver.erp_px_cat_g1v2
-- =======================================================================
-- Check for unwanted spaces
-- Expectation: No results
SELECT 
*
FROM silver.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Standardization and consistency
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2

-- Check data
SELECT *
FROM silver.erp_px_cat_g1v2
