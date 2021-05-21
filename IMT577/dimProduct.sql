-- ====================================
-- Delete dimProduct table
-- ====================================
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	DELETE FROM dbo.dimProduct;
END
GO

-- ====================================
-- Create dimProduct table
-- ====================================

IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	CREATE TABLE dbo.dimProduct
	(

	dimProductKey [INT] IDENTITY(1,1) NOT NULL CONSTRAINT PK_dimProduct PRIMARY KEY, -- PK
	ProductID [INT] NOT NULL, -- Surrogate Key
	ProductTypeID [INT] NOT NULL, -- Surrogate Key
	ProductCategoryID [INT] NOT NULL, -- Surrogate Key
	ProductName [NVARCHAR] (50) NOT NULL,
	ProductType [NVARCHAR] (50) NOT NULL,
	ProductCategory [NVARCHAR] (50) NOT NULL,
	ProductRetailPrice [NUMERIC] (18,2) NOT NULL,
	ProductWholesalePrice [NUMERIC] (18,2) NOT NULL,
	ProductCost [NUMERIC] (18,2) NOT NULL,
	ProductRetailProfit [NUMERIC] (18,2) NOT NULL,
	ProductWholesaleUnitProfit [NUMERIC] (18,2) NOT NULL,
	ProductProfitMarginUnitPercent [INT] NOT NULL
	)
END
GO

-- ====================================
-- load dimProduct table
-- ====================================

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN 
	INSERT INTO DestinationSystem.dbo.dimProduct
	(
	ProductID,
	ProductTypeID,
	ProductCategoryID,
	ProductName,
	ProductType,
	ProductCategory,
	ProductRetailPrice,
	ProductWholesalePrice,
	ProductCost,
	ProductRetailProfit,
	ProductWholesaleUnitProfit,
	ProductProfitMarginUnitPercent
	)
	SELECT
	p.ProductID AS ProductID,
	pt.ProductTypeID AS ProductTypeID,
	pc.ProductCategoryID AS ProductCategoryID,
	p.Product AS ProductName,
	pt.ProductType AS ProductType,
	pc.ProductCategory AS ProductCategory,
	p.Price AS ProductRetailPrice,
	p.WholesalePrice AS ProductWholesalePrice,
	p.Cost AS ProductCost,
	p.Price - p.Cost AS ProductRetailProfit,
	p.WholesalePrice - p.Cost AS ProductWholesaleUnitProfit,
	(p.Price - p.Cost) / p.Price AS ProductProfitMarginUnitPercent  

	FROM StageProduct p 
	INNER JOIN StageProductType pt
	ON p.ProductTypeID = pt.ProductTypeID
	INNER JOIN StageProductCategory pc
	ON pc.ProductCategoryID = pt.ProductCategoryID;

END 
GO

	
-- ====================================
-- load dimProduct Unkown table
-- ====================================

SET IDENTITY_INSERT dbo.dimProduct ON;

INSERT INTO DestinationSystem.dbo.dimProduct
(
dimProductKey,
ProductID,
ProductTypeID,
ProductCategoryID,
ProductName,
ProductType,
ProductCategory,
ProductRetailPrice,
ProductWholesalePrice,
ProductCost,
ProductRetailProfit,
ProductWholesaleUnitProfit,
ProductProfitMarginUnitPercent
)
VALUES
(
-1,
-1,
-1,
-1,
'Unknown',
'Unknown',
'Unknown',
-1,
-1,
-1,
-1,
-1,
-1
);

-- Turn off identity insert so new rows auto assign identities

SET IDENTITY_INSERT dbo.dimProduct OFF;
GO


