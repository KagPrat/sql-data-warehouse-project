/*
======================================================================
Quality Checks
======================================================================
Scripts Purpose:
  This script performs numerous quality checks for data consistency, 
  accuracy, and standardization across the 'gold' schema. It checks 
  for:
  - Null or duplicate primary keys.
  - Foreign key integrity.

Usage Example:
  - Run through these checks after loading data into 'gold' layer.
  - Investigate and resolve any discrepancies found during the checks.
=======================================================================
*/

-- =======================================================================
-- Checking gold.dim_customers
-- =======================================================================
-- Check for duplicate customer numbers
-- Expectation: No results
SELECT customer_number, COUNT(*)
FROM gold.dim_customers
GROUP BY customer_number
HAVING COUNT(*) > 1


-- Check for data mismatch and NULLs
-- Expectation: Data integrated
SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE 
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender info
		ELSE COALESCE(ca.gen, 'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
	ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
	ON ci.cst_key = la.cid
ORDER BY 1, 2


-- Check Integrity
SELECT * FROM gold.dim_customers

-- =======================================================================
-- Checking gold.dim_products
-- =======================================================================
-- Check for duplicate product numbers
-- Expectation: No results
SELECT product_number, COUNT(*)
FROM gold.dim_products
GROUP BY product_number
HAVING COUNT(*) > 1

-- Check Integrity
SELECT * FROM gold.dim_products

-- =======================================================================
-- Checking gold.fact_sales
-- =======================================================================
-- Foreign Key Integrity
-- Expectation: No results
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
WHERE c.customer_key IS NULL
