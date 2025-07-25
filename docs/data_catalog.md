Here’s a rephrased version of your **Gold Layer Data Catalog** documentation with the same structure and detail, but more natural and refined language:

---

# Gold Layer Data Catalog

## Overview

The Gold Layer represents curated, business-ready data designed to support analytics, reporting, and decision-making. It includes **dimension tables** and **fact tables** that capture key business entities and metrics.

---

### 1. **gold.dim\_customers**

* **Purpose:** Contains enriched customer information, including demographic and geographic attributes.
* **Columns:**

| Column Name      | Data Type    | Description                                                        |
| ---------------- | ------------ | ------------------------------------------------------------------ |
| customer\_key    | INT          | Surrogate key uniquely identifying each customer in the dimension. |
| customer\_id     | INT          | System-generated unique ID assigned to each customer.              |
| customer\_number | NVARCHAR(50) | External-facing alphanumeric ID used for customer tracking.        |
| first\_name      | NVARCHAR(50) | Customer's given name.                                             |
| last\_name       | NVARCHAR(50) | Customer's surname or family name.                                 |
| country          | NVARCHAR(50) | Customer's country of residence (e.g., 'Australia').               |
| marital\_status  | NVARCHAR(50) | Marital status of the customer (e.g., 'Married', 'Single').        |
| gender           | NVARCHAR(50) | Gender of the customer (e.g., 'Male', 'Female', 'n/a').            |
| birthdate        | DATE         | Customer’s date of birth in YYYY-MM-DD format.                     |
| create\_date     | DATE         | Date the customer record was created in the system.                |

---

### 2. **gold.dim\_products**

* **Purpose:** Holds descriptive information about products and their classifications.
* **Columns:**

| Column Name           | Data Type    | Description                                                             |
| --------------------- | ------------ | ----------------------------------------------------------------------- |
| product\_key          | INT          | Surrogate key uniquely identifying each product.                        |
| product\_id           | INT          | System-generated internal ID for the product.                           |
| product\_number       | NVARCHAR(50) | Structured product code used for categorization or inventory.           |
| product\_name         | NVARCHAR(50) | Full product name, typically including type, color, or size.            |
| category\_id          | NVARCHAR(50) | Unique ID linking the product to its category.                          |
| category              | NVARCHAR(50) | High-level classification of the product (e.g., Bikes, Components).     |
| subcategory           | NVARCHAR(50) | More granular classification within the product category.               |
| maintenance\_required | NVARCHAR(50) | Indicates if the product needs regular maintenance (e.g., 'Yes', 'No'). |
| cost                  | INT          | Base cost of the product in monetary units.                             |
| product\_line         | NVARCHAR(50) | Product series or line it belongs to (e.g., Road, Mountain).            |
| start\_date           | DATE         | Launch date when the product became available for sale or use.          |

---

### 3. **gold.fact\_sales**

* **Purpose:** Captures transactional sales data used for analysis and reporting.
* **Columns:**

| Column Name    | Data Type    | Description                                                         |
| -------------- | ------------ | ------------------------------------------------------------------- |
| order\_number  | NVARCHAR(50) | Unique ID assigned to each sales transaction (e.g., 'SO54496').     |
| product\_key   | INT          | Foreign key referencing the product in the dimension table.         |
| customer\_key  | INT          | Foreign key referencing the customer in the dimension table.        |
| order\_date    | DATE         | Date the order was placed.                                          |
| shipping\_date | DATE         | Date the order was shipped to the customer.                         |
| due\_date      | DATE         | Payment due date for the order.                                     |
| sales\_amount  | INT          | Total value of the sale for the line item, in whole currency units. |
| quantity       | INT          | Number of product units ordered in the transaction.                 |
| price          | INT          | Unit price of the product, in whole currency units.                 |

---

Let me know if you want to add example values, data types for specific SQL dialects, or integrate this with a metadata tool like AWS Glue or DataHub.
