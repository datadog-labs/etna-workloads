.mode list
.nullvalue NULL
CREATE TABLE t2__base (c_pk BIGINT NOT NULL, c_int BIGINT);
INSERT INTO t2__base VALUES (1, 5), (2, -7), (3, 0);
CREATE TABLE t2_keyed AS
SELECT c_pk, c_int, ROW_NUMBER() OVER (ORDER BY c_pk) AS eq_key_1
FROM t2__base;
CREATE VIEW t2 AS
SELECT c_pk, c_int
FROM t2_keyed
QUALIFY ROW_NUMBER() OVER (PARTITION BY eq_key_1 ORDER BY eq_key_1) = 1;
SELECT *
FROM t2
WHERE c_int::BOOLEAN
QUALIFY ROW_NUMBER() OVER (ORDER BY c_pk) <= 1;
