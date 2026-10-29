CREATE TABLE sales(emp TEXT PRIMARY KEY, region, total);
INSERT INTO sales VALUES ('Alice','North',34),('Frank','South',22),('Charles','North',45),('Darrell','South',8),('Grant','South',23),('Brad','North',22),('Elizabeth','South',99),('Horace','East',1);
SELECT emp, region, total FROM (
  SELECT emp, region, total,
    row_number() OVER (PARTITION BY region ORDER BY total DESC) AS rank
  FROM sales
) WHERE rank<=2 ORDER BY region, total DESC;
