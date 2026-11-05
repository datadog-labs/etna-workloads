CREATE TABLE ab1 (a int, b int, c int);
CREATE STATISTICS s1 ON a, b FROM ab1;
ALTER TABLE ab1 DROP COLUMN a;
SELECT stxname FROM pg_statistic_ext WHERE stxname = 's1';
