CREATE OR ALTER PROCEDURE dbo.UpdateDimProduct
    @ProductID VARCHAR(50),
    @CategoryName VARCHAR(100),
    @ProductNameLength INT,
    @ProductDescriptionLength INT,
    @ProductPhotosQty INT,
    @ProductWeightG INT,
    @ProductLengthCm INT,
    @ProductHeightCm INT,
    @ProductWidthCm INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if Product exists
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.Dim_Product
        WHERE ProductID = @ProductID
    )
    BEGIN
        -- Insert new record
        INSERT INTO dbo.Dim_Product (
            ProductID,
            CategoryName,
            ProductNameLength,
            ProductDescriptionLength,
            ProductPhotosQty,
            ProductWeightG,
            ProductLengthCm,
            ProductHeightCm,
            ProductWidthCm,
            InsertDate,
            ModifiedDate
        )
        VALUES (
            @ProductID,
            @CategoryName,
            @ProductNameLength,
            @ProductDescriptionLength,
            @ProductPhotosQty,
            @ProductWeightG,
            @ProductLengthCm,
            @ProductHeightCm,
            @ProductWidthCm,
            GETDATE(),   -- InsertDate
            NULL         -- ModifiedDate (new insert, no modification yet)
        );
    END
    ELSE
    BEGIN
        -- Only update if any actual data changed
        IF EXISTS (
            SELECT 1
            FROM dbo.Dim_Product
            WHERE ProductID = @ProductID
              AND (
                    ISNULL(CategoryName, '') <> ISNULL(@CategoryName, '') OR
                    ISNULL(ProductNameLength, -1) <> ISNULL(@ProductNameLength, -1) OR
                    ISNULL(ProductDescriptionLength, -1) <> ISNULL(@ProductDescriptionLength, -1) OR
                    ISNULL(ProductPhotosQty, -1) <> ISNULL(@ProductPhotosQty, -1) OR
                    ISNULL(ProductWeightG, -1) <> ISNULL(@ProductWeightG, -1) OR
                    ISNULL(ProductLengthCm, -1) <> ISNULL(@ProductLengthCm, -1) OR
                    ISNULL(ProductHeightCm, -1) <> ISNULL(@ProductHeightCm, -1) OR
                    ISNULL(ProductWidthCm, -1) <> ISNULL(@ProductWidthCm, -1)
                  )
        )
        BEGIN
            -- Update record
            UPDATE dbo.Dim_Product
            SET 
                CategoryName = @CategoryName,
                ProductNameLength = @ProductNameLength,
                ProductDescriptionLength = @ProductDescriptionLength,
                ProductPhotosQty = @ProductPhotosQty,
                ProductWeightG = @ProductWeightG,
                ProductLengthCm = @ProductLengthCm,
                ProductHeightCm = @ProductHeightCm,
                ProductWidthCm = @ProductWidthCm,
                ModifiedDate = GETDATE()
            WHERE ProductID = @ProductID;
        END
        -- else ➔ do nothing
    END
END

drop table Dim_Product
select * from Dim_Product

CREATE OR ALTER PROCEDURE dbo.UpdateDimGeolocation
    @ZipCodePrefix INT,
    @Latitude FLOAT,
    @Longitude FLOAT,
    @City VARCHAR(50),
    @State CHAR(2)
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if record exists
    IF NOT EXISTS (
        SELECT GeolocationSK
        FROM dbo.Dim_Geolocation
        WHERE ZipCodePrefix = @ZipCodePrefix
    )
    BEGIN
        -- Insert new record
        INSERT INTO dbo.Dim_Geolocation
        (
            ZipCodePrefix,
            Latitude,
            Longitude,
            City,
            State,
            InsertDate,
            ModifiedDate,
            IsCurrent
        )
        VALUES
        (
            @ZipCodePrefix,
            @Latitude,
            @Longitude,
            @City,
            @State,
            GETDATE(),
            GETDATE(),
            1
        );
    END
    ELSE
    BEGIN
        -- Update existing record
        UPDATE dbo.Dim_Geolocation
        SET Latitude = @Latitude,
            Longitude = @Longitude,
            City = @City,
            State = @State,
            ModifiedDate = GETDATE()
        WHERE ZipCodePrefix = @ZipCodePrefix
          AND IsCurrent = 1;
    END
END

MERGE INTO dbo.Fact_Order AS target  
USING (  
    SELECT  
        OrderID, CustomerSK, SellerSK, ProductSK,  
        OrderDateKey, PaymentDateKey,  
        OrderStatus, ProductPrice, FreightValue,  
        PaymentType, PaymentInstallments, PaymentValue  
    FROM YourSourceTableOrView  -- Replace with actual source
) AS source  
ON target.OrderID = source.OrderID  
WHEN MATCHED THEN  
    UPDATE SET  
        CustomerSK = source.CustomerSK,  
        SellerSK = source.SellerSK,  
        ProductSK = source.ProductSK,  
        OrderDateKey = source.OrderDateKey,  
        PaymentDateKey = source.PaymentDateKey,  
        OrderStatus = source.OrderStatus,  
        ProductPrice = source.ProductPrice,  
        FreightValue = source.FreightValue,  
        PaymentType = source.PaymentType,  
        PaymentInstallments = source.PaymentInstallments,  
        PaymentValue = source.PaymentValue,  
        ModifiedDate = GETDATE()  
WHEN NOT MATCHED BY TARGET THEN  
    INSERT (  
        OrderID, CustomerSK, SellerSK, ProductSK,  
        OrderDateKey, PaymentDateKey, OrderStatus,  
        ProductPrice, FreightValue, PaymentType,  
        PaymentInstallments, PaymentValue, InsertDate, ModifiedDate  
    )  
    VALUES (  
        source.OrderID, source.CustomerSK, source.SellerSK, source.ProductSK,  
        source.OrderDateKey, source.PaymentDateKey, source.OrderStatus,  
        source.ProductPrice, source.FreightValue, source.PaymentType,  
        source.PaymentInstallments, source.PaymentValue,  
        GETDATE(), NULL  
    );  


CREATE OR ALTER PROCEDURE dbo.UpdateDimGeolocation
    @ZipCodePrefix VARCHAR(50),
    @Latitude      VARCHAR(50),
    @Longitude     VARCHAR(50),
    @City          VARCHAR(50),
    @State         VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- If there is no record with the given ZipCodePrefix, insert a new row.
    IF NOT EXISTS (
        SELECT GeolocationSK 
        FROM dbo.Dim_Geolocation 
        WHERE ZipCodePrefix = @ZipCodePrefix
    )
    BEGIN
        INSERT INTO dbo.Dim_Geolocation (
            ZipCodePrefix,
            Latitude,
            Longitude,
            City,
            State,
            InsertDate,
            ModifiedDate
        )
        VALUES (
            @ZipCodePrefix,
            @Latitude,
            @Longitude,
            @City,
            @State,
            GETDATE(),  -- Set InsertDate to current date/time
            GETDATE()   -- Set ModifiedDate to current date/time on insert
        );
    END;

    -- If a record with the given ZipCodePrefix exists, update its details.
    IF EXISTS (
        SELECT GeolocationSK 
        FROM dbo.Dim_Geolocation 
        WHERE ZipCodePrefix = @ZipCodePrefix
    )
    BEGIN
        UPDATE dbo.Dim_Geolocation
        SET Latitude      = @Latitude,
            Longitude     = @Longitude,
            City          = @City,
            State         = @State,
            ModifiedDate  = GETDATE()
        WHERE ZipCodePrefix = @ZipCodePrefix;
    END
END;
ALTER TABLE StgOrder
ADD geolocation_zip_code_prefix VARCHAR(50);


select * from StgGeolocation