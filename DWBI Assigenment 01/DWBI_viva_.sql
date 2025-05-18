Select * from fact_order

Select * from Dim_Seller
Select * from Dim_Customer

SELECT *
FROM fact_order
WHERE accm_txn_complete_time IS NOT NULL;

SELECT *
FROM Dim_Customer
WHERE EndDate IS NOT NULL;






