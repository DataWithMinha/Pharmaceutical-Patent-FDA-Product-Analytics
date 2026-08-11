USE PharmaPatentEDA;
GO

-- ============================================================
-- SILVER LAYER - PRODUCT
-- Load and transform data from Bronze.Product
-- ============================================================

INSERT INTO Silver.Product
(
    Ingredient,
    [DF;Route],
    Trade_Name,
    Applicant,
    Strength,
    Appl_Type,
    Appl_No,
    Product_No,
    TE_Code,
    Approval_Date,
    Approval_Date_Note,
    RLD,
    RS,
    [Type],
    Applicant_Full_Name
)

SELECT
    Ingredient,
    [DF;Route],
    Trade_Name,
    Applicant,
    Strength,

    -- Convert application type codes
    -- into meaningful descriptions
    CASE
        WHEN Appl_Type = 'ANDA'
            THEN 'Abbreviated New Drug Application'

        WHEN Appl_Type = 'NDA'
            THEN 'New Drug Application'

        ELSE Appl_Type
    END AS Appl_Type,

    Appl_No,
    Product_No,
    TE_Code,

    -- Convert valid approval dates into DATE
    -- Special FDA text is converted to NULL
    CASE
        WHEN Approval_Date = 'Approved Prior to Jan 1, 1982'
            THEN NULL

        ELSE TRY_CONVERT(DATE, Approval_Date)
    END AS Approval_Date,

    -- Preserve the reason why Approval_Date is NULL
    CASE
        WHEN Approval_Date = 'Approved Prior to Jan 1, 1982'
            THEN 'Approved Prior to Jan 1, 1982'

        ELSE NULL
    END AS Approval_Date_Note,

    -- No transformation required
    RLD,
    RS,
    [Type],
    Applicant_Full_Name

FROM Bronze.Product;
GO

-- ============================================================
-- SILVER LAYER - PATENT
-- Load and transform data from Bronze.Patent
-- ============================================================

-- Remove previously loaded data before reloading
-- with the updated transformations.
TRUNCATE TABLE Silver.Patent;
GO

INSERT INTO Silver.Patent
(
    Appl_Type,
    Appl_No,
    Product_No,
    Patent_No,
    Patent_Expire_Date,
    Drug_Substance_Flag,
    Drug_Product_Flag,
    Patent_Use_Code,
    Delist_Flag,
    Submission_Date
)
SELECT

    -- Convert application type code
    -- N = New Drug Application
    CASE
        WHEN Appl_Type = 'N'
            THEN 'New Drug Application'
        ELSE Appl_Type
    END AS Appl_Type,

    Appl_No,
    Product_No,
    Patent_No,

    -- Convert patent expiry date from NVARCHAR to DATE
    TRY_CONVERT(DATE, Patent_Expire_Date_Text)
        AS Patent_Expire_Date,

    -- Y = DS
    -- NULL remains NULL
    CASE
        WHEN Drug_Substance_Flag = 'Y'
            THEN 'DS'
        ELSE NULL
    END AS Drug_Substance_Flag,

    -- Y = DP
    -- NULL remains NULL
    CASE
        WHEN Drug_Product_Flag = 'Y'
            THEN 'DP'
        ELSE NULL
    END AS Drug_Product_Flag,

    Patent_Use_Code,
    Delist_Flag,

    -- Convert submission date from NVARCHAR to DATE
    TRY_CONVERT(DATE, Submission_Date)
        AS Submission_Date

FROM Bronze.Patent;
GO

-- ============================================================
-- SILVER LAYER - EXCLUSIVITY
-- Load and transform data from Bronze.Exclusivity
-- ============================================================

-- Remove previously loaded data before reloading
-- with the updated transformations.
TRUNCATE TABLE Silver.Exclusivity;
GO

INSERT INTO Silver.Exclusivity
(
    Appl_Type,
    Appl_No,
    Product_No,
    Exclusivity_Code,
    Exclusivity_Date
)
SELECT

    -- Convert application type codes into full descriptions
    CASE
        WHEN Appl_Type = 'N'
            THEN 'New Drug Application'

        WHEN Appl_Type = 'A'
            THEN 'Abbreviated New Drug Application'

        ELSE Appl_Type
    END AS Appl_Type,

    Appl_No,
    Product_No,

    -- Keep FDA exclusivity codes as provided
    Exclusivity_Code,

    -- Convert exclusivity expiration date from NVARCHAR to DATE
    TRY_CONVERT(DATE, Exclusivity_Date)
        AS Exclusivity_Date

FROM Bronze.Exclusivity;
GO
-- ============================================================
-- SILVER LAYER - APPLICATION
-- ============================================================

TRUNCATE TABLE Silver.Application;
GO

INSERT INTO Silver.Application
(
    ApplNo,
    ApplType,
    ApplPublicNotes,
    SponsorName
)
SELECT
    ApplNo,

    CASE
        WHEN ApplType = 'ANDA'
            THEN 'Abbreviated New Drug Application'
        WHEN ApplType = 'NDA'
            THEN 'New Drug Application'
        WHEN ApplType = 'BLA'
            THEN 'Biologics License Application'
        ELSE ApplType
    END AS ApplType,

    ApplPublicNotes,
    SponsorName

FROM Bronze.Application;
GO
-- ============================================================
-- SILVER LAYER - PRODUCTS
-- ============================================================

TRUNCATE TABLE Silver.Products;
GO

INSERT INTO Silver.Products
(
    ApplNo,
    ProductNo,
    Form,
    Strength,
    ReferenceDrug,
    DrugName,
    ActiveIngredient,
    ReferenceStandard
)
SELECT
    ApplNo,
    ProductNo,
    Form,
    Strength,
    ReferenceDrug,
    DrugName,
    ActiveIngredient,
    ReferenceStandard

FROM Bronze.Products;
GO
-- ============================================================
-- SILVER LAYER - MARKETING STATUS
-- ============================================================

TRUNCATE TABLE Silver.Marketingstatus;
GO

INSERT INTO Silver.Marketingstatus
(
    MarketingStatusID,
    ApplNo,
    ProductNo,
    MarketingStatus
)
SELECT
    MarketingStatusID,
    ApplNo,
    ProductNo,

    CASE
        WHEN MarketingStatusID = 1
            THEN 'Prescription'
        WHEN MarketingStatusID = 2
            THEN 'Over-the-counter'
        WHEN MarketingStatusID = 3
            THEN 'Discontinued'
        WHEN MarketingStatusID = 4
            THEN 'None (Tentative Approval)'
        WHEN MarketingStatusID = 5
            THEN 'For Further Manufacturing Use'
        ELSE NULL
    END AS MarketingStatus

FROM Bronze.Marketingstatus;
GO

-- ============================================================
-- SILVER LAYER - SUBMISSION
-- Load and transform data from Bronze.Submission
-- ============================================================

-- Remove previously loaded data before reloading
TRUNCATE TABLE Silver.Submission;
GO

INSERT INTO Silver.Submission
(
    ApplNo,
    SubmissionType,
    SubmissionNo,
    SubmissionStatus,
    SubmissionClassCodeID,
    SubmissionStatusDate
)
SELECT
    ApplNo,

    -- Convert submission type codes into descriptions
    CASE
        WHEN TRIM(SubmissionType) = 'ORIG'
            THEN 'Original Submission'

        WHEN TRIM(SubmissionType) = 'SUPPL'
            THEN 'Supplement'

        ELSE NULL
    END AS SubmissionType,

    SubmissionNo,

    -- Convert submission status codes into descriptions
    CASE
        WHEN TRIM(SubmissionStatus) = 'AP'
            THEN 'Approval'

        WHEN TRIM(SubmissionStatus) = 'TA'
            THEN 'Tentative Approval'

        ELSE NULL
    END AS SubmissionStatus,

    -- Remove leading/trailing spaces from the class code
    TRIM(SubmissionClassCodeID)
        AS SubmissionClassCodeID,

    -- Remove time and keep only the date
    TRY_CONVERT(DATE, SubmissionStatusDate)
        AS SubmissionStatusDate

FROM Bronze.Submission;
GO
-- ============================================================
-- SILVER LAYER - TE
-- Load and clean data from Bronze.TE
-- ============================================================

-- Remove previously loaded data before reloading
TRUNCATE TABLE Silver.TE;
GO

INSERT INTO Silver.TE
(
    ApplNo,
    ProductNo,
    MarketingStatusID,
    TECode
)
SELECT
    ApplNo,
    ProductNo,
    MarketingStatusID,

    -- Remove leading and trailing spaces
    TRIM(TECode) AS TECode

FROM Bronze.TE;
GO
