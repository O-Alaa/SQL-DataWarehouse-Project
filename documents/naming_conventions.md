## 🧭 Naming Conventions Guide

**Purpose:**  
This document defines standardized naming conventions for schemas, tables, views, columns, and stored procedures within the Data Warehouse.  
The goal is to ensure consistency, readability, and maintainability across all layers.

---

## General Principles

- Use **snake_case** (lowercase words separated by underscores).
- Use **English** for all object names.
- Avoid **SQL reserved keywords**.
- Prefer **clear and descriptive names** over abbreviations.

---

## Table Naming Conventions

### Bronze Layer (Raw Data)

- Prefix with the **source system** name.
- Preserve the **original entity name** (no renaming).
- **Pattern:** `<source_system>_<entity>`
- **Example:** `crm_customer_info`

---

### Silver Layer (Cleaned Data)

- Prefix with the **source system** name.
- Preserve the **original entity name** (no renaming).
- **Pattern:** `<source_system>_<entity>`
- **Example:** `crm_customer_info`

---

### Gold Layer (Business Layer)

- Use **business-friendly, meaningful names**.
- Prefix with a **table category**.
- **Pattern:** `<category>_<entity>`

**Examples:**
- `dim_customers`
- `fact_sales`

| Prefix     | Meaning           | Example(s)                          |
|------------|------------------|-------------------------------------|
| `dim_`     | Dimension table  | `dim_customer`, `dim_product`       |
| `fact_`    | Fact table       | `fact_sales`                        |
| `report_`  | Reporting table  | `report_customers`, `report_sales_monthly` |

---

## Column Naming Conventions

### Surrogate Keys

- Use suffix `_key` for dimension primary keys.
- **Pattern:** `<entity>_key`
- **Example:** `customer_key`

---

### Technical Columns

- Prefix system-generated metadata columns with `dwh_`.
- **Pattern:** `dwh_<description>`
- **Example:** `dwh_load_date`

---

## Stored Procedure Naming Conventions

- Use a consistent naming pattern for data loading procedures.
- **Pattern:** `load_<layer>`

**Examples:**
- `load_bronze`
- `load_silver`
- `load_gold`
