-- Customer Dimension
CREATE TABLE Dim_Customer (
    CustomerSK INT PRIMARY KEY IDENTITY(1,1), -- Surrogate Key
    CustomerID VARCHAR(50),                   -- Business (Natural) Key
    CustomerUniqueID VARCHAR(50),
    ZipCodePrefix VARCHAR(50),
    City VARCHAR(50),
    State CHAR(2),
    IsCurrent BIT DEFAULT 1,                  -- 1 = Active, 0 = Inactive (expired version)
    StartDate DATETIME DEFAULT GETDATE(),      -- When this version became active
    EndDate DATETIME,                          -- When this version expired (NULL if current)
    InsertDate DATETIME DEFAULT GETDATE(),     -- Row Inserted in DW
    ModifiedDate DATETIME                      -- Last Modified
);




ALTER TABLE Fact_Order
ADD GeolocationSK INT;

ALTER TABLE Fact_Order
DROP CONSTRAINT FK_FactOrder_DimGeolocation;

ALTER TABLE Fact_Order
ADD geolocation_zip_code_prefix VARCHAR(50);


ALTER TABLE Fact_Order
ADD CONSTRAINT FK_FactOrder_DimGeolocation
FOREIGN KEY (GeolocationSK) REFERENCES Dim_Geolocation(GeolocationSK);

ALTER TABLE Fact_Order
DROP CONSTRAINT FK_FactOrder_DimGeolocation;


drop Table Dim_Seller
delete from Dim_Seller



-- Seller Dimension
CREATE TABLE Dim_Seller (
    SellerSK INT PRIMARY KEY IDENTITY(1,1),
    SellerID VARCHAR(50),                -- Business Key
    ZipCodePrefix VARCHAR(50),
    City VARCHAR(50),
    State CHAR(2),
    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME,
	StartDate DATETIME DEFAULT GETDATE(),      -- When this version became active
    EndDate DATETIME,  
);

-- Product Dimension
CREATE TABLE Dim_Product (
    ProductSK INT PRIMARY KEY IDENTITY(1,1),
    ProductID VARCHAR(50),                -- Business Key
    CategoryName VARCHAR(100),
    ProductNameLength INT,
    ProductDescriptionLength INT,
    ProductPhotosQty INT,
    ProductWeightG INT,
    ProductLengthCm INT,
    ProductHeightCm INT,
    ProductWidthCm INT,
    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME
);

-- Geolocation Dimension
CREATE TABLE Dim_Geolocation ( GeolocationSK INT PRIMARY KEY IDENTITY(1,1), 
ZipCodePrefix VARCHAR(50), Latitude VARCHAR(50),
 Longitude VARCHAR(50), City VARCHAR(50), 
 State VARCHAR(50),
  InsertDate DATETIME DEFAULT GETDATE(),
   ModifiedDate DATETIME );


-- Date Dimension (you will need to create Date dimension separately usually)
CREATE TABLE Dim_Date (
    DateKey INT PRIMARY KEY,              -- Format: YYYYMMDD
    FullDate DATE,
    Day INT,
    Month INT,
    Quarter INT,
    Year INT,
    InsertDate DATETIME DEFAULT GETDATE()
);

-- Fact Table: Orders / Sales
CREATE TABLE Fact_Order (
    FactOrderID INT PRIMARY KEY IDENTITY(1,1),  -- Surrogate Key (optional but recommended)

    CustomerSK INT,
    SellerSK INT,
    ProductSK INT,
    OrderDateSK INT,           -- Surrogate Key from Dim_Date
    PaymentDateSK INT,         -- Surrogate Key from Dim_Date
              
    OrderID VARCHAR(50),        -- Business Key from Source (optional to keep)
    OrderStatus VARCHAR(20),
    ProductPrice DECIMAL(10,2),
    FreightValue DECIMAL(10,2),
    PaymentType VARCHAR(50),
    PaymentInstallments INT,
    PaymentValue DECIMAL(10,2),   

    accm_txn_create_time DATETIME,
    accm_txn_complete_time DATETIME,
    txn_process_time_hours DECIMAL(10,2),

    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME,

    -- Foreign Key Constraints
    FOREIGN KEY (CustomerSK) REFERENCES Dim_Customer(CustomerSK),
    FOREIGN KEY (SellerSK) REFERENCES Dim_Seller(SellerSK),
    FOREIGN KEY (ProductSK) REFERENCES Dim_Product(ProductSK),
    FOREIGN KEY (OrderDateSK) REFERENCES Dim_Date(DateKey),
    FOREIGN KEY (PaymentDateSK) REFERENCES Dim_Date(DateKey)
);

ALTER TABLE Fact_Order
ALTER COLUMN txn_process_time_hours INT;


ALTER TABLE Fact_Order
ADD 
    accm_txn_create_time DATETIME,
    accm_txn_complete_time DATETIME,
    txn_process_time_hours INT;

delete from Fact_Order
drop table Fact_Order


DECLARE @StartDate DATE = '2010-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO Dim_Date
    (
        DateKey,
        FullDate,
        Day,
        Month,
        Quarter,
        Year,
        InsertDate
    )
    VALUES
    (
        CONVERT(INT, FORMAT(@StartDate, 'yyyyMMdd')),
        @StartDate,
        DAY(@StartDate),
        MONTH(@StartDate),
        DATEPART(QUARTER, @StartDate),
        YEAR(@StartDate),
        GETDATE()
    );

    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;

select * from Fact_Order


UPDATE Fact_Order
SET 
  accm_txn_complete_time = '2025-04-01 14:00:00',
  txn_process_time_hours = DATEDIFF(HOUR, accm_txn_create_time, '2025-04-01 14:00:00'),
  ModifiedDate = GETDATE()
WHERE OrderID = 'sample_order_id';

ALTER TABLE Fact_Order
ALTER COLUMN txn_process_time_hours INT;

select * from fact_order



SELECT * 
FROM Fact_Order
WHERE accm_txn_complete_time IS NOT NULL;

