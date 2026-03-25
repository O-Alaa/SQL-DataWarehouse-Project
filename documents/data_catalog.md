# 📊 Data Catalog — Gold Layer

## Overview
The **Gold Layer** represents the final, business-ready data model in the Data Warehouse.  
It is structured as a **star schema**, consisting of **dimension tables** and a **fact table**, optimized for analytics and reporting.

---

## 🧍 gold.dim_customers

**Purpose:**  
Contains enriched customer information by combining core CRM data with additional demographic and geographic attributes.

**Grain:**  
One record per customer.

### Columns

| Column Name     | Data Type     | Description |
|-----------------|---------------|-------------|
| customer_key    | INT           | Surrogate key uniquely identifying each customer record in the dimension. |
| customer_id     | INT           | Business identifier of the customer from the source system. |
| customer_number | NVARCHAR(50)  | Alphanumeric customer reference used across systems. |
| first_name      | NVARCHAR(50)  | Customer's first name. |
| last_name       | NVARCHAR(50)  | Customer's last name. |
| country         | NVARCHAR(50)  | Customer's country of residence. |
| marital_status  | NVARCHAR(50)  | Standardized marital status (e.g., 'Married', 'Single'). |
| gender          | NVARCHAR(50)  | Standardized gender value (e.g., 'Male', 'Female', 'n/a'). |
| birthdate       | DATE          | Customer's date of birth (YYYY-MM-DD). |
| create_date     | DATE          | Record creation date in the source system. |

---

## 📦 gold.dim_products

**Purpose:**  
Provides product master data enriched with category hierarchy and business classifications.

**Grain:**  
One record per active product.

### Columns

| Column Name          | Data Type     | Description |
|----------------------|---------------|-------------|
| product_key          | INT           | Surrogate key uniquely identifying each product record in the dimension. |
| product_id           | INT           | Internal product identifier from the source system. |
| product_number       | NVARCHAR(50)  | Business-facing product code. |
| product_name         | NVARCHAR(50)  | Descriptive product name. |
| category_id          | NVARCHAR(50)  | Identifier linking the product to its category. |
| category             | NVARCHAR(50)  | High-level product classification (e.g., Bikes, Components). |
| subcategory          | NVARCHAR(50)  | Detailed classification within the category. |
| maintenance_required | NVARCHAR(50)  | Indicates if maintenance is required ('Yes', 'No'). |
| cost                 | INT           | Base cost of the product. |
| product_line         | NVARCHAR(50)  | Product line classification (e.g., Road, Mountain). |
| start_date           | DATE          | Date when the product became active/available. |

---

## 💰 gold.fact_sales

**Purpose:**  
Captures transactional sales data for analytical and reporting use cases.

**Grain:**  
One record per sales transaction line.

### Columns

| Column Name   | Data Type     | Description |
|---------------|---------------|-------------|
| order_number  | NVARCHAR(50)  | Unique identifier for each sales order. |
| product_key   | INT           | Foreign key referencing `dim_products`. |
| customer_key  | INT           | Foreign key referencing `dim_customers`. |
| order_date    | DATE          | Date when the order was placed. |
| shipping_date | DATE          | Date when the order was shipped. |
| due_date      | DATE          | Payment due date for the order. |
| sales_amount  | INT           | Total sales amount for the transaction line. |
| quantity      | INT           | Number of units sold. |
| price         | INT           | Price per unit. |
