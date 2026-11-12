.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
CREATE TABLE integers(i INTEGER, j INTEGER);
PRAGMA explain_output = OPTIMIZED_ONLY;
INSERT INTO integers VALUES (1,1), (2,2), (3, 3), (4,4);
EXPLAIN SELECT i FROM integers LIMIT 4;
SELECT i FROM integers LIMIT 4;
EXPLAIN SELECT i FROM (SELECT i, i+1 FROM integers) LIMIT 4;
SELECT i FROM (SELECT i, i+1 FROM integers) LIMIT 4 OFFSET 2;
EXPLAIN SELECT i FROM integers OFFSET 4;
EXPLAIN SELECT i FROM integers LIMIT 4 OFFSET 2;
SELECT i FROM integers LIMIT 4 OFFSET 2;
EXPLAIN SELECT i + 1 FROM range(8193) t(i) LIMIT 8192;
CREATE SEQUENCE s START 1;
EXPLAIN SELECT nextval('s') AS v FROM integers LIMIT 1 OFFSET 1;
