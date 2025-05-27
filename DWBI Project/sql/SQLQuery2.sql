CREATE PROCEDURE dbo.UpdateDimCustomer 
    @CustomerID NVARCHAR(50),
    @ZipCodePrefix NVARCHAR(20),
    @City NVARCHAR(100),
    @State NVARCHAR(50),
    @ModifiedDate DATETIME
AS
BEGIN
    -- If Customer not exists, Insert
    IF NOT EXISTS (
        SELECT CustomerSK
        FROM dbo.Dim_Customer
        WHERE CustomerID = @CustomerID
          AND IsCurrent = 1
    )
    BEGIN
        INSERT INTO dbo.Dim_Customer 
        (CustomerID, ZipCodePrefix, City, State, InsertDate, ModifiedDate, IsCurrent, EffectiveDate)
        VALUES 
        (@CustomerID, @ZipCodePrefix, @City, @State, GETDATE(), GETDATE(), 1, GETDATE());
    END
    ELSE
    BEGIN
        -- Expire the old version
        UPDATE dbo.Dim_Customer
        SET IsCurrent = 0,
            ExpiryDate = GETDATE()
        WHERE CustomerID = @CustomerID
          AND IsCurrent = 1;

        -- Insert the new version
        INSERT INTO dbo.Dim_Customer 
        (CustomerID, ZipCodePrefix, City, State, InsertDate, ModifiedDate, IsCurrent, EffectiveDate)
        VALUES 
        (@CustomerID, @ZipCodePrefix, @City, @State, GETDATE(), GETDATE(), 1, GETDATE());
    END
END
===============================================

ALTER PROCEDURE dbo.UpdateDimSeller 
    @SellerID NVARCHAR(50),
    @ZipCodePrefix NVARCHAR(20),
    @City NVARCHAR(100),
    @State NVARCHAR(50),
    @ModifiedDate DATETIME
AS
BEGIN
    -- If Seller not exists, Insert
    IF NOT EXISTS (
        SELECT SellerSK
        FROM dbo.Dim_Seller
        WHERE SellerID = @SellerID
          AND IsCurrent = 1
    )
    BEGIN
        INSERT INTO dbo.Dim_Seller 
        (SellerID, ZipCodePrefix, City, State, InsertDate, ModifiedDate, IsCurrent, EffectiveDate)
        VALUES 
        (@SellerID, @ZipCodePrefix, @City, @State, GETDATE(), GETDATE(), 1, GETDATE());
    END
    ELSE
    BEGIN
        -- Expire the old version
        UPDATE dbo.Dim_Seller
        SET IsCurrent = 0,
            ExpiryDate = GETDATE()
        WHERE SellerID = @SellerID
          AND IsCurrent = 1;

        -- Insert the new version
        INSERT INTO dbo.Dim_Seller 
        (SellerID, ZipCodePrefix, City, State, InsertDate, ModifiedDate, IsCurrent, EffectiveDate)
        VALUES 
        (@SellerID, @ZipCodePrefix, @City, @State, GETDATE(), GETDATE(), 1, GETDATE());
    END
END


Alter PROCEDURE dbo.UpdateDimProductCategory
    @ProductCategoryName VARCHAR(100),
    @ProductCategoryNameEnglish VARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the category already exists
    IF NOT EXISTS (
        SELECT 1
        FROM DimProductCategory
        WHERE ProductCategoryName = @ProductCategoryName
    )
    BEGIN
        -- Insert new record
        INSERT INTO DimProductCategory (ProductCategoryName, ProductCategoryNameEnglish)
        VALUES (@ProductCategoryName, @ProductCategoryNameEnglish);
    END
END;

select * from Dim_Product
