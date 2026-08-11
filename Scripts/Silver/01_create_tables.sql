USE PharmaPatentEDA;
GO

-- ============================================================
-- SILVER LAYER - PRODUCT
-- Create the Silver.Product table
-- ============================================================

CREATE TABLE Silver.Product
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

    -- Store valid approval dates as DATE
    Approval_Date DATE,

    -- Store FDA explanation when an actual date is unavailable
    Approval_Date_Note NVARCHAR(100),

    RLD NVARCHAR(100),
    RS NVARCHAR(100),
    [Type] NVARCHAR(100),
    Applicant_Full_Name NVARCHAR(500)
);
GO

-- ============================================================
-- SILVER LAYER - PATENT
-- Create Silver.Patent table
-- ============================================================

CREATE TABLE Silver.Patent
(
    Appl_Type NVARCHAR(100),
    Appl_No NVARCHAR(100),
    Product_No NVARCHAR(100),
    Patent_No NVARCHAR(100),
    Patent_Expire_Date DATE,
    Drug_Substance_Flag NVARCHAR(50),
    Drug_Product_Flag NVARCHAR(50),
    Patent_Use_Code NVARCHAR(500),
    Delist_Flag NVARCHAR(50),
    Submission_Date DATE
);
GO

-- ============================================================
-- SILVER LAYER - EXCLUSIVITY
-- Create Silver.Exclusivity table
-- ============================================================

CREATE TABLE Silver.Exclusivity
(
    Appl_Type NVARCHAR(100),
    Appl_No NVARCHAR(100),
    Product_No NVARCHAR(100),
    Exclusivity_Code NVARCHAR(100),
    Exclusivity_Date DATE
);
GO
    
-- ============================================================
-- SILVER LAYER - APPLICATION
-- ============================================================

CREATE TABLE Silver.Application
(
    ApplNo NVARCHAR(50),
    ApplType NVARCHAR(100),
    ApplPublicNotes NVARCHAR(MAX),
    SponsorName NVARCHAR(500)
);
GO
-- ============================================================
-- SILVER LAYER - PRODUCTS
-- ============================================================

CREATE TABLE Silver.Products
(
    ApplNo NVARCHAR(50),
    ProductNo NVARCHAR(50),
    Form NVARCHAR(500),
    Strength NVARCHAR(500),
    ReferenceDrug NVARCHAR(50),
    DrugName NVARCHAR(500),
    ActiveIngredient NVARCHAR(500),
    ReferenceStandard NVARCHAR(50)
);
GO
-- ============================================================
-- SILVER LAYER - MARKETING STATUS
-- ============================================================

CREATE TABLE Silver.Marketingstatus
(
    MarketingStatusID INT,
    ApplNo NVARCHAR(50),
    ProductNo NVARCHAR(50),
    MarketingStatus NVARCHAR(200)
);
GO

-- ============================================================
-- SILVER LAYER - SUBMISSION
-- Create Silver.Submission table
-- ============================================================

CREATE TABLE Silver.Submission
(
    ApplNo NVARCHAR(50),
    SubmissionType NVARCHAR(100),
    SubmissionNo NVARCHAR(50),
    SubmissionStatus NVARCHAR(100),
    SubmissionClassCodeID NVARCHAR(50),
    SubmissionStatusDate DATE
);
GO

