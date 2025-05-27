CREATE TABLE Fact_Order (
    FactOrderID INT PRIMARY KEY IDENTITY(1,1),

    -- Foreign Keys
    CustomerSK INT,
    SellerSK INT,
    ProductSK INT,
    OrderDateKey INT,
    PaymentDateKey INT,

    -- Facts / Measures
    OrderID VARCHAR(50),
    OrderStatus VARCHAR(20),
    ProductPrice DECIMAL(10,2),
    FreightValue DECIMAL(10,2),
    PaymentType VARCHAR(50),
    PaymentInstallments INT,
    PaymentValue DECIMAL(10,2),

    InsertDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME,

    -- Foreign Key Constraints
    FOREIGN KEY (CustomerSK) REFERENCES Dim_Customer(CustomerSK),
    FOREIGN KEY (SellerSK) REFERENCES Dim_Seller(SellerSK),
    FOREIGN KEY (ProductSK) REFERENCES Dim_Product(ProductSK),
    FOREIGN KEY (OrderDateKey) REFERENCES Dim_Date(DateKey),
    FOREIGN KEY (PaymentDateKey) REFERENCES Dim_Date(DateKey)
);

select* from Dim_Customer