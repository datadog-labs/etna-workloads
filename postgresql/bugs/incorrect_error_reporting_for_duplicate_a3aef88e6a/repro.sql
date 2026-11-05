CREATE TABLE ctv_data (x int, y int, v text);
INSERT INTO ctv_data SELECT 1, x, '*' || x FROM generate_series(1,10) x;
INSERT INTO ctv_data VALUES (1, 10, '*');
SELECT * FROM ctv_data \crosstabview
DROP TABLE ctv_data;
