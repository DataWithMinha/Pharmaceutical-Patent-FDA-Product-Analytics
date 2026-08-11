USE PharmaPatentEDA;
GO

-- ============================================================
-- SILVER LAYER - PRODUCT
-- DATA QUALITY CHECKS
-- ============================================================

-- 1. Check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM Silver.Product;


-- 2. Check for NULL values in important columns
SELECT
    COUNT(*) - COUNT(Ingredient) AS Missing_Ingredient,
    COUNT(*) - COUNT(Appl_No) AS Missing_Appl_No,
    COUNT(*) - COUNT(Product_No) AS Missing_Product_No,
    COUNT(*) - COUNT(Approval_Date) AS Missing_Approval_Date
FROM Silver.Product;


-- 3. Check Application Type transformation
SELECT DISTINCT Appl_Type
FROM Silver.Product;


-- 4. Check Approval Date
-- Confirm that the column contains DATE values
SELECT TOP 20
    Approval_Date
FROM Silver.Product;


-- 5. Check for duplicate Application + Product combinations
SELECT
    Appl_No,
    Product_No,
    COUNT(*) AS Duplicate_Count
FROM Silver.Product
GROUP BY
    Appl_No,
    Product_No
HAVING COUNT(*) > 1;


-- 6. Check TE Codes
SELECT DISTINCT TE_Code
FROM Silver.Product;
GO
-- ============================================================
-- SILVER LAYER - PATENT
-- DATA QUALITY CHECKS
-- ============================================================

-- 1. Check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM Silver.Patent;


-- 2. Check for NULL values in important columns
SELECT
    COUNT(*) - COUNT(Appl_No) AS Missing_Appl_No,
    COUNT(*) - COUNT(Product_No) AS Missing_Product_No,
    COUNT(*) - COUNT(Patent_No) AS Missing_Patent_No,
    COUNT(*) - COUNT(Patent_Expire_Date) AS Missing_Patent_Expire_Date,
    COUNT(*) - COUNT(Submission_Date) AS Missing_Submission_Date
FROM Silver.Patent;


-- 3. Check Application Type transformation
SELECT DISTINCT Appl_Type
FROM Silver.Patent;


-- 4. Check Drug Substance Flag transformation
SELECT DISTINCT Drug_Substance_Flag
FROM Silver.Patent;


-- 5. Check Drug Product Flag transformation
SELECT DISTINCT Drug_Product_Flag
FROM Silver.Patent;


-- 6. Check Patent Expiry Dates
SELECT TOP 20
    Patent_Expire_Date
FROM Silver.Patent;


-- 7. Check Submission Dates
SELECT TOP 20
    Submission_Date
FROM Silver.Patent;


-- 8. Check for duplicate Application + Product + Patent combinations
SELECT
    Appl_No,
    Product_No,
    Patent_No,
    COUNT(*) AS Duplicate_Count
FROM Silver.Patent
GROUP BY
    Appl_No,
    Product_No,
    Patent_No
HAVING COUNT(*) > 1;
GO
-- ============================================================
-- SILVER LAYER - EXCLUSIVITY
-- DATA QUALITY CHECKS
-- ============================================================

-- 1. Check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM Silver.Exclusivity;


-- 2. Check for NULL values
SELECT
    COUNT(*) - COUNT(Appl_No) AS Missing_Appl_No,
    COUNT(*) - COUNT(Product_No) AS Missing_Product_No,
    COUNT(*) - COUNT(Exclusivity_Code) AS Missing_Exclusivity_Code,
    COUNT(*) - COUNT(Exclusivity_Date) AS Missing_Exclusivity_Date
FROM Silver.Exclusivity;


-- 3. Check Application Type transformation
SELECT DISTINCT Appl_Type
FROM Silver.Exclusivity;


-- 4. Check Exclusivity Codes
SELECT DISTINCT Exclusivity_Code
FROM Silver.Exclusivity;


-- 5. Check Exclusivity Dates
SELECT TOP 20
    Exclusivity_Date
FROM Silver.Exclusivity;


-- 6. Check for duplicate Application + Product + Exclusivity combinations
SELECT
    Appl_No,
    Product_No,
    Exclusivity_Code,
    COUNT(*) AS Duplicate_Count
FROM Silver.Exclusivity
GROUP BY
    Appl_No,
    Product_No,
    Exclusivity_Code
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;
GO
-- ============================================================
-- SILVER LAYER - APPLICATION
-- DATA QUALITY CHECKS
-- ============================================================

-- 1. Check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM Silver.Application;


-- 2. Check for NULL values
SELECT
    COUNT(*) - COUNT(ApplNo) AS Missing_ApplNo,
    COUNT(*) - COUNT(ApplType) AS Missing_ApplType,
    COUNT(*) - COUNT(SponsorName) AS Missing_SponsorName
FROM Silver.Application;


-- 3. Check Application Type transformation
SELECT DISTINCT ApplType
FROM Silver.Application;


-- 4. Check for duplicate Application Numbers
SELECT
    ApplNo,
    COUNT(*) AS Duplicate_Count
FROM Silver.Application
GROUP BY ApplNo
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;


-- 5. Check Sponsor Names
SELECT TOP 20
    SponsorName
FROM Silver.Application;


-- 6. Check Public Notes
SELECT TOP 20
    ApplPublicNotes
FROM Silver.Application;
GO

-- ============================================================
-- SILVER LAYER - PRODUCTS
-- DATA QUALITY CHECKS
-- ============================================================

-- 1. Check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM Silver.Products;


-- 2. Check for NULL values
SELECT
    COUNT(*) - COUNT(ApplNo) AS Missing_ApplNo,
    COUNT(*) - COUNT(ProductNo) AS Missing_ProductNo,
    COUNT(*) - COUNT(Form) AS Missing_Form,
    COUNT(*) - COUNT(Strength) AS Missing_Strength,
    COUNT(*) - COUNT(DrugName) AS Missing_DrugName,
    COUNT(*) - COUNT(ActiveIngredient) AS Missing_ActiveIngredient
FROM Silver.Products;


-- 3. Check Reference Drug values
SELECT DISTINCT ReferenceDrug
FROM Silver.Products;


-- 4. Check Reference Standard values
SELECT DISTINCT ReferenceStandard
FROM Silver.Products;


-- 5. Check for duplicate Application + Product combinations
SELECT
    ApplNo,
    ProductNo,
    COUNT(*) AS Duplicate_Count
FROM Silver.Products
GROUP BY
    ApplNo,
    ProductNo
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;


-- 6. Investigate missing Strength values
SELECT *
FROM Silver.Products
WHERE Strength IS NULL;


-- 7. Investigate missing ActiveIngredient values
SELECT *
FROM Silver.Products
WHERE ActiveIngredient IS NULL;


-- ============================================================
-- NOTES
-- ============================================================

-- Missing Strength values are present in the FDA source data
-- for certain products and are therefore retained as NULL.
-- No values were invented during the Silver transformation.
--
-- One ActiveIngredient value is NULL for Medical Air, USP.
-- This value is retained as NULL because the FDA source does not
-- provide an ActiveIngredient for this product.
GO
-- ============================================================
-- SILVER LAYER - MARKETING STATUS
-- DATA QUALITY CHECKS
-- ============================================================

-- 1. Check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM Silver.Marketingstatus;


-- 2. Check for NULL values
SELECT
    COUNT(*) - COUNT(MarketingStatusID) AS Missing_MarketingStatusID,
    COUNT(*) - COUNT(ApplNo) AS Missing_ApplNo,
    COUNT(*) - COUNT(ProductNo) AS Missing_ProductNo,
    COUNT(*) - COUNT(MarketingStatus) AS Missing_MarketingStatus
FROM Silver.Marketingstatus;


-- 3. Check Marketing Status mapping
SELECT DISTINCT
    MarketingStatusID,
    MarketingStatus
FROM Silver.Marketingstatus
ORDER BY MarketingStatusID;


-- 4. Check for invalid Marketing Status IDs
SELECT DISTINCT MarketingStatusID
FROM Silver.Marketingstatus
WHERE MarketingStatusID NOT IN (1, 2, 3, 4, 5)
   OR MarketingStatusID IS NULL;


-- 5. Check for duplicate Application + Product + Status combinations
SELECT
    ApplNo,
    ProductNo,
    MarketingStatusID,
    COUNT(*) AS Duplicate_Count
FROM Silver.Marketingstatus
GROUP BY
    ApplNo,
    ProductNo,
    MarketingStatusID
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;
GO

-- ============================================================
-- SILVER LAYER - SUBMISSION
-- FINAL DATA QUALITY CHECKS
-- ============================================================

-- 1. Check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM Silver.Submission;


-- 2. Check for NULL values
SELECT
    COUNT(*) - COUNT(ApplNo) AS Missing_ApplNo,
    COUNT(*) - COUNT(SubmissionType) AS Missing_SubmissionType,
    COUNT(*) - COUNT(SubmissionNo) AS Missing_SubmissionNo,
    COUNT(*) - COUNT(SubmissionStatus) AS Missing_SubmissionStatus,
    COUNT(*) - COUNT(SubmissionClassCodeID) AS Missing_SubmissionClassCodeID,
    COUNT(*) - COUNT(SubmissionStatusDate) AS Missing_SubmissionStatusDate
FROM Silver.Submission;


-- 3. Check Submission Type values
SELECT DISTINCT
    SubmissionType
FROM Silver.Submission;


-- 4. Check Submission Status values
SELECT DISTINCT
    SubmissionStatus
FROM Silver.Submission;


-- 5. Check Submission Class Codes
SELECT DISTINCT
    SubmissionClassCodeID
FROM Silver.Submission
ORDER BY SubmissionClassCodeID;


-- 6. Check Submission Status Date
SELECT TOP 20
    SubmissionStatusDate
FROM Silver.Submission;


-- 7. Check for duplicate Application + Submission combinations
SELECT
    ApplNo,
    SubmissionNo,
    COUNT(*) AS Duplicate_Count
FROM Silver.Submission
GROUP BY
    ApplNo,
    SubmissionNo
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;


-- ============================================================
-- VALIDATION NOTES
-- ============================================================

-- SubmissionStatus contains 1 source-data NULL.
--
-- SubmissionClassCodeID contains 11,887 source-data NULLs.
--
-- SubmissionStatusDate contains 4 source-data NULLs.
--
-- Bronze SubmissionStatusDate is stored in DD-MM-YYYY HH:MM
-- format. Style 105 was used during the Silver transformation
-- to correctly convert the value to DATE.
--
-- Duplicate ApplNo + SubmissionNo combinations should be
-- investigated before being considered actual duplicates.
GO
-- ============================================================
-- SILVER LAYER - TE
-- DATA QUALITY CHECKS
-- ============================================================

-- 1. Check total number of rows
SELECT COUNT(*) AS Total_Rows
FROM Silver.TE;


-- 2. Check for NULL values
SELECT
    COUNT(*) - COUNT(ApplNo) AS Missing_ApplNo,
    COUNT(*) - COUNT(ProductNo) AS Missing_ProductNo,
    COUNT(*) - COUNT(MarketingStatusID) AS Missing_MarketingStatusID,
    COUNT(*) - COUNT(TECode) AS Missing_TECode
FROM Silver.TE;


-- 3. Check TE Codes
SELECT DISTINCT
    TECode
FROM Silver.TE
ORDER BY TECode;


-- 4. Check Marketing Status IDs
SELECT DISTINCT
    MarketingStatusID
FROM Silver.TE
ORDER BY MarketingStatusID;


-- 5. Check for invalid Marketing Status IDs
SELECT DISTINCT
    MarketingStatusID
FROM Silver.TE
WHERE MarketingStatusID NOT IN (1, 2, 3, 4, 5)
   OR MarketingStatusID IS NULL;


-- 6. Check for duplicate Application + Product + TE Code
SELECT
    ApplNo,
    ProductNo,
    TECode,
    COUNT(*) AS Duplicate_Count
FROM Silver.TE
GROUP BY
    ApplNo,
    ProductNo,
    TECode
HAVING COUNT(*) > 1
ORDER BY Duplicate_Count DESC;
GO
