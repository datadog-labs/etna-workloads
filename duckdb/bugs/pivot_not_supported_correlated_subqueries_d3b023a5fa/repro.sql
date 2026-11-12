.mode list
.nullvalue NULL
CREATE TABLE Product(DaysToManufacture int, StandardCost int);
INSERT INTO Product VALUES (0, 5.0885), (1, 223.88), (2, 359.1082), (4, 949.4105);
SET pivot_filter_threshold=0;
SELECT DaysToManufacture, StandardCost, (SELECT ["0", "1", "2", "3", "4"] FROM
	(SELECT DaysToManufacture < StandardCost) AS SourceTable
	PIVOT
	(
	  AVG(StandardCost)
	  FOR DaysToManufacture IN (0, 1, 2, 3, 4)
	) AS PivotTable
)
FROM Product;
