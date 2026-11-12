.mode list
.nullvalue NULL
SET profiling_renderer_settings = MAP {'operator_casing': 'upper'};
PRAGMA explain_output='optimized_only';
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0=5 AND col1 >= col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0>5 AND col1 >= col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0>=5 AND col1 >= col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0=5 AND col1 > col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0>5 AND col1 > col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0>=5 AND col1 > col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0=5 AND col1 <= col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0<5 AND col1 <= col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0<=5 AND col1 <= col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0=5 AND col1 < col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0<5 AND col1 < col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col0<=5 AND col1 < col0;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 >= col0 AND col0=5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 >= col0 AND col0>5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 >= col0 AND col0>=5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 > col0 AND col0=5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 > col0 AND col0>5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 > col0 AND col0>=5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 <= col0 AND col0=5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 <= col0 AND col0<5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 <= col0 AND col0<=5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 < col0 AND col0=5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 < col0 AND col0<5;
EXPLAIN SELECT * FROM (VALUES(5,5)) tbl(col0, col1) WHERE col1 < col0 AND col0<=5;
EXPLAIN SELECT * FROM (VALUES(1),(2),(3)) tbl(a) WHERE a > 1 AND NOT (a > 1);
