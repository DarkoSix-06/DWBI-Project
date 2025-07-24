# DWBI Project: Olist E-commerce Data Warehouse and BI Solution

![dwbii](https://github.com/user-attachments/assets/c6920c2c-9a5a-49c2-9661-103de1c29804)

## 📌 Overview

This project is a comprehensive Data Warehousing and Business Intelligence (DWBI) solution built for the **Olist E-commerce dataset**, simulating a real-world online retail system. It uses SQL Server, SSIS for ETL, SSAS for cube creation, and Power BI for analytical reporting.

---

## 📊 Business Use Case

**Objective:** Analyze how shipping costs affect product profitability by integrating and transforming data from multiple sources into a star schema and delivering insights via OLAP and Power BI.

---
## 📊 Dashboard
![1747555883843](https://github.com/user-attachments/assets/5acc3fc3-b4b7-434c-a9f4-3d33884dba36)
![1747555884754](https://github.com/user-attachments/assets/7968c83d-b081-48f2-a564-fbf653f7a46e)
![1747555882274](https://github.com/user-attachments/assets/cc124b23-3986-44b4-94e7-f1211d28810f)
![1747555882398](https://github.com/user-attachments/assets/4727a802-fd6f-481d-a4c7-b352afe426a1)


## 📁 Components

### 1. **Data Sources**
- Formats: CSV, Excel, and TXT
- Examples:
  - `olist_orders_dataset.csv`
  - `olist_customers_dataset.xlsx`
  - `olist_sellers_dataset.txt`

### 2. **SQL Server Data Warehouse**
- **Star Schema Design**
  - Fact Table: `Fact_Order`
  - Dimension Tables: `Dim_Customer`, `Dim_Seller`, `Dim_Product`, `Dim_Date`, `Dim_Geolocation`
- **SCD Type 2** implementation on `Customer` and `Seller` dimensions

### 3. **ETL with SSIS**
- Staging → Transformation → DW Load
- Uses:
  - Derived columns
  - Lookups
  - Slowly Changing Dimensions
  - Accumulating Fact Updates

### 4. **SSAS OLAP Cube**
- Built with **Fact_Order** as measure group
- Dimensions: Date, Customer, Product, Seller, Geolocation
- OLAP Operations:
  - Roll-up
  - Drill-down
  - Slice & Dice
  - Pivot

### 5. **Power BI Dashboards**
- **Profit Breakdown** by product and year
- **Cascading Filters** (State → City)
- **Time Drill-down Reports** (Year → Month)
- **Transaction-Level Drill-through Reports**

---

## 🛠 Tools & Technologies

- SQL Server
- SSIS (SQL Server Integration Services)
- SSAS (SQL Server Analysis Services)
- Power BI
- Microsoft Excel






