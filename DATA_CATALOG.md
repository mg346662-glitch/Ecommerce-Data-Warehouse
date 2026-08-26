# 📚 Enterprise Data Warehouse - Data Catalog

This document provides a comprehensive metadata dictionary and schema description for the analytical models implemented in this project.

---

## 1. Fact Tables

### 📊 `Fact_Sales`
* **Description:** Stores transactional sales metrics, quantities, pricing, and foreign keys linked to dimension tables.
* **Grain:** One row per order line item.

| Column Name | Data Type / Key | Description |
| :--- | :--- | :--- |
| `sls_ord_num` | **PK** (Primary Key) | Unique sales order number / transaction identifier. |
| `cst_id` | **FK** (Foreign Key) | Reference key linking to the customer dimension (`Dim_Customers`). |
| `sls_prd_key` | **FK** (Foreign Key) | Reference key linking to the product dimension (`Dim_Products`). |
| `sls_order_dt` | Date | The date when the order was placed. |
| `sls_ship_dt` | Date | The date when the order was shipped. |
| `sls_sales` | Numeric / Metric | Total sales amount for the transaction line. |
| `sls_quantity` | Numeric / Metric | Quantity of products ordered. |
| `sls_price` | Numeric / Metric | Unit price of the product sold. |

---

## 2. Dimension Tables

### 👤 `Dim_Customers`
* **Description:** Contains demographic and descriptive attributes of the customers.

| Column Name | Data Type / Key | Description |
| :--- | :--- | :--- |
| `Customer_key` | **PK** (Primary Key) | Surrogate key for the customer dimension. |
| `cst_id` | Integer | Original source customer ID. |
| `cst_key` | String | Unique business key for the customer. |
| `cst_firstname` | String | Customer's first name. |
| `cst_marital_status` | String | Marital status of the customer. |
| `nwe_gnder` | String | Gender attribute of the customer. |
| `cst_create_date` | Date | Date when the customer record was created. |
| `BDATE` | Date | Customer's birth date. |
| `CNTRY` | String | Country of residence. |
| `Age` | Integer | Calculated age of the customer. |

---

### 🛍️ `Dim_Products`
* **Description:** Contains detailed specifications, categories, and attributes of enterprise products.

| Column Name | Data Type / Key | Description |
| :--- | :--- | :--- |
| `Product_Key` | **PK** (Primary Key) | Surrogate key for the product dimension. |
| `Product_id` | Integer | Original source product ID. |
| `Product_Number` | String | Unique product identification number/SKU. |
| `Product_Cost` | Numeric | Cost price of the product. |
| `Product_Line` | String | Product line classification. |
| `prd_start_dt` | Date | Product introduction or validity start date. |
| `Category_id` | Integer | Identifier for the product category. |
| `Category` | String | Name of the product category. |
| `SUB_Category` | String | Name of the sub-category. |
| `MAINTENANCE` | String | Maintenance tier or status flag. |

---

### 📅 `Calendar` (Time Dimension)
* **Description:** Standard time dimension table used for time-series analysis and filtering.

| Column Name | Data Type / Key | Description |
| :--- | :--- | :--- |
| `Date` | **PK** (Primary Key) | Calendar date value. |
| `quarter` | String / Integer | Fiscal or calendar quarter (e.g., Q1, Q2). |
| `year` | Integer | Year value (e.g., 2026). |
| `Month` | String / Integer | Month name or number. |
