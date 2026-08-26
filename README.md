# 🏢 Enterprise Data Warehouse & Medallion Architecture Pipeline

## 📌 Project Architecture Overview
This project implements an end-to-end modern data warehousing pipeline. It ingests raw operational data from dual source systems (**CRM** and **ERP**), processes them through a **3-Tier Medallion Architecture (Bronze, Silver, Gold)**, integrates relational entities, and structures them into an optimized **Star Schema** for Business Intelligence.

---

## 🔄 Data Pipeline Journey & Flow

The lifecycle of the data progresses through distinct technical stages:
<img width="1089" height="620" alt="Midalien Arct_1" src="https://github.com/user-attachments/assets/4905fe04-9e58-4cb7-ac20-45337ed7fa63" />


### 1. Data Sources Layer
* **Source Systems:** 
  * **CRM System:** Manages customer information, product details, and sales transactions.
  * **ERP System:** Manages enterprise locations, product categories, and extended customer data.
* **File Formats & Interfaces:** Raw data is stored as **CSV files** accessed via designated folder interfaces.

### 2. Bronze Layer (Raw Data / Landing)
* **Object Type:** Tables (`Full Load`, `Truncate & Insert` strategy).
* **Process:** Ingests raw CSV files directly from CRM and ERP source folders with **zero transformations** and **no data modeling**.
* **Key Tables Ingested:**
  * *CRM:* `Crm_Customer_info`, `Crm_Product_info`, `Crm_Sales_info`
  * *ERP:* `Erb_Loc_info`, `Erb_Px_CAT`, `Erb_Cust_info`

### 3. Silver Layer (Cleaned & Standardized Data)
* **Object Type:** Tables (`Batch Processing`, `Truncate & Insert`).
* **Process:** Applies rigorous data cleansing, schema standardization, handling missing values, and deriving calculated columns.
* **Tables Maintained:** Cleaned parallel replicas of Bronze tables ensuring data integrity before enterprise integration.

### 4. Gold Layer (Business-Ready & Star Schema)
* **Object Type:** Database Views (`No Load`, focused on transformation and modeling).
* **Process:** Performs data integration across CRM and ERP silos, applies business logic, and aggregates metrics into analytical structures.
* **Data Models:** Structured into a high-performance **Star Schema**, Flat Tables, and Aggregated Tables.

---

## 🔗 Integration Model

To bridge the gap between disparate systems, the **Integration Model** harmonizes entities across platforms:
* **Sales Transactions (`Fact_Sales`):** Linked centrally using `Sls_prd_key` and `Sls_Cust_id` derived from CRM sales data.
* **Customer Integration:** Merges CRM customer tables (`Crm_Customer_info`) with ERP location and customer records (`Erp_Loc_info`, `Erp_Cust_info`) to build unified dimensions (`Dim_Customers`).
* **Product Integration:** Combines CRM product info (`Crm_Product_info`) with ERP category mappings (`Erp_Px_CAT`) to establish unified product dimensions (`Dim_Products`).

---

## 🌟 Dimensional Modeling (Star Schema)

The final analytical layer is modeled as a classic Star Schema comprising:
* **Fact Table:** `Fact_Sales` (containing transactional measures like sales price, quantity, and foreign keys).
* **Dimension Tables:** 
  * `Dim_Customers` (Customer demographic details, keys, and attributes).
  * `Dim_Products` (Product specifications, categories, and maintenance info).
  * `Calendar` (Time intelligence dimensions including year, quarter, month, and date).

---

## 🚀 Consumption & Reporting
The processed Gold layer feeds directly into downstream applications:
* **Power BI:** Interactive dashboards and visual analytics.
* **Enterprise Reporting:** Automated reporting services.
* **Machine Learning:** Predictive modeling and advanced analytics pipelines.

---

## 📂 Repository Structure
```text
├── Data_set/          # Raw CRM and ERP CSV source files
├── Docs/              # System architecture diagrams and data flow maps
├── Scripts/           # SQL scripts and ETL execution code
├── Tests/             # Data validation and quality assurance scripts
└── README.md          # Technical documentation
