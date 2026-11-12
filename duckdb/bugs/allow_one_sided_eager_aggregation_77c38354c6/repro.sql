.mode list
.nullvalue NULL
CREATE TABLE fact AS SELECT
  i % 1000 AS dim_key,
  (i * 17) % 100 AS measure
FROM range(100000) _(i);
CREATE TABLE dim AS SELECT
  i AS dim_key,
  (i % 7)  AS d_a,
  (i % 11) AS d_b,
  (i % 13) AS d_c,
  (i % 17) AS d_d
FROM range(1000) _(i);
ANALYZE;
SET disabled_optimizers = 'partial_aggregate_pushdown';
SELECT round(sum(s)::DOUBLE) FROM (
  SELECT d_a, d_b, d_c, d_d, sum(measure) AS s
  FROM fact JOIN dim USING (dim_key)
  GROUP BY d_a, d_b, d_c, d_d
);
SELECT count(*) FROM (
  SELECT d_a, d_b, d_c, d_d, sum(measure) AS s
  FROM fact JOIN dim USING (dim_key)
  GROUP BY d_a, d_b, d_c, d_d
);
RESET disabled_optimizers;
SELECT round(sum(s)::DOUBLE) FROM (
  SELECT d_a, d_b, d_c, d_d, sum(measure) AS s
  FROM fact JOIN dim USING (dim_key)
  GROUP BY d_a, d_b, d_c, d_d
);
SELECT count(*) FROM (
  SELECT d_a, d_b, d_c, d_d, sum(measure) AS s
  FROM fact JOIN dim USING (dim_key)
  GROUP BY d_a, d_b, d_c, d_d
);
EXPLAIN
SELECT d_a, d_b, d_c, d_d, sum(measure)
FROM fact JOIN dim USING (dim_key)
GROUP BY d_a, d_b, d_c, d_d;
EXPLAIN
SELECT dim.dim_key, sum(measure)
FROM fact JOIN dim ON fact.dim_key = dim.dim_key
GROUP BY dim.dim_key;
EXPLAIN
SELECT d_a, sum(measure)
FROM fact JOIN dim USING (dim_key)
GROUP BY d_a;
CREATE TABLE pap_oj_fact(k INTEGER, m INTEGER);
INSERT INTO pap_oj_fact VALUES (1, 10), (1, 20), (2, 30), (3, 40), (NULL, 50);
CREATE TABLE pap_oj_dim(k INTEGER, g VARCHAR, w INTEGER);
INSERT INTO pap_oj_dim VALUES (1, 'a', 100), (1, 'b', 200), (2, 'a', 300), (4, 'z', 400), (NULL, 'n', 500);
ANALYZE;
CREATE TEMP TABLE pap_oj_enabled AS
SELECT 'left' AS q, d.g, count(*) AS c, sum(f.m) AS s
FROM pap_oj_fact f LEFT JOIN pap_oj_dim d ON f.k = d.k
GROUP BY d.g
UNION ALL
SELECT 'right' AS q, d.g, count(*) AS c, sum(f.m) AS s
FROM pap_oj_dim d RIGHT JOIN pap_oj_fact f ON d.k = f.k
GROUP BY d.g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE pap_oj_disabled AS
SELECT 'left' AS q, d.g, count(*) AS c, sum(f.m) AS s
FROM pap_oj_fact f LEFT JOIN pap_oj_dim d ON f.k = d.k
GROUP BY d.g
UNION ALL
SELECT 'right' AS q, d.g, count(*) AS c, sum(f.m) AS s
FROM pap_oj_dim d RIGHT JOIN pap_oj_fact f ON d.k = f.k
GROUP BY d.g;
SELECT count(*) FROM (SELECT * FROM pap_oj_enabled EXCEPT ALL SELECT * FROM pap_oj_disabled);
SELECT count(*) FROM (SELECT * FROM pap_oj_disabled EXCEPT ALL SELECT * FROM pap_oj_enabled);
RESET disabled_optimizers;
EXPLAIN
SELECT d.g, count(*) AS c, sum(f.m) AS s
FROM pap_oj_fact f LEFT JOIN pap_oj_dim d ON f.k = d.k
GROUP BY d.g;
EXPLAIN
SELECT d.g, count(*) AS c, sum(f.m) AS s
FROM pap_oj_dim d RIGHT JOIN pap_oj_fact f ON d.k = f.k
GROUP BY d.g;
EXPLAIN
SELECT f.k, sum(d.w) AS s
FROM pap_oj_fact f LEFT JOIN pap_oj_dim d ON f.k = d.k
GROUP BY f.k;
EXPLAIN
SELECT f.k, sum(d.w) AS s
FROM pap_oj_dim d RIGHT JOIN pap_oj_fact f ON d.k = f.k
GROUP BY f.k;
SET disabled_optimizers = 'partial_aggregate_pushdown';
SELECT round(sum(s)::DOUBLE) FROM (
  SELECT d_a, d_b, d_c, d_d, sum(measure) AS s
  FROM fact JOIN dim USING (dim_key)
  GROUP BY ROLLUP(d_a, d_b, d_c, d_d)
);
RESET disabled_optimizers;
SELECT round(sum(s)::DOUBLE) FROM (
  SELECT d_a, d_b, d_c, d_d, sum(measure) AS s
  FROM fact JOIN dim USING (dim_key)
  GROUP BY ROLLUP(d_a, d_b, d_c, d_d)
);
SET disabled_optimizers = 'partial_aggregate_pushdown';
SELECT round(sum(avg_m)::DOUBLE) FROM (
  SELECT d_a, d_b, d_c, d_d, avg(measure)::DOUBLE AS avg_m
  FROM fact JOIN dim USING (dim_key)
  GROUP BY d_a, d_b, d_c, d_d
);
RESET disabled_optimizers;
SELECT round(sum(avg_m)::DOUBLE) FROM (
  SELECT d_a, d_b, d_c, d_d, avg(measure)::DOUBLE AS avg_m
  FROM fact JOIN dim USING (dim_key)
  GROUP BY d_a, d_b, d_c, d_d
);
SELECT count(*) FROM fact JOIN dim USING (dim_key) WHERE d_a = 3;
SELECT count(*) FROM duckdb_optimizers() WHERE name = 'partial_aggregate_pushdown';
CREATE TABLE pap_fact AS
SELECT
	i % 1200 AS k,
	i % 5 AS subgrp,
	CASE WHEN i % 37 = 0 THEN NULL ELSE ((i * 17) % 1000) - 500 END AS v,
	CASE WHEN i % 29 = 0 THEN NULL ELSE ((i * 13) % 200) END AS w
FROM range(240000) t(i);
CREATE TABLE pap_dim AS
SELECT
	i AS k,
	i % 7 AS d1,
	i % 11 AS d2,
	i % 13 AS d3,
	i % 17 AS d4,
	'base_' || (i % 19)::VARCHAR AS label
FROM range(1200) t(i)
UNION ALL
SELECT
	i AS k,
	i % 7 AS d1,
	i % 11 AS d2,
	i % 13 AS d3,
	i % 17 AS d4,
	'dup_' || (i % 19)::VARCHAR AS label
FROM range(0, 1200, 9) t(i)
UNION ALL
SELECT
	NULL AS k,
	99 AS d1,
	99 AS d2,
	99 AS d3,
	99 AS d4,
	'null_key' AS label;
ANALYZE;
CREATE TEMP TABLE pap_enabled AS
SELECT d1, d2, d3, d4, subgrp,
       sum(v) AS sum_v,
       count(v) AS count_v,
       min(v) AS min_v,
       max(v) AS max_v,
       avg(w)::DOUBLE AS avg_w
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4, subgrp;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE pap_disabled AS
SELECT d1, d2, d3, d4, subgrp,
       sum(v) AS sum_v,
       count(v) AS count_v,
       min(v) AS min_v,
       max(v) AS max_v,
       avg(w)::DOUBLE AS avg_w
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4, subgrp;
SELECT count(*) FROM (
	SELECT * FROM pap_enabled
	EXCEPT ALL
	SELECT * FROM pap_disabled
);
SELECT count(*) FROM (
	SELECT * FROM pap_disabled
	EXCEPT ALL
	SELECT * FROM pap_enabled
);
RESET disabled_optimizers;
EXPLAIN SELECT d1, d2, d3, d4, subgrp,
       sum(v), count(v), min(v), max(v), avg(w)::DOUBLE
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4, subgrp;
CREATE TEMP TABLE pap_rollup_enabled AS
SELECT d1, d2, d3, d4,
       sum(v) AS sum_v,
       count(v) AS count_v,
       min(v) AS min_v,
       max(v) AS max_v,
       avg(w)::DOUBLE AS avg_w
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY ROLLUP(d1, d2, d3, d4);
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE pap_rollup_disabled AS
SELECT d1, d2, d3, d4,
       sum(v) AS sum_v,
       count(v) AS count_v,
       min(v) AS min_v,
       max(v) AS max_v,
       avg(w)::DOUBLE AS avg_w
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY ROLLUP(d1, d2, d3, d4);
SELECT count(*) FROM (
	SELECT * FROM pap_rollup_enabled
	EXCEPT ALL
	SELECT * FROM pap_rollup_disabled
);
SELECT count(*) FROM (
	SELECT * FROM pap_rollup_disabled
	EXCEPT ALL
	SELECT * FROM pap_rollup_enabled
);
RESET disabled_optimizers;
EXPLAIN SELECT d1, d2, d3, d4,
       sum(v), count(v), min(v), max(v), avg(w)::DOUBLE
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY ROLLUP(d1, d2, d3, d4);
CREATE TEMP TABLE pap_excluded_enabled AS
SELECT 'selective' AS q, sum(v)::DOUBLE AS x
FROM pap_fact JOIN pap_dim USING (k)
WHERE d1 = 3 AND d2 = 4
GROUP BY d1, d2, d3, d4
UNION ALL
SELECT 'count_star' AS q, count(*)::DOUBLE AS x
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4
UNION ALL
SELECT 'filter' AS q, sum(v) FILTER (WHERE v > 0)::DOUBLE AS x
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4
UNION ALL
SELECT 'distinct' AS q, sum(DISTINCT v)::DOUBLE AS x
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE pap_excluded_disabled AS
SELECT 'selective' AS q, sum(v)::DOUBLE AS x
FROM pap_fact JOIN pap_dim USING (k)
WHERE d1 = 3 AND d2 = 4
GROUP BY d1, d2, d3, d4
UNION ALL
SELECT 'count_star' AS q, count(*)::DOUBLE AS x
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4
UNION ALL
SELECT 'filter' AS q, sum(v) FILTER (WHERE v > 0)::DOUBLE AS x
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4
UNION ALL
SELECT 'distinct' AS q, sum(DISTINCT v)::DOUBLE AS x
FROM pap_fact JOIN pap_dim USING (k)
GROUP BY d1, d2, d3, d4;
SELECT count(*) FROM (
	SELECT * FROM pap_excluded_enabled
	EXCEPT ALL
	SELECT * FROM pap_excluded_disabled
);
SELECT count(*) FROM (
	SELECT * FROM pap_excluded_disabled
	EXCEPT ALL
	SELECT * FROM pap_excluded_enabled
);
RESET disabled_optimizers;
CREATE TABLE de_dim AS SELECT i AS k, (i % 7) AS g FROM range(50) _(i);
CREATE TABLE de_a AS SELECT (i % 50) AS k FROM range(5000) _(i);
CREATE TABLE de_b AS SELECT (i % 50) AS k, ((i * 13) % 100)::BIGINT AS m FROM range(5000) _(i);
ANALYZE;
CREATE TEMP TABLE de_enabled AS
SELECT g, count(*) AS ev, sum(b.m) AS s, count(b.m) AS c, min(b.m) AS mn, max(b.m) AS mx, avg(b.m) AS a
FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k)
GROUP BY g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE de_disabled AS
SELECT g, count(*) AS ev, sum(b.m) AS s, count(b.m) AS c, min(b.m) AS mn, max(b.m) AS mx, avg(b.m) AS a
FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k)
GROUP BY g;
SELECT count(*) FROM (
	SELECT * FROM de_enabled
	EXCEPT ALL
	SELECT * FROM de_disabled
);
SELECT count(*) FROM (
	SELECT * FROM de_disabled
	EXCEPT ALL
	SELECT * FROM de_enabled
);
RESET disabled_optimizers;
EXPLAIN
SELECT g, count(*) AS ev, sum(b.m) AS s
FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k)
GROUP BY g;
CREATE TABLE de_list_multiplicity AS
SELECT CASE WHEN i < 30 THEN 1 ELSE 2 END::INTEGER AS k, 1::INTEGER AS g
FROM range(50) _(i);
CREATE TABLE de_list_values AS
SELECT CASE WHEN i < 20 THEN 1 ELSE 2 END::INTEGER AS k,
       CASE WHEN i < 20 THEN 1 ELSE 42 END::INTEGER AS v
FROM range(40) _(i);
ANALYZE;
EXPLAIN
SELECT m.g, median(v.v)
FROM de_list_multiplicity m
INNER JOIN de_list_values v USING (k)
GROUP BY m.g;
SELECT
    m.g,
    median(v.v),
    quantile_cont(v.v, 0.5),
    mad(v.v),
    list_count(list(v.v)),
    list_sum(list(v.v))
FROM de_list_multiplicity m
INNER JOIN de_list_values v USING (k)
GROUP BY m.g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
SELECT
    m.g,
    median(v.v),
    quantile_cont(v.v, 0.5),
    mad(v.v),
    list_count(list(v.v)),
    list_sum(list(v.v))
FROM de_list_multiplicity m
INNER JOIN de_list_values v USING (k)
GROUP BY m.g;
RESET disabled_optimizers;
CREATE TABLE de_modest_dim AS SELECT i AS k, (i % 1000) AS g FROM range(5000) _(i);
CREATE TABLE de_modest_a AS SELECT (i % 5000) AS k FROM range(30000) _(i);
CREATE TABLE de_modest_b AS SELECT (i % 5000) AS k FROM range(30000) _(i);
ANALYZE;
SELECT count(*), sum(c) FROM (
	SELECT d.g, count(*) AS c
	FROM de_modest_a a JOIN de_modest_dim d USING (k) JOIN de_modest_b b USING (k)
	GROUP BY d.g
);
EXPLAIN
SELECT d.g, count(*)
FROM de_modest_a a JOIN de_modest_dim d USING (k) JOIN de_modest_b b USING (k)
GROUP BY d.g;
CREATE TABLE de_a2 AS SELECT (i % 50) AS k, ((i * 7) % 30)::BIGINT AS n FROM range(5000) _(i);
CREATE TEMP TABLE de_split_enabled AS
SELECT g, count(*) AS ev, sum(a.n) AS sn, sum(b.m) AS sm, min(a.n) AS mn, max(b.m) AS mx
FROM de_a2 a JOIN de_dim d USING (k) JOIN de_b b USING (k)
GROUP BY g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE de_split_disabled AS
SELECT g, count(*) AS ev, sum(a.n) AS sn, sum(b.m) AS sm, min(a.n) AS mn, max(b.m) AS mx
FROM de_a2 a JOIN de_dim d USING (k) JOIN de_b b USING (k)
GROUP BY g;
SELECT count(*) FROM (SELECT * FROM de_split_enabled EXCEPT ALL SELECT * FROM de_split_disabled);
SELECT count(*) FROM (SELECT * FROM de_split_disabled EXCEPT ALL SELECT * FROM de_split_enabled);
RESET disabled_optimizers;
CREATE TABLE de_bf AS SELECT (i % 50) AS k, (((i * 13) % 100) + 0.5)::DOUBLE / 7 AS m_f FROM range(5000) _(i);
CREATE TEMP TABLE de_fp_enabled AS
SELECT g, sum(b.m_f) AS s, avg(b.m_f) AS a
FROM de_a a JOIN de_dim d USING (k) JOIN de_bf b USING (k)
GROUP BY g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE de_fp_disabled AS
SELECT g, sum(b.m_f) AS s, avg(b.m_f) AS a
FROM de_a a JOIN de_dim d USING (k) JOIN de_bf b USING (k)
GROUP BY g;
RESET disabled_optimizers;
SELECT count(*) FROM de_fp_enabled e JOIN de_fp_disabled f USING (g)
WHERE abs(e.s - f.s) > 1e-9 * abs(f.s) + 1e-9
   OR abs(e.a - f.a) > 1e-9 * abs(f.a) + 1e-9;
CREATE TABLE mk_dim AS SELECT i AS k1, (i % 3) AS k2, (i % 5) AS g FROM range(30) _(i);
CREATE TABLE mk_a AS SELECT (i % 30) AS k1, (i % 3) AS k2, (i % 4) AS af FROM range(6000) _(i);
CREATE TABLE mk_b AS SELECT (i % 30) AS k1, (i % 3) AS k2,
       CASE WHEN i % 13 = 0 THEN NULL ELSE (i % 50)::BIGINT END AS m FROM range(6000) _(i);
CREATE TEMP TABLE mk_enabled AS
SELECT g, af, count(*) AS ev, sum(b.m) AS s, count(b.m) AS c, min(b.m) AS mn, max(b.m) AS mx
FROM mk_a a JOIN mk_dim d USING (k1, k2) JOIN mk_b b USING (k1, k2)
GROUP BY g, af;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE mk_disabled AS
SELECT g, af, count(*) AS ev, sum(b.m) AS s, count(b.m) AS c, min(b.m) AS mn, max(b.m) AS mx
FROM mk_a a JOIN mk_dim d USING (k1, k2) JOIN mk_b b USING (k1, k2)
GROUP BY g, af;
SELECT count(*) FROM (SELECT * FROM mk_enabled EXCEPT ALL SELECT * FROM mk_disabled);
SELECT count(*) FROM (SELECT * FROM mk_disabled EXCEPT ALL SELECT * FROM mk_enabled);
RESET disabled_optimizers;
CREATE TABLE big_dim AS SELECT k AS keyid, k AS g FROM range(2) t(k);
CREATE TABLE big_a AS SELECT (i % 2)::BIGINT AS keyid FROM range(140000) t(i);
CREATE TABLE big_b AS SELECT (i % 2)::BIGINT AS keyid FROM range(140000) t(i);
SELECT g, count(*) AS ev
FROM big_a a JOIN big_dim d USING (keyid) JOIN big_b b USING (keyid)
GROUP BY g ORDER BY g;
CREATE TEMP TABLE neg_enabled AS
SELECT 'left' AS q, g, sum(b.m)::DOUBLE AS x
FROM de_a a JOIN de_dim d USING (k) LEFT JOIN de_b b USING (k) GROUP BY g
UNION ALL
SELECT 'distinct' AS q, g, sum(DISTINCT b.m)::DOUBLE AS x
FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k) GROUP BY g
UNION ALL
SELECT 'filter' AS q, g, sum(b.m) FILTER (WHERE b.m > 50)::DOUBLE AS x
FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k) GROUP BY g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE neg_disabled AS
SELECT 'left' AS q, g, sum(b.m)::DOUBLE AS x
FROM de_a a JOIN de_dim d USING (k) LEFT JOIN de_b b USING (k) GROUP BY g
UNION ALL
SELECT 'distinct' AS q, g, sum(DISTINCT b.m)::DOUBLE AS x
FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k) GROUP BY g
UNION ALL
SELECT 'filter' AS q, g, sum(b.m) FILTER (WHERE b.m > 50)::DOUBLE AS x
FROM de_a a JOIN de_dim d USING (k) JOIN de_b b USING (k) GROUP BY g;
SELECT count(*) FROM (SELECT * FROM neg_enabled EXCEPT ALL SELECT * FROM neg_disabled);
SELECT count(*) FROM (SELECT * FROM neg_disabled EXCEPT ALL SELECT * FROM neg_enabled);
RESET disabled_optimizers;
CREATE TABLE pj_dim AS SELECT k AS keyid, (k % 40) AS g FROM range(2000) _(k);
CREATE TABLE pj_a AS SELECT (k % 2000)::BIGINT AS keyid FROM range(20000) _(k);
CREATE TABLE pj_b AS SELECT (k % 2000)::BIGINT AS keyid, (((k * 13) % 100) + 0.5)::DOUBLE AS c FROM range(50000) _(k);
ANALYZE;
CREATE TEMP TABLE pj_enabled AS
SELECT g, count(*) AS ev, sum(b.c2) AS s
FROM pj_a a JOIN pj_dim d USING (keyid) JOIN (SELECT keyid, c * 2.0 AS c2 FROM pj_b) b USING (keyid)
GROUP BY g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE pj_disabled AS
SELECT g, count(*) AS ev, sum(b.c2) AS s
FROM pj_a a JOIN pj_dim d USING (keyid) JOIN (SELECT keyid, c * 2.0 AS c2 FROM pj_b) b USING (keyid)
GROUP BY g;
SELECT count(*) FROM pj_enabled e JOIN pj_disabled f USING (g)
WHERE e.ev <> f.ev OR abs(e.s - f.s) > 1e-9 * abs(f.s) + 1e-9;
RESET disabled_optimizers;
CREATE TABLE nw_f1 AS SELECT (k % 5)::INTEGER AS keyid, (k % 7)::BIGINT AS m1 FROM range(300) _(k);
CREATE TABLE nw_f2 AS SELECT (k % 5)::INTEGER AS keyid, (k % 11)::BIGINT AS m2 FROM range(300) _(k);
CREATE TABLE nw_f3 AS SELECT (k % 5)::INTEGER AS keyid, (k % 13)::BIGINT AS m3 FROM range(300) _(k);
ANALYZE;
CREATE TEMP TABLE nw_enabled AS
SELECT f1.keyid AS keyid, count(*) AS c, sum(m1) AS s1, sum(m2) AS s2, sum(m3) AS s3,
       min(m1) AS mn, max(m3) AS mx, count(m2) AS cm
FROM nw_f1 f1 JOIN nw_f2 f2 USING (keyid) JOIN nw_f3 f3 USING (keyid)
GROUP BY f1.keyid;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE nw_disabled AS
SELECT f1.keyid AS keyid, count(*) AS c, sum(m1) AS s1, sum(m2) AS s2, sum(m3) AS s3,
       min(m1) AS mn, max(m3) AS mx, count(m2) AS cm
FROM nw_f1 f1 JOIN nw_f2 f2 USING (keyid) JOIN nw_f3 f3 USING (keyid)
GROUP BY f1.keyid;
SELECT count(*) FROM (
	SELECT * FROM nw_enabled
	EXCEPT ALL
	SELECT * FROM nw_disabled
);
SELECT count(*) FROM (
	SELECT * FROM nw_disabled
	EXCEPT ALL
	SELECT * FROM nw_enabled
);
RESET disabled_optimizers;
EXPLAIN
SELECT f1.keyid AS keyid, count(*) AS c, sum(m1) AS s1, sum(m3) AS s3
FROM nw_f1 f1 JOIN nw_f2 f2 USING (keyid) JOIN nw_f3 f3 USING (keyid)
GROUP BY f1.keyid;
CREATE TABLE access_log  AS SELECT (k % 8)::INTEGER AS keyid, (k % 101)::BIGINT AS bytes_sent FROM range(320) _(k);
CREATE TABLE user_profile AS SELECT (k % 8)::INTEGER AS keyid, (k % 7)::BIGINT   AS age        FROM range(320) _(k);
CREATE TABLE location     AS SELECT (k % 8)::INTEGER AS keyid, (k % 13)::BIGINT  AS region     FROM range(320) _(k);
ANALYZE;
CREATE TEMP TABLE cust_enabled AS
SELECT a.keyid AS keyid, count(*) AS hits, sum(bytes_sent) AS total_bytes, sum(age) AS sum_age, sum(region) AS sum_region
FROM access_log a JOIN user_profile u USING (keyid) JOIN location l USING (keyid)
GROUP BY a.keyid;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE cust_disabled AS
SELECT a.keyid AS keyid, count(*) AS hits, sum(bytes_sent) AS total_bytes, sum(age) AS sum_age, sum(region) AS sum_region
FROM access_log a JOIN user_profile u USING (keyid) JOIN location l USING (keyid)
GROUP BY a.keyid;
SELECT count(*) FROM (SELECT * FROM cust_enabled EXCEPT ALL SELECT * FROM cust_disabled);
SELECT count(*) FROM (SELECT * FROM cust_disabled EXCEPT ALL SELECT * FROM cust_enabled);
RESET disabled_optimizers;
EXPLAIN
SELECT a.keyid AS keyid, count(*) AS hits, sum(bytes_sent) AS total_bytes
FROM access_log a JOIN user_profile u USING (keyid) JOIN location l USING (keyid)
GROUP BY a.keyid;
CREATE TABLE ov_a AS SELECT (i % 2)::INTEGER AS k, 0::INTEGER AS g FROM range(4000) _(i);
CREATE TABLE ov_b AS SELECT (i % 2)::INTEGER AS k,
       (CASE WHEN i % 2 = 0 THEN 1 ELSE -1 END * 85000000000000000000000000000000::HUGEINT) AS m
       FROM range(4000) _(i);
ANALYZE;
SELECT a.g, sum(b.m) AS s FROM ov_a a JOIN ov_b b USING (k) GROUP BY a.g;
EXPLAIN SELECT a.g, sum(b.m) AS s FROM ov_a a JOIN ov_b b USING (k) GROUP BY a.g;
EXPLAIN SELECT a.g, avg(b.m) AS s FROM ov_a a JOIN ov_b b USING (k) GROUP BY a.g;
EXPLAIN SELECT a.g, count(*), min(b.m), max(b.m) FROM ov_a a JOIN ov_b b USING (k) GROUP BY a.g;
CREATE TABLE de_typed AS SELECT
    (i % 50) AS k,
    ((i * 13) % 100)::TINYINT AS c_i8,
    ((i * 13) % 1000)::SMALLINT AS c_i16,
    ((i * 13) % 100000)::INTEGER AS c_i32,
    ((i * 13) % 100000)::BIGINT AS c_i64,
    (((i * 13) % 10000) / 100.0)::DECIMAL(10, 2) AS c_d10,
    (((i * 7) % 100000) / 13.0)::DECIMAL(18, 4) AS c_d18,
    (((i * 13) % 100) + 0.5)::DOUBLE / 7 AS c_f64,
    DATE '2020-01-01' + ((i * 7) % 365)::INTEGER AS c_date,
    TIMESTAMP '2020-01-01' + to_seconds((i * 7) % 100000) AS c_ts,
    'v' || lpad(((i * 13) % 100)::VARCHAR, 3, '0') AS c_str
    FROM range(5000) _(i);
ANALYZE;
SELECT d.g, count(*) AS ev,
    sum(f.c_i8) AS s8, min(f.c_i8) AS n8, max(f.c_i8) AS x8,
    sum(f.c_i16) AS s16, min(f.c_i16) AS n16, max(f.c_i16) AS x16,
    sum(f.c_i32) AS s32, min(f.c_i32) AS n32, max(f.c_i32) AS x32,
    sum(f.c_i64) AS s64, min(f.c_i64) AS n64, max(f.c_i64) AS x64,
    sum(f.c_d10) AS sd10, min(f.c_d10) AS nd10, max(f.c_d10) AS xd10,
    sum(f.c_d18) AS sd18, min(f.c_d18) AS nd18, max(f.c_d18) AS xd18,
    count(f.c_i32) AS cc
FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k)
GROUP BY d.g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
SELECT d.g, count(*) AS ev,
    sum(f.c_i8) AS s8, min(f.c_i8) AS n8, max(f.c_i8) AS x8,
    sum(f.c_i16) AS s16, min(f.c_i16) AS n16, max(f.c_i16) AS x16,
    sum(f.c_i32) AS s32, min(f.c_i32) AS n32, max(f.c_i32) AS x32,
    sum(f.c_i64) AS s64, min(f.c_i64) AS n64, max(f.c_i64) AS x64,
    sum(f.c_d10) AS sd10, min(f.c_d10) AS nd10, max(f.c_d10) AS xd10,
    sum(f.c_d18) AS sd18, min(f.c_d18) AS nd18, max(f.c_d18) AS xd18,
    count(f.c_i32) AS cc
FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k)
GROUP BY d.g;
RESET disabled_optimizers;
SELECT d.g, count(*) AS ev,
    min(f.c_date) AS ndt, max(f.c_date) AS xdt,
    min(f.c_ts) AS nts, max(f.c_ts) AS xts,
    min(f.c_str) AS nst, max(f.c_str) AS xst
FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k)
GROUP BY d.g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
SELECT d.g, count(*) AS ev,
    min(f.c_date) AS ndt, max(f.c_date) AS xdt,
    min(f.c_ts) AS nts, max(f.c_ts) AS xts,
    min(f.c_str) AS nst, max(f.c_str) AS xst
FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k)
GROUP BY d.g;
RESET disabled_optimizers;
EXPLAIN SELECT d.g, count(*), sum(f.c_d18) FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k) GROUP BY d.g;
EXPLAIN SELECT d.g, count(*), min(f.c_date), max(f.c_str) FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k) GROUP BY d.g;
CREATE TABLE de_d38 AS SELECT (i % 50) AS k, ((i * 13) % 1000)::DECIMAL(38, 2) AS m FROM range(5000) _(i);
CREATE TABLE de_uh AS SELECT (i % 50) AS k, ((i % 100) + 1)::UHUGEINT AS m FROM range(5000) _(i);
ANALYZE;
EXPLAIN SELECT d.g, count(*), sum(f.m) FROM de_a a JOIN de_dim d USING (k) JOIN de_d38 f USING (k) GROUP BY d.g;
EXPLAIN SELECT d.g, count(*), avg(f.m) FROM de_a a JOIN de_dim d USING (k) JOIN de_d38 f USING (k) GROUP BY d.g;
EXPLAIN SELECT d.g, count(*), decimal_average(f.m) FROM de_a a JOIN de_dim d USING (k) JOIN de_d38 f USING (k) GROUP BY d.g;
CREATE TABLE de_davg_ov_a AS SELECT CASE WHEN i % 2 = 0 THEN 1 ELSE 2 END AS k,
       (CASE WHEN i % 2 = 0 THEN 1 ELSE -1 END *
        100000000000000000000000000000000000::DECIMAL(38, 0)) AS v
       FROM range(2000) _(i);
CREATE TABLE de_davg_ov_b AS SELECT * FROM (VALUES (1, 0), (1, 0), (2, 0), (2, 0)) _(k, g);
SELECT decimal_average(v) FROM de_davg_ov_a JOIN de_davg_ov_b USING (k) GROUP BY g;
EXPLAIN SELECT d.g, count(*), sum(f.m) FROM de_a a JOIN de_dim d USING (k) JOIN de_uh f USING (k) GROUP BY d.g;
SELECT d.g, count(*) AS ev, sum(f.m) AS sd FROM de_a a JOIN de_dim d USING (k) JOIN de_d38 f USING (k) GROUP BY d.g;
SELECT d.g, count(*) AS ev, sum(f.m) AS su FROM de_a a JOIN de_dim d USING (k) JOIN de_uh f USING (k) GROUP BY d.g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
SELECT d.g, count(*) AS ev, sum(f.m) AS sd FROM de_a a JOIN de_dim d USING (k) JOIN de_d38 f USING (k) GROUP BY d.g;
SELECT d.g, count(*) AS ev, sum(f.m) AS su FROM de_a a JOIN de_dim d USING (k) JOIN de_uh f USING (k) GROUP BY d.g;
RESET disabled_optimizers;
EXPLAIN SELECT d.g, kahan_sum(f.c_f64) FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k) GROUP BY d.g;
CREATE TEMP TABLE de_kahan_enabled AS
SELECT d.g, kahan_sum(f.c_f64) AS s FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k) GROUP BY d.g;
SET disabled_optimizers = 'partial_aggregate_pushdown';
CREATE TEMP TABLE de_kahan_disabled AS
SELECT d.g, kahan_sum(f.c_f64) AS s FROM de_a a JOIN de_dim d USING (k) JOIN de_typed f USING (k) GROUP BY d.g;
RESET disabled_optimizers;
SELECT count(*) FROM de_kahan_enabled e JOIN de_kahan_disabled f USING (g)
WHERE abs(e.s - f.s) > 1e-9 * abs(f.s) + 1e-9;
CREATE TABLE outer_count_owner(k INTEGER, label VARCHAR);
INSERT INTO outer_count_owner VALUES (1, 'a'), (2, 'b'), (3, 'c'), (4, 'd');
CREATE TABLE outer_count_events(k INTEGER, event_id INTEGER, keep BOOLEAN);
INSERT INTO outer_count_events
SELECT 1 + i % 3, CASE WHEN i % 11 = 0 THEN NULL ELSE i END, i % 5 != 0 FROM range(100) t(i);
ANALYZE;
EXPLAIN SELECT o.k, count(e.event_id)
FROM outer_count_owner o LEFT JOIN outer_count_events e ON o.k = e.k
GROUP BY o.k;
