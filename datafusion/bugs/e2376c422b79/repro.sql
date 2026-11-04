CREATE TABLE input_table ("row" integer, "x" double precision);
INSERT INTO input_table VALUES (1, 'NaN'), (2, 1.0), (2, 'NaN');
SELECT "row", max(x), min(x) FROM input_table GROUP BY "row" ORDER BY "row";
