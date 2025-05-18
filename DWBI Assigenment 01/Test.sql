select * from Dim_Product


ALTER TABLE Dim_Customer
ALTER COLUMN ZipCodePrefix VARCHAR(50);


ALTER TABLE Dim_Customer
ADD ZipCodePrefix_INT INT;

update Dim_Customer set City='timoteor' where CustomerID='06b8999e2fba1a1fbc88172c00ba8bc7'


SELECT *
FROM Dim_Customer
WHERE CustomerID = '27b9b3217455ef3216750451749d40b'
  AND IsCurrent = 1
  AND (
        CustomerUniqueID != '2774970d0435b6062fe44754b89e9181'
     OR ZipCodePrefix != 6727
     OR City != 'cotia'
     OR State != 'SP'
  );


UPDATE Dim_Customer
SET IsCurrent = 0, ModifiedDate = GETDATE()
WHERE CustomerID = '27b9b3217455ef3216750451749d40b'
  AND IsCurrent = 1;

INSERT INTO Dim_Customer (CustomerID, CustomerUniqueID, ZipCodePrefix, City, State)
VALUES ('27b9b3217455ef3216750451749d40b', '2774970d0435b6062fe44754b89e9181', 6727, 'cotia', 'SP');

UPDATE Dim_Seller
SET IsCurrent = 0, ModifiedDate = GETDATE()
WHERE SellerID = 'd1b65fc7debc3361ea86b5f14c68d2e2'
  AND IsCurrent = 1;

INSERT INTO Dim_Customer (CustomerID, CustomerUniqueID, ZipCodePrefix, City, State)
VALUES ('5e274e7a0c3809e14aba7ad5aae0d407', '57b2a98a409812fe9618067b6b8ebe4f', 3937, 'Jaffna', 'CP');

SELECT name
FROM sys.procedures
ORDER BY name;

select * from Dim_Seller

UPDATE Dim_Seller
SET IsCurrent = 0,State='CP',
    ModifiedDate = GETDATE()
WHERE SellerID = 'ce3ad9de960102d0677a81f5d0bb7b2d'
  AND IsCurrent = 1;

  INSERT INTO Dim_Seller (SellerID,ZipCodePrefix, City, State)
VALUES ('51a04a8a6bdcb23deccc82b0b80742cf',3937, 'Colombo', 'WP')

select * from Dim_Seller
where State='CP'

UPDATE Dim_Seller
SET IsCurrent = 0, ModifiedDate = GETDATE()
WHERE SellerID = '51a04a8a6bdcb23deccc82b0b80742cf'
  AND IsCurrent = 1;


UPDATE Dim_Seller
SET IsCurrent = 0, ModifiedDate = GETDATE()
WHERE SellerID = '4f2d8ab171c80ec8364f7c12e35b23ad' AND IsCurrent = 1;

INSERT INTO Dim_Seller (SellerID, ZipCodePrefix, City, State)
VALUES ('4f2d8ab171c80ec8364f7c12e35b23ad', 54321, 'JAffna', 'CA');

select * from Dim_Customer

EXEC dbo.UpdateDimProduct '"1e9e8ef04dbcff4541ed26657ea517e5"', 'Toys', 10, 300, 4, 500, 30, 20, 10;
EXEC dbo.UpdateDimProduct '1e9e8ef04dbcff4541ed26657ea517e5', 'Toy', 15, 300, 4, 500, 30, 20, 10;


update Dim_Customer
set City='KANDY'
where CustomerID='d1b65fc7debc3361ea86b5f14c68d2e2'


select * from fact_order
where OrderID='53cdb2fc8bc7dce0b6741e2150273451'


select * from fact_order_updates
select * from fact_order

SELECT *
FROM fact_order
WHERE accm_txn_complete_time IS NOT NULL;

Select * from fact_order
 
delete from 

INSERT INTO fact_order_updates(order_id, accm_txn_complete_time)
VALUES
('23f553848a03aaab35bb3f9f87725125', '2025-05-5 17:47:30.000');

UPDATE F
SET F.GeolocationSK = G.GeolocationSK
FROM Fact_Order F
JOIN Dim_Geolocation G
  ON F.geolocation_zip_code_prefix = G.ZipCodePrefix;
