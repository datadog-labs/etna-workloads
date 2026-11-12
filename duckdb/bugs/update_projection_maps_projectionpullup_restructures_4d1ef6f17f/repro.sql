.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
CREATE TABLE t1 AS SELECT range a FROM range(3, 10000);
CREATE TABLE t2 AS SELECT range b FROM range(5, 1000);
CREATE TABLE t3 AS SELECT range c FROM range(100);
CREATE TABLE t4 AS SELECT range d FROM range(10);
CREATE TABLE tbl AS SELECT range a, mod(range,10) b FROM range(10000);
PRAGMA explain_output = OPTIMIZED_ONLY;
SET disabled_optimizers to 'common_subplan,column_lifetime,compressed_materialization,statistics_propagation';
EXPLAIN SELECT * FROM (SELECT a + 1 as x, b FROM tbl) subq JOIN t1 ON subq.x = t1.a;
EXPLAIN SELECT a, SUM(b) AS sum_b FROM (SELECT a, b FROM tbl WHERE b > 0) GROUP BY a;
EXPLAIN SELECT * FROM (SELECT CASE WHEN a > 5 THEN a ELSE 0 END as x FROM t1) subq JOIN t2 ON subq.x = t2.b;
EXPLAIN SELECT * FROM (SELECT a.a + 1 AS newA, b.b + 2 AS newB, a.a +3 as newAA, b.b + 4 as newBB,  FROM t1 a JOIN t2 b ON a.a = b.b) AS join12
JOIN (SELECT c.c + 3 AS newC, d.d + 4 AS newD FROM t3 c JOIN t4 d ON c.c = d.d) AS join34 ON join12.newA = join34.newC;
EXPLAIN SELECT * FROM (SELECT a.a, b.b FROM t1 a JOIN t2 b ON a.a = b.b) AS join12
JOIN (SELECT c.c, d.d as newD FROM t3 c JOIN t4 d ON c.c = d.d) AS join34 ON join12.a = join34.c;
EXPLAIN SELECT * FROM (SELECT a.a, b.b FROM t1 a JOIN t2 b ON a.a = b.b) AS join12
JOIN t3 on join12.a = t3.c LIMIT 5;
EXPLAIN SELECT * FROM t1 AS join12 JOIN (SELECT c.c, d.d as newD FROM t3 c JOIN t4 d ON c.c = d.d) AS join34 ON join12.a = join34.c;
EXPLAIN SELECT a3 FROM (SELECT a2 AS a3 FROM (SELECT a1 AS a2 FROM (SELECT a AS a1 FROM tbl) AS t0) AS t1) AS t2 WHERE a3 % 2 = 0;
EXPLAIN with cte_1 as (select * from t1) select * from cte_1 join t2 on a=b limit 3;
EXPLAIN SELECT SUM(v1.i) + SUM(v2.i) AS sum_i, SUM(v1.j) + SUM(v2.j) AS sum_j
FROM (VALUES (1, 10), (2, 5), (3, 4)) AS v1(i, j)
JOIN (VALUES (1, 10), (2, 5), (3, 4)) AS v2(i, j) ON v1.i = v2.i;
EXPLAIN SELECT DISTINCT a FROM (SELECT a, b FROM (SELECT i AS a, i AS b FROM range(10) t(i)) t1) t2;
EXPLAIN SELECT * FROM range(5) INTERSECT SELECT * FROM range(5);
EXPLAIN
select * from(select a.a, b.b from (select * from t1) a join (select * from t2) b on a.a = b.b) as join12
semi join(select c.c, d.d as newD from (select * from t3) c join (select * from t4) d on c.c = d.d) as join34 on join12.a = join34.c;
CREATE OR REPLACE TABLE t1 AS SELECT range i FROM range(10);
CREATE OR REPLACE TABLE t2 AS SELECT range i FROM range(100);
CREATE VIEW v1 AS SELECT i, length(i::VARCHAR) j FROM t1 JOIN t2 using (i);
EXPLAIN SELECT i, j1.j FROM v1 j1 JOIN v1 j2 using (i);
CREATE TABLE pullup_variable(i INTEGER, v VARCHAR);
EXPLAIN SELECT s
FROM (SELECT i, substring(v, 1, 20) AS s FROM pullup_variable) p
JOIN t2 USING (i);
EXPLAIN SELECT n
FROM (SELECT i, length(v) AS n FROM pullup_variable) p
JOIN t2 USING (i);
EXPLAIN SELECT p.v
FROM (SELECT i, v FROM pullup_variable) p
JOIN t2 USING (i);
CREATE TABLE tbl1 AS SELECT range AS a FROM range(3);
CREATE TABLE tbl2 AS SELECT range AS b FROM range(1);
CREATE VIEW v AS SELECT b, COALESCE(b, 0) AS c FROM tbl2;
SELECT a, v.c FROM tbl1 LEFT JOIN v ON tbl1.a = v.b;
CREATE TABLE pullup_category(category_name VARCHAR, category_valuation BIGINT);
CREATE TABLE pullup_product(product_category_name VARCHAR);
CREATE TABLE pullup_address(address_valuation BIGINT);
INSERT INTO pullup_category VALUES ('a', 432), ('b', 1);
INSERT INTO pullup_product VALUES ('a'), ('b');
INSERT INTO pullup_address VALUES (432), (120);
SELECT COUNT(*)
FROM pullup_category AS root
LEFT JOIN (
	SELECT
		product_category_name,
		MIN(DISTINCT address_valuation) AS rp_207,
		MIN(DISTINCT address_valuation) AS rp_208,
		MIN(DISTINCT address_valuation) AS rp_212
	FROM pullup_product, pullup_address
	GROUP BY product_category_name
) AS rp ON root.category_name = rp.product_category_name
WHERE COALESCE(rp.rp_207, root.category_valuation) IN (432, 120, 150, 160, 110, 800, 450, 330);
