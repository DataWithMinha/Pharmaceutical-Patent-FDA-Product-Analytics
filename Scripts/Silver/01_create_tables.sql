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
