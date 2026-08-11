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
