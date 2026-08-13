USE PharmaPatentEDA;
GO

-- ============================================================
-- GOLD LAYER - CREATE TABLES
-- ============================================================
-- Purpose:
-- Create business-ready dimensional and fact tables for
-- reporting and Power BI analysis.
--
-- Gold tables:
--   1. Dim_Application
--   2. Dim_Company
--   3. Dim_Date
--   4. Dim_Drug
--   5. Dim_MarketingStatus
--   6. Fact_Product
-- ============================================================


-- ============================================================
-- 1. CREATE Gold.Dim_Application
-- ============================================================

IF OBJECT_ID('Gold.Dim_Application', 'U') IS NOT NULL
    DROP TABLE Gold.Dim_Application;
GO

CREATE TABLE Gold.Dim_Application
(
    ApplicationKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ApplNo NVARCHAR(50),
    ApplType NVARCHAR(50)
);
GO


-- ============================================================
-- 2. CREATE Gold.Dim_Company
-- ============================================================

IF OBJECT_ID('Gold.Dim_Company', 'U') IS NOT NULL
    DROP TABLE Gold.Dim_Company;
GO

CREATE TABLE Gold.Dim_Company
(
    CompanyKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SponsorName NVARCHAR(255)
);
GO


-- ============================================================
-- 3. CREATE Gold.Dim_Date
-- ============================================================

IF OBJECT_ID('Gold.Dim_Date', 'U') IS NOT NULL
    DROP TABLE Gold.Dim_Date;
GO

CREATE TABLE Gold.Dim_Date
(
    DateKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [Date] DATE,
    [Year] INT,
    [Quarter] INT,
    [Month] INT,
    MonthName NVARCHAR(20)
);
GO


-- ============================================================
-- 4. CREATE Gold.Dim_Drug
-- ============================================================

IF OBJECT_ID('Gold.Dim_Drug', 'U') IS NOT NULL
    DROP TABLE Gold.Dim_Drug;
GO

CREATE TABLE Gold.Dim_Drug
(
    DrugKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DrugName NVARCHAR(255),
    ActiveIngredient NVARCHAR(255),
    Form NVARCHAR(100),
    Strength NVARCHAR(255)
);
GO


-- ============================================================
-- 5. CREATE Gold.Dim_MarketingStatus
-- ============================================================

IF OBJECT_ID('Gold.Dim_MarketingStatus', 'U') IS NOT NULL
    DROP TABLE Gold.Dim_MarketingStatus;
GO

CREATE TABLE Gold.Dim_MarketingStatus
(
    MarketingStatusKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    MarketingStatusID INT,
    MarketingStatus NVARCHAR(255)
);
GO


-- ============================================================
-- 6. CREATE Gold.Fact_Product
-- ============================================================
-- Grain:
-- One row represents one FDA Application + Product combination.
--
-- Natural grain:
--     ApplNo + ProductNo
-- ============================================================

IF OBJECT_ID('Gold.Fact_Product', 'U') IS NOT NULL
    DROP TABLE Gold.Fact_Product;
GO

CREATE TABLE Gold.Fact_Product
(
    ProductKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    DrugKey INT NOT NULL,
    ApplNo NVARCHAR(50),
    ProductNo NVARCHAR(50),
    Form NVARCHAR(500),
    Strength NVARCHAR(500),
    ReferenceDrug NVARCHAR(50),
    ReferenceStandard NVARCHAR(50)
);
GO
