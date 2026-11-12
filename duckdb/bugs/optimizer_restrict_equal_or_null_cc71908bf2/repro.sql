.mode list
.nullvalue NULL
PRAGMA explain_output = 'PHYSICAL_ONLY';
CREATE TABLE test(i INTEGER, j INTEGER, k integer);
INSERT INTO test VALUES (1,1,3), (2,2,4), (NULL,NULL,NULL);
SELECT i FROM test WHERE (i=j) OR (i IS NULL AND j IS NULL);
EXPLAIN SELECT (i=j) OR (i IS NULL AND j IS NULL) FROM test;
SELECT i FROM test WHERE i IS NOT DISTINCT FROM j;
EXPLAIN SELECT i IS NOT DISTINCT FROM j FROM test;
SELECT i FROM test WHERE (i IS NULL AND j IS NULL) OR (i=j);
EXPLAIN SELECT (i IS NULL AND j IS NULL) OR (i=j) FROM test;
CREATE TABLE projection_test(a INTEGER, b INTEGER);
INSERT INTO projection_test VALUES (0, NULL);
SELECT a = b OR (a IS NULL AND b IS NULL) AS v FROM projection_test;
SELECT (a IS NULL AND b IS NULL) OR a = b AS v FROM projection_test;
SELECT count(*)
FROM (VALUES (0::INTEGER, NULL::INTEGER)) l(a, b)
JOIN (VALUES (false)) r(c)
  ON (l.a = l.b OR (l.a IS NULL AND l.b IS NULL)) = r.c;
