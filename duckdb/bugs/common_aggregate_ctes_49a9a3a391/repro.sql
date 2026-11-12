.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
CREATE TABLE integers(i INTEGER);
INSERT INTO integers VALUES (1), (2), (3);
PRAGMA explain_output = 'OPTIMIZED_ONLY';
EXPLAIN SELECT COUNT(*), COUNT(), COUNT(i) FROM integers;
SELECT COUNT(*), COUNT(), COUNT(i) FROM integers;
EXPLAIN SELECT COUNT(*), COUNT(), SUM(i), COUNT(i), SUM(i) / COUNT(i) FROM integers;
SELECT COUNT(*), COUNT(), SUM(i), COUNT(i), SUM(i) / COUNT(i) FROM integers;
INSERT INTO integers VALUES (NULL);
EXPLAIN SELECT COUNT(*), COUNT(), SUM(i), COUNT(i), SUM(i) / COUNT(i) FROM integers;
SELECT COUNT(*), COUNT(), SUM(i), COUNT(i), SUM(i) / COUNT(i) FROM integers;
CREATE TABLE groups(grp INTEGER, aggr1 INTEGER, aggr2 INTEGER, aggr3 INTEGER);
INSERT INTO groups VALUES (1, 1, 2, 3), (1, 2, 4, 6), (2, 1, 2, 3),  (2, 3, 6, 9);
SELECT
    sum(aggr1)::DOUBLE / count(aggr1)::DOUBLE AS avg_qty,
    sum(aggr2)::DOUBLE / count(aggr2)::DOUBLE AS avg_price,
    sum(aggr3)::DOUBLE / count(aggr3)::DOUBLE AS avg_disc
FROM
    groups
GROUP BY
    grp
ORDER BY grp;
SELECT
  name,
  MAX(SUM(n)) OVER (PARTITION BY name)          AS w1,
  SUM(n) / MAX(SUM(n)) OVER (PARTITION BY name) AS w2
FROM (VALUES ('a',1),('a',2),('b',3)) t(name, n)
GROUP BY name
ORDER BY ALL;
