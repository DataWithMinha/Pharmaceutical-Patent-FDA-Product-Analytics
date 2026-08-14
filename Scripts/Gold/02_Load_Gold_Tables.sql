USE PharmaPatentEDA;
GO

-- ============================================================
-- GOLD LAYER - LOAD TABLES
-- ============================================================
-- Purpose:
-- Load cleaned and standardized Silver-layer data into the
-- business-ready Gold dimensional model.
--
-- Gold tables:
--   1. Dim_Application
--   2. Dim_Company
--   3. Dim_Date
--   4. Dim_Drug
--   5. Dim_MarketingStatus
--   6. Fact_Product
--
-- The majority of data cleaning and standardization was
-- performed in the Silver layer.
-- Gold primarily focuses on:
--   - Selecting required business attributes
--   - Removing duplicate records
--   - Filtering invalid/null key values
--   - Creating the Date dimension
--   - Assigning dimension keys to the Fact table
-- ============================================================


-- ============================================================
-- 1. LOAD Gold.Dim_Application
-- Source: Silver.Application
-- ============================================================

INSERT INTO Gold.Dim_Application
(
    ApplNo,
    ApplType
)
SELECT DISTINCT
    ApplNo,
    ApplType
FROM Silver.Application
WHERE ApplNo IS NOT NULL;
GO


-- ============================================================
-- 2. LOAD Gold.Dim_Company
-- Source: Silver.Application
-- ============================================================
-- DISTINCT removes duplicate sponsor names.
-- NULL and blank sponsor names are excluded.
-- ============================================================

INSERT INTO Gold.Dim_Company
(
    SponsorName
)
SELECT DISTINCT
    SponsorName
FROM Silver.Application
WHERE SponsorName IS NOT NULL
  AND LTRIM(RTRIM(SponsorName)) <> '';
GO


-- ============================================================
-- 3. LOAD Gold.Dim_Date
-- ============================================================
-- Generates a continuous calendar from 2025-07-13
-- through 2045-09-04.
--
-- DateKey is generated in YYYYMMDD format.
-- Additional calendar attributes are derived from the date.
-- ============================================================

DECLARE @StartDate DATE = '2025-07-13';
DECLARE @EndDate DATE = '2045-09-04';

WHILE @StartDate <= @EndDate
BEGIN

    INSERT INTO Gold.Dim_Date
    (
        DateKey,
        Date,
        Year,
        Quarter,
        Month,
        MonthName
    )
    VALUES
    (
        CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
        @StartDate,
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate)
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);

END;
GO


-- ============================================================
-- 4. LOAD Gold.Dim_Drug
-- Source: Silver.Products
-- ============================================================
-- DISTINCT creates unique combinations of:
-- DrugName, ActiveIngredient, Form and Strength.
--
-- Data cleaning and standardization were primarily performed
-- in the Silver layer.
-- ============================================================

INSERT INTO Gold.Dim_Drug
(
    DrugName,
    ActiveIngredient,
    Form,
    Strength
)
SELECT DISTINCT
    DrugName,
    ActiveIngredient,
    Form,
    Strength
FROM Silver.Products;
GO


-- ============================================================
-- 5. LOAD Gold.Dim_MarketingStatus
-- Source: Silver.Marketingstatus
-- ============================================================
-- Only records with a valid MarketingStatusID are loaded.
-- DISTINCT prevents duplicate combinations.
-- ============================================================

INSERT INTO Gold.Dim_MarketingStatus
(
    MarketingStatusID,
    MarketingStatus
)
SELECT DISTINCT
    MarketingStatusID,
    MarketingStatus
FROM Silver.Marketingstatus
WHERE MarketingStatusID IS NOT NULL;
GO

-- 6. LOAD Gold.Fact_Product
-- ============================================================
-- Source:
--     Silver.Products
--
-- Dimension:
--     Gold.Dim_Drug
--
-- Grain:
--     One row per Application Number + Product Number.
--
-- Data-quality issue addressed:
--     Some products matched multiple DrugKeys in Dim_Drug.
--     ROW_NUMBER() was used to retain one DrugKey for each
--     ApplNo + ProductNo combination and prevent duplicate
--     fact records.
-- ============================================================

;WITH ProductDrugMatch AS
(
    SELECT
        p.ApplNo,
        p.ProductNo,
        p.Form,
        p.Strength,
        p.ReferenceDrug,
        p.ReferenceStandard,
        d.DrugKey,

        ROW_NUMBER() OVER
        (
            PARTITION BY
                p.ApplNo,
                p.ProductNo
            ORDER BY
                d.DrugKey
        ) AS rn

    FROM Silver.Products p

    INNER JOIN Gold.Dim_Drug d
        ON LTRIM(RTRIM(p.DrugName))
           = LTRIM(RTRIM(d.DrugName))

       AND
       (
            LTRIM(RTRIM(p.ActiveIngredient))
            = LTRIM(RTRIM(d.ActiveIngredient))

            OR
            (
                p.ActiveIngredient IS NULL
                AND d.ActiveIngredient IS NULL
            )
       )

       AND LTRIM(RTRIM(p.Form))
           = LTRIM(RTRIM(d.Form))
)

INSERT INTO Gold.Fact_Product
(
    DrugKey,
    ApplNo,
    ProductNo,
    Form,
    Strength,
    ReferenceDrug,
    ReferenceStandard
)
SELECT
    DrugKey,
    ApplNo,
    ProductNo,
    Form,
    Strength,
    ReferenceDrug,
    ReferenceStandard
FROM ProductDrugMatch
WHERE rn = 1;
GO

/*
===============================================================================
DML Script: Load Gold Fact Table - Fact_Patent
===============================================================================

Script Purpose:
    Loads Gold.Fact_Patent from the Silver layer.

    The script:
      1. Builds a DrugKey mapping from Silver.Products to Gold.Dim_Drug.
      2. Uses ROW_NUMBER() to select one DrugKey for each
         Application + Product combination.
      3. Matches applications to Gold.Dim_Application.
      4. Removes exact duplicate patent records using DISTINCT.
      5. Inserts the final records into Gold.Fact_Patent.

Expected Result:
    22,131 rows based on the current Silver.Patent data.

===============================================================================
*/

USE PharmaPatentEDA;
GO

-- =============================================================================
-- Load Gold.Fact_Patent
-- =============================================================================

;WITH DrugMapping AS
(
    SELECT
        p.ApplNo,
        p.ProductNo,
        d.DrugKey,

        ROW_NUMBER() OVER
        (
            PARTITION BY
                p.ApplNo,
                p.ProductNo
            ORDER BY
                d.DrugKey
        ) AS rn

    FROM Silver.Products p

    INNER JOIN Gold.Dim_Drug d
        ON LTRIM(RTRIM(p.DrugName)) =
           LTRIM(RTRIM(d.DrugName))

       AND
       (
            LTRIM(RTRIM(p.ActiveIngredient)) =
            LTRIM(RTRIM(d.ActiveIngredient))

            OR
            (
                p.ActiveIngredient IS NULL
                AND d.ActiveIngredient IS NULL
            )
       )

       AND LTRIM(RTRIM(p.Form)) =
           LTRIM(RTRIM(d.Form))

       AND LTRIM(RTRIM(p.Strength)) =
           LTRIM(RTRIM(d.Strength))
)

INSERT INTO Gold.Fact_Patent
(
    ApplicationKey,
    DrugKey,
    ApplNo,
    ProductNo,
    PatentNo,
    PatentExpireDate,
    DrugSubstanceFlag,
    DrugProductFlag,
    PatentUseCode,
    DelistFlag,
    SubmissionDate
)

SELECT DISTINCT
    a.ApplicationKey,
    dm.DrugKey,
    p.Appl_No,
    p.Product_No,
    p.Patent_No,
    p.Patent_Expire_Date,
    p.Drug_Substance_Flag,
    p.Drug_Product_Flag,
    p.Patent_Use_Code,
    p.Delist_Flag,
    p.Submission_Date

FROM Silver.Patent p

-- Match each patent to exactly one DrugKey
INNER JOIN DrugMapping dm
    ON p.Appl_No = dm.ApplNo
   AND p.Product_No = dm.ProductNo
   AND dm.rn = 1

-- Match each patent application to the Application dimension
INNER JOIN Gold.Dim_Application a
    ON LTRIM(RTRIM(p.Appl_No)) =
       LTRIM(RTRIM(a.ApplNo))

WHERE p.Appl_No IS NOT NULL;
GO
