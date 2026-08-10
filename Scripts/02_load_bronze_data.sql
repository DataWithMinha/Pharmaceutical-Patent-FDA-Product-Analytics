/*
============================================================
PROJECT: Pharmaceutical Patent & FDA Product Analytics
FILE: 02_load_bronze_data.sql
LAYER: Bronze

PURPOSE:
Load raw FDA Orange Book and Drugs@FDA CSV files into
the Bronze tables created in:

01_create_bronze_tables.sql

The Bronze layer is intended to preserve the source data
with minimal transformation.

NOTE:
The CSV files were sometimes re-saved in a consistent
CSV/UTF-8 format when SQL Server's BULK INSERT encountered
CSV parsing or formatting errors.

This was done for file compatibility only and does not
represent business-level data transformation.

============================================================
*/


USE PharmaPatentEDA;
GO


/*
============================================================
1. FDA ORANGE BOOK - PRODUCT
============================================================

Source file:
ProductOB_data_clean.csv

Target table:
Bronze.Product

Rows loaded:
48,502
*/

BULK INSERT Bronze.Product
FROM 'C:\Users\minha\Patent_data\ProductOB_data_clean.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
2. FDA ORANGE BOOK - PATENT
============================================================

Source file:
Patent_data_clean.csv

Target table:
Bronze.Patent
*/

BULK INSERT Bronze.Patent
FROM 'C:\Users\minha\Patent_data\Patent_data_clean.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
3. FDA ORANGE BOOK - EXCLUSIVITY
============================================================

Source file:
Exclusivity_data_clean.csv

Target table:
Bronze.Exclusivity

Rows loaded:
2,341
*/

BULK INSERT Bronze.Exclusivity
FROM 'C:\Users\minha\Patent_data\Exclusivity_data_clean.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
4. DRUGS@FDA - APPLICATION
============================================================

Source file:
Application_data_clean.csv

Target table:
Bronze.Application

Rows loaded:
29,261
*/

BULK INSERT Bronze.Application
FROM 'C:\Users\minha\Patent_data\Application_data_clean.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
5. DRUGS@FDA - MARKETING STATUS
============================================================

Source file:
Marketingstatus_data.csv

Target table:
Bronze.MarketingStatus

Rows loaded:
52,232
*/

BULK INSERT Bronze.MarketingStatus
FROM 'C:\Users\minha\Patent_data\Marketingstatus_data.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
6. DRUGS@FDA - MARKETING STATUS LOOKUP
============================================================

Source file:
MarketingstatusLookup_data.csv

Target table:
Bronze.MarketingStatusLookup

Rows loaded:
5
*/

BULK INSERT Bronze.MarketingStatusLookup
FROM 'C:\Users\minha\Patent_data\MarketingstatusLookup_data.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
7. DRUGS@FDA - PRODUCTS
============================================================

Source file:
Products_data.csv

Target table:
Bronze.Products

Rows loaded:
51,633
*/

BULK INSERT Bronze.Products
FROM 'C:\Users\minha\Patent_data\Products_data.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
8. DRUGS@FDA - SUBMISSION
============================================================

Source file:
Submission_data.csv

Target table:
Bronze.Submission

The source contains 8 columns:
- ApplNo
- SubmissionClassCodeID
- SubmissionType
- SubmissionNo
- SubmissionStatus
- SubmissionStatusDate
- SubmissionsPublicNotes
- ReviewPriority
*/

BULK INSERT Bronze.Submission
FROM 'C:\Users\minha\Patent_data\Submission_data.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
9. DRUGS@FDA - TE DATA
============================================================

Source file:
TE_data.csv

Target table:
Bronze.TE
*/

BULK INSERT Bronze.TE
FROM 'C:\Users\minha\Patent_data\TE_data.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDQUOTE = '"',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO


/*
============================================================
10. BASIC VALIDATION
============================================================

Check that data has been loaded into the Bronze tables.

These queries do not transform the data. They simply
validate the ingestion process.
*/

SELECT 'Product' AS Table_Name, COUNT(*) AS Total_Rows
FROM Bronze.Product

UNION ALL

SELECT 'Patent', COUNT(*)
FROM Bronze.Patent

UNION ALL

SELECT 'Exclusivity', COUNT(*)
FROM Bronze.Exclusivity

UNION ALL

SELECT 'Application', COUNT(*)
FROM Bronze.Application

UNION ALL

SELECT 'MarketingStatus', COUNT(*)
FROM Bronze.MarketingStatus

UNION ALL

SELECT 'MarketingStatusLookup', COUNT(*)
FROM Bronze.MarketingStatusLookup

UNION ALL

SELECT 'Products', COUNT(*)
FROM Bronze.Products

UNION ALL

SELECT 'Submission', COUNT(*)
FROM Bronze.Submission

UNION ALL

SELECT 'TE', COUNT(*)
FROM Bronze.TE;
GO


/*
============================================================
BRONZE DATA INGESTION COMPLETE
============================================================

The source datasets have been loaded into SQL Server's
Bronze schema.

NEXT STAGE:
SILVER LAYER

In the Silver layer we will:
- Standardize data types
- Clean text fields
- Handle NULL values
- Check for duplicates
- Standardize dates
- Validate relationships between tables
- Prepare analysis-ready datasets

============================================================
*/
