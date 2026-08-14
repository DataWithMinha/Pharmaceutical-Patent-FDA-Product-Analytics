
# PharmaPatentEDA — Pharmaceutical Patent & Product Analytics

## 📌 Project Overview

**PharmaPatentEDA** is an end-to-end pharmaceutical data analytics and data warehousing project built using **SQL Server, SSMS, SQL, and Power BI**.

The project transforms raw pharmaceutical regulatory data into a structured **Bronze–Silver–Gold data warehouse architecture**. The Gold layer follows a **star-schema design** with dimension and fact tables, making the data suitable for analytical reporting and business intelligence.

The project focuses on pharmaceutical **applications, products, drugs, companies, marketing status, and patent information**, with particular emphasis on patent-related analysis such as patent expiry and drug-product relationships.

---

## 🎯 Business Objective

The main objective is to transform raw pharmaceutical data into a clean, reliable, and business-ready analytical dataset that can be used to answer questions such as:

- How many pharmaceutical applications and products are present?
- Which companies sponsor the most applications?
- How are pharmaceutical products distributed across applications?
- What are the different marketing statuses?
- Which drugs are associated with pharmaceutical products?
- Which products and applications have associated patents?
- When are patents scheduled to expire?
- Which drugs have patents approaching expiry?
- How are patents classified between drug substance and drug product?
- Which patent use codes are associated with products?

---

## 🏗️ Data Warehouse Architecture

The project follows a **Medallion Architecture**:


                    Raw Pharmaceutical Data
                             │
                             ▼
                     ┌──────────────┐
                     │    BRONZE    │
                     │  Raw Layer   │
                     └──────────────┘
                             │
                    Cleaning & Standardization
                             │
                             ▼
                     ┌──────────────┐
                     │    SILVER    │
                     │ Cleaned Data │
                     └──────────────┘
                             │
                  Business Modeling & Transformation
                             │
                             ▼
                     ┌──────────────┐
                     │     GOLD     │
                     │ Star Schema  │
                     └──────────────┘
                             │
                             ▼
                         Power BI
                             │
                             ▼
                    Business Analytics
```

### Bronze Layer

The Bronze layer stores the raw pharmaceutical source data with minimal transformation.

### Silver Layer

The Silver layer contains cleaned, standardized, and prepared datasets used for analytical modeling.

### Gold Layer

The Gold layer contains business-ready **dimension and fact tables** organized into a star schema for reporting and analytics.

---

## ⭐ Gold Layer — Star Schema

### Dimension Tables

| Dimension | Description |
|---|---|
| `Dim_Application` | Pharmaceutical application information |
| `Dim_Company` | Application sponsor/company information |
| `Dim_Date` | Calendar and date attributes |
| `Dim_Drug` | Drug name, active ingredient, form, and strength |
| `Dim_MarketingStatus` | Product marketing status information |

### Fact Tables

| Fact | Description |
|---|---|
| `Fact_Product` | Product-level pharmaceutical records |
| `Fact_Patent` | Patent records associated with applications and products |

### Current Gold Layer Record Counts

| Table | Records |
|---|---:|
| `Dim_Application` | 29,262 |
| `Dim_Company` | 2,275 |
| `Dim_Date` | 7,359 |
| `Dim_Drug` | 19,464 |
| `Dim_MarketingStatus` | 5 |
| `Fact_Product` | 51,633 |
| `Fact_Patent` | 22,131 |

---

## 🔧 Data Quality Challenges & Solutions

A major part of the project involved identifying and resolving data-quality and relationship issues rather than simply loading the source data.

### 1. Duplicate Patent Records

The Silver patent dataset contained **44,262 records**, while the final distinct patent records loaded into `Fact_Patent` totaled **22,131**.

Exact duplicate records were identified and removed during the Gold loading process using `DISTINCT`.

Legitimate patent relationships involving different products were retained.

### 2. Multiple DrugKeys for the Same Product

A direct join between pharmaceutical product records and `Dim_Drug` produced multiple `DrugKey` matches for the same product.

For example, the same combination of drug name, active ingredient, form, and strength could correspond to more than one `DrugKey` in the dimension.

To resolve this, `ROW_NUMBER()` was used:

```sql
ROW_NUMBER() OVER
(
    PARTITION BY ApplNo, ProductNo
    ORDER BY DrugKey
)
```

This created a deterministic mapping and selected **one DrugKey per Application + Product combination**.

The same mapping logic was reused across the fact tables to maintain consistency.

### 3. Patent-to-Drug Matching

Patent records were not directly matched to `Dim_Drug`.

Instead, the relationship was established through the product data:

```text
Silver.Patent
      │
      │ Application + Product
      ▼
Silver.Products
      │
      │ Drug Attributes
      ▼
Gold.Dim_Drug
      │
      ▼
DrugKey
```

This prevented incorrect many-to-many matching and ensured that patent records were associated with the appropriate drug dimension key.

### 4. Data Validation

The Gold layer was validated using:

- Row-count validation
- Duplicate checks
- NULL-key checks
- Foreign-key/orphan checks
- Application-to-product validation
- Product-to-drug validation
- Patent-to-product validation
- Patent-to-drug validation

The final Gold layer passed the key validation checks.

---

## 🛠️ Technologies Used

- **SQL Server**
- **SQL / T-SQL**
- **SQL Server Management Studio (SSMS)**
- **Power BI**
- **DAX**
- **GitHub**

---

## 🔄 Project Workflow

1. Collect pharmaceutical regulatory datasets
2. Load raw data into the Bronze layer
3. Clean and standardize data in the Silver layer
4. Identify and resolve data-quality issues
5. Design the Gold-layer star schema
6. Create dimension and fact tables
7. Load business-ready data into Gold
8. Validate row counts, keys, duplicates, and relationships
9. Build the Power BI data model
10. Develop DAX measures
11. Create analytical dashboards
12. Generate pharmaceutical and patent-related business insights

---

## 📂 Repository Structure

```text
PharmaPatentEDA/
│
├── README.md
│
├── Bronze/
│   ├── create_tables/
│   ├── load_data/
│   └── checks/
│
├── Silver/
│   ├── create_tables/
│   ├── transformations/
│   ├── load_data/
│   └── checks/
│
├── Gold/
│   ├── create_tables/
│   ├── load_data/
│   └── checks/
│
├── PowerBI/
│   ├── PharmaPatentEDA.pbix
│   ├── screenshots/
│   └── measures/
│
└── Documentation/
    ├── data_dictionary/
    └── data_model/
```

---

## 📊 Power BI

The Gold layer will serve as the analytical source for the Power BI model.

Planned analysis includes:

### Executive Overview
- Total applications
- Total products
- Total drugs
- Total patents
- Company/application overview
- Marketing status distribution

### Patent Intelligence
- Patent expiry by year
- Patents by drug
- Patents by company
- Drug substance vs. drug product patents
- Patent use-code analysis
- Products with upcoming patent expiries

### Product & Application Analysis
- Products by application type
- Products by drug and active ingredient
- Marketing status analysis
- Reference drug analysis
- Application trends

---

## 📈 Key Learning Outcomes

Through this project, I worked with:

- ETL and data warehousing concepts
- Bronze–Silver–Gold architecture
- SQL data cleaning and transformation
- CTEs and window functions
- `ROW_NUMBER()` for deterministic record mapping
- Duplicate identification and resolution
- Data validation and quality checks
- Dimension and fact table design
- Star-schema modeling
- Pharmaceutical regulatory datasets
- Patent and product relationship analysis
- Power BI data modeling and analytics

---

## 🚧 Project Status

**Current Status:** Bronze, Silver, and Gold data warehouse layers have been created and validated.

**Next Phase:** Power BI data modeling, DAX measures, dashboard development, and business insights.

---

## 👤 Author

**Minha Khan**

MSc Biotechnology | Data Analytics | Pharmaceutical & Patent Intelligence
