.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
PRAGMA explain_output = OPTIMIZED_ONLY;
CREATE TABLE tbl AS SELECT * FROM VALUES (0, {'x': 0}, 0), (0, {'x': 1}, 1), (1, {'x': 2}, 2), (null, {'x': 3}, 3), (null, {'x': 4}, 4), t(grp, a, b);
CREATE TABLE tbl_with_null AS SELECT * FROM VALUES (0, [0], null), (0, [1], 1), (1, [2], null), (null, [3], 3), (null, [4], 4), t(grp, a, b);
CREATE TABLE tbl2(generated_col AS (x + 1), x INTEGER, y VARCHAR);
INSERT INTO tbl2 VALUES (0, 'a'), (1, 'b'), (null, 'c');
CREATE TABLE topn_filter_l(id INTEGER, k INTEGER, x DOUBLE, y DOUBLE);
CREATE TABLE topn_filter_r(id INTEGER, z DOUBLE);
INSERT INTO topn_filter_l VALUES (1, 0, 5, 5), (1, 1, 1, 1), (1, 2, 2, 2), (2, 0, 9, 9);
INSERT INTO topn_filter_r VALUES (1, 3), (2, 3);
SELECT c.id, c.x, c.y
FROM topn_filter_l c
JOIN topn_filter_r p USING (id)
WHERE greatest(c.x, p.z) = p.z
QUALIFY row_number() OVER (PARTITION BY c.id ORDER BY c.k) = 1;
EXPLAIN SELECT c.id, c.x, c.y
FROM topn_filter_l c
JOIN topn_filter_r p USING (id)
WHERE greatest(c.x, p.z) = p.z
QUALIFY row_number() OVER (PARTITION BY c.id ORDER BY c.k) = 1;
CREATE TABLE topn_dup_l(id INTEGER, k INTEGER, p VARCHAR);
CREATE TABLE topn_dup_r(k INTEGER, s INTEGER);
INSERT INTO topn_dup_l VALUES (1, 1, 'x');
INSERT INTO topn_dup_r VALUES (1, 20), (1, 10);
EXPLAIN SELECT id, p
FROM (
	SELECT topn_dup_l.id, topn_dup_l.p, topn_dup_r.s
	FROM topn_dup_l
	JOIN topn_dup_r ON topn_dup_l.k = topn_dup_r.k
) AS src
QUALIFY ROW_NUMBER() OVER (ORDER BY s DESC NULLS LAST) <= 2;
CREATE TABLE empty_topn(s INTEGER, p INTEGER);
SELECT p
FROM empty_topn
QUALIFY row_number() OVER (ORDER BY s) <= 1;
INSERT INTO empty_topn VALUES (1, 42);
SELECT p
FROM empty_topn
WHERE s < random()
QUALIFY row_number() OVER (ORDER BY s) <= 1;
CREATE TABLE expression_nulls(id INTEGER PRIMARY KEY);
INSERT INTO expression_nulls VALUES (1), (2), (3);
SELECT id, row_number() OVER (ORDER BY NULLIF(id % 3, 0) DESC NULLS LAST) AS rn
FROM expression_nulls
QUALIFY rn <= 3
ORDER BY rn;
SELECT row_number() OVER (ORDER BY NULLIF(id % 3, 0) DESC NULLS LAST) AS rn
FROM expression_nulls
QUALIFY rn <= 3
ORDER BY rn;
SELECT count(*), count(id)
FROM (
	SELECT id
	FROM expression_nulls
	QUALIFY row_number() OVER (ORDER BY NULLIF(id, id) NULLS LAST) = 1
);
SELECT count(*), count(id), min(rn), max(rn)
FROM (
	SELECT id, row_number() OVER (ORDER BY TRY_CAST(id::VARCHAR || 'x' AS INTEGER) NULLS LAST) AS rn
	FROM expression_nulls
	QUALIFY rn <= 3
);
CREATE TABLE expression_null_payload(id INTEGER PRIMARY KEY, payload VARCHAR NOT NULL, grp INTEGER NOT NULL);
INSERT INTO expression_null_payload VALUES (1, 'a', 1), (2, 'b', 1), (3, 'c', 1), (4, 'd', 2);
SELECT id, payload, grp, row_number() OVER (
	PARTITION BY grp ORDER BY NULLIF(id % 3, 0) DESC NULLS LAST
) AS rn
FROM expression_null_payload
QUALIFY rn <= 3
ORDER BY grp, rn;
WITH floating_values(id, val) AS (
	VALUES (1, 0.0::DOUBLE), (2, 'NaN'::DOUBLE), (3, -1.0::DOUBLE)
)
SELECT id, val
FROM floating_values
QUALIFY row_number() OVER (ORDER BY val ASC NULLS LAST) <= 2
ORDER BY id;
