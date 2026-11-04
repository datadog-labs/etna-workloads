CREATE TABLE test_data (int_col INT, float_col FLOAT) AS VALUES (1, 1.0), (5, 2.0), (10, 3.0), (11, 4.0), (0, 5.0);
SELECT * FROM (SELECT * FROM test_data WHERE int_col > 1 AND int_col < 10) WHERE int_col >= 1 AND int_col <= 10 ORDER BY int_col;
SELECT * FROM test_data WHERE int_col >= 1 AND int_col > 1 ORDER BY int_col;
SELECT * FROM test_data WHERE int_col > 1 AND int_col >= 1 ORDER BY int_col;
EXPLAIN SELECT * FROM (SELECT * FROM test_data WHERE int_col > 1 AND int_col < 10) WHERE int_col >= 1 AND int_col <= 10;
