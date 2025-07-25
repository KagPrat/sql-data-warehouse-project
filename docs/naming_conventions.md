# **Naming Conventions**

This guide defines the standard naming conventions for schemas, tables, views, columns, stored procedures, and other objects within the data warehouse environment.

## **Contents**

1. [Core Guidelines](#core-guidelines)
2. [Table Naming Standards](#table-naming-standards)

   * [Bronze Layer](#bronze-layer)
   * [Silver Layer](#silver-layer)
   * [Gold Layer](#gold-layer)
3. [Column Naming Standards](#column-naming-standards)

   * [Surrogate Keys](#surrogate-keys)
   * [System Columns](#system-columns)
4. [Stored Procedures](#stored-procedure-naming)

---

## **Core Guidelines**

* **Case Format**: Use `snake_case` — lowercase letters with underscores separating words.
* **Language**: All names must be in English.
* **Avoid Reserved Words**: Do not use SQL reserved keywords for object names.

---

## **Table Naming Standards**

### **Bronze Layer**

* Table names must retain the original names from the source system and begin with the source system identifier.
* **Format**: `<source>_<entity>`

  * `<source>`: Name of the originating system (e.g., `crm`, `erp`)
  * `<entity>`: Original table name from the source
  * **Example**: `crm_customer_info` → Raw customer data ingested from the CRM system

### **Silver Layer**

* Follows the same structure as Bronze — using source system and original table names.
* **Format**: `<source>_<entity>`

  * Example: `erp_sales_orders` → Cleaned ERP sales order data

### **Gold Layer**

* Tables use clear, business-oriented names with a prefix denoting table type.
* **Format**: `<category>_<entity>`

  * `<category>`: Indicates table type — `dim` (dimension), `fact` (fact), etc.
  * `<entity>`: Descriptive business subject
  * **Examples**:

    * `dim_customers` → Customer dimension table
    * `fact_sales` → Sales transaction fact table

#### **Category Prefix Glossary**

| Prefix    | Description                | Examples                                   |
| --------- | -------------------------- | ------------------------------------------ |
| `dim_`    | Dimension table            | `dim_customer`, `dim_product`              |
| `fact_`   | Fact table                 | `fact_sales`                               |
| `report_` | Aggregated/reporting table | `report_customers`, `report_sales_monthly` |

---

## **Column Naming Standards**

### **Surrogate Keys**

* All primary keys in dimension tables must use the `_key` suffix.
* **Format**: `<entity>_key`

  * Example: `customer_key` → Primary key in the `dim_customers` table

### **System Columns**

* System-generated metadata columns must begin with the `dwh_` prefix.
* **Format**: `dwh_<purpose>`

  * `dwh_load_date` → Timestamp indicating when the record was loaded into the data warehouse

---

## **Stored Procedure Naming**

* Procedures for data loading follow a simple, descriptive naming convention:
* **Format**: `load_<layer>`

  * `<layer>`: Refers to the data layer — `bronze`, `silver`, or `gold`
  * **Examples**:

    * `load_bronze` → Procedure to load raw data into the Bronze layer
    * `load_silver` → Procedure for loading transformed data into the Silver layer

---

Let me know if you'd like a downloadable PDF version or this reformatted in a Confluence or Notion-friendly format.
