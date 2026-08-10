/*
============================================================
PROJECT: Pharmaceutical Patent & FDA Product Analytics
FILE: 01_create_bronze_tables.sql
LAYER: Bronze

PURPOSE:
This script creates the Bronze layer of the pharmaceutical
data analytics project.

The Bronze layer stores raw data ingested from:

1. FDA Orange Book
2. Drugs@FDA

At this stage:
- Data is kept close to the original source format.
- No business transformations are performed.
- No analytical calculations are performed.
- Most fields are stored as NVARCHAR to preserve the
  original source values.

DATA FLOW:

FDA Orange Book / Drugs@FDA
            ↓
        CSV Files
            ↓
       Bronze Layer
            ↓
      Silver Layer
            ↓
     SQL Analysis / EDA
            ↓
        Power BI

============================================================
*/


/*
============================================================
1. DATABASE SETUP
============================================================
*/
CREATE DATABASE PharmaPatentEDA;
GO
USE PharmaPatentEDA;
GO


/*
============================================================
2. CREATE BRONZE SCHEMA
============================================================

The Bronze schema separates raw source data from future
transformed Silver and analytical Gold datasets.
*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'Bronze'
)
BEGIN
    EXEC('CREATE SCHEMA Bronze');
END;
GO


/*
============================================================
3. FDA ORANGE BOOK - PRODUCT
============================================================

Source:
FDA Orange Book Product Data

Purpose:
Contains drug/product information including ingredient,
trade name, applicant, strength, application number,
product number, TE code and approval information.

Rows loaded during this project:
48,502
*/

IF OBJECT_ID('Bronze.Product', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.Product
    (
        Ingredient NVARCHAR(500),
        [DF;Route] NVARCHAR(500),
        Trade_Name NVARCHAR(500),
        Applicant NVARCHAR(500),
        Strength NVARCHAR(MAX),
        Appl_Type NVARCHAR(100),
        Appl_No NVARCHAR(100),
        Product_No NVARCHAR(100),
        TE_Code NVARCHAR(100),
        Approval_Date NVARCHAR(100),
        RLD NVARCHAR(100),
        RS NVARCHAR(100),
        [Type] NVARCHAR(100),
        Applicant_Full_Name NVARCHAR(500)
    );

END;
GO


/*
============================================================
4. FDA ORANGE BOOK - PATENT
============================================================

Source:
FDA Orange Book Patent Data

Purpose:
Contains patent information associated with FDA-approved
drug products.

Important fields include:
- Application number
- Product number
- Patent number
- Patent expiration information
- Patent use information
- Submission information
*/

IF OBJECT_ID('Bronze.Patent', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.Patent
    (
        Appl_Type NVARCHAR(100),
        Appl_No NVARCHAR(100),
        Product_No NVARCHAR(100),
        Patent_No NVARCHAR(100),
        Patent_Expire_Date_Text NVARCHAR(100),
        Drug_Substance_Flag NVARCHAR(50),
        Drug_Product_Flag NVARCHAR(50),
        Patent_Use_Code NVARCHAR(100),
        Delist_Flag NVARCHAR(50),
        Submission_Date NVARCHAR(100)
    );

END;
GO


/*
============================================================
5. FDA ORANGE BOOK - EXCLUSIVITY
============================================================

Source:
FDA Orange Book Exclusivity Data

Purpose:
Stores regulatory exclusivity information associated with
drug applications and products.

Rows loaded during this project:
2,341
*/

IF OBJECT_ID('Bronze.Exclusivity', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.Exclusivity
    (
        Appl_Type NVARCHAR(100),
        Appl_No NVARCHAR(100),
        Product_No NVARCHAR(100),
        Exclusivity_Code NVARCHAR(100),
        Exclusivity_Date NVARCHAR(100)
    );

END;
GO


/*
============================================================
6. DRUGS@FDA - APPLICATION
============================================================

Source:
Drugs@FDA Application Data

Purpose:
Contains FDA application-level information including:
- Application number
- Application type
- Public notes
- Sponsor name

Rows loaded during this project:
29,261
*/

IF OBJECT_ID('Bronze.Application', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.Application
    (
        ApplNo NVARCHAR(100),
        ApplType NVARCHAR(100),
        ApplPublicNotes NVARCHAR(MAX),
        SponsorName NVARCHAR(500)
    );

END;
GO


/*
============================================================
7. DRUGS@FDA - MARKETING STATUS
============================================================

Source:
Drugs@FDA Marketing Status Data

Purpose:
Links an FDA application/product to its marketing
status.

Rows loaded during this project:
52,232
*/

IF OBJECT_ID('Bronze.MarketingStatus', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.MarketingStatus
    (
        MarketingStatusID NVARCHAR(100),
        ApplNo NVARCHAR(100),
        ProductNo NVARCHAR(100)
    );

END;
GO


/*
============================================================
8. DRUGS@FDA - MARKETING STATUS LOOKUP
============================================================

Purpose:
Reference/lookup table that provides the description
associated with each MarketingStatusID.

Rows loaded during this project:
5
*/

IF OBJECT_ID('Bronze.MarketingStatusLookup', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.MarketingStatusLookup
    (
        MarketingStatusID NVARCHAR(100),
        MarketingStatusDescription NVARCHAR(500)
    );

END;
GO


/*
============================================================
9. DRUGS@FDA - PRODUCTS
============================================================

Source:
Drugs@FDA Products Data

Purpose:
Contains detailed product-level information such as:
- Drug name
- Active ingredient
- Dosage form
- Strength
- Reference drug information

Rows loaded during this project:
51,633
*/

IF OBJECT_ID('Bronze.Products', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.Products
    (
        ApplNo NVARCHAR(100),
        ProductNo NVARCHAR(100),
        Form NVARCHAR(500),
        Strength NVARCHAR(MAX),
        ReferenceDrug NVARCHAR(100),
        DrugName NVARCHAR(500),
        ActiveIngredient NVARCHAR(500),
        ReferenceStandard NVARCHAR(100)
    );

END;
GO


/*
============================================================
10. DRUGS@FDA - SUBMISSION
============================================================

Source:
Drugs@FDA Submission Data

Purpose:
Contains regulatory submission-level information.

Source columns:
- ApplNo
- SubmissionClassCodeID
- SubmissionType
- SubmissionNo
- SubmissionStatus
- SubmissionStatusDate
- SubmissionsPublicNotes
- ReviewPriority
*/

IF OBJECT_ID('Bronze.Submission', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.Submission
    (
        ApplNo NVARCHAR(100),
        SubmissionClassCodeID NVARCHAR(100),
        SubmissionType NVARCHAR(200),
        SubmissionNo NVARCHAR(100),
        SubmissionStatus NVARCHAR(200),
        SubmissionStatusDate NVARCHAR(100),
        SubmissionsPublicNotes NVARCHAR(MAX),
        ReviewPriority NVARCHAR(200)
    );

END;
GO


/*
============================================================
11. DRUGS@FDA - TE DATA
============================================================

Source:
Drugs@FDA TE Data

Purpose:
Links an application/product with marketing status and
therapeutic equivalence information.

Source columns:
- ApplNo
- ProductNo
- MarketingStatusID
- TECode
*/

IF OBJECT_ID('Bronze.TE', 'U') IS NULL
BEGIN

    CREATE TABLE Bronze.TE
    (
        ApplNo NVARCHAR(100),
        ProductNo NVARCHAR(100),
        MarketingStatusID NVARCHAR(100),
        TECode NVARCHAR(100)
    );

END;
GO


/*
============================================================
BRONZE TABLE CREATION COMPLETE
============================================================

Tables created:

FDA ORANGE BOOK
----------------
Bronze.Product
Bronze.Patent
Bronze.Exclusivity

DRUGS@FDA
----------------
Bronze.Application
Bronze.MarketingStatus
Bronze.MarketingStatusLookup
Bronze.Products
Bronze.Submission
Bronze.TE

NEXT STEP:
Load the raw CSV files into these Bronze tables.

============================================================
*/
