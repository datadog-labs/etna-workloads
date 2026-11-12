.mode list
.nullvalue NULL
SET late_materialization_max_rows = 100;
CREATE TABLE lm_pushdown_extract (
    id INTEGER,
    s STRUCT(a INTEGER, b VARCHAR),
    x INTEGER
);
INSERT INTO lm_pushdown_extract VALUES (1, {'a': 1, 'b': NULL}, 10), (2, {'a': 2, 'b': 'y'}, 20);
SELECT s, x FROM lm_pushdown_extract WHERE s.a = 1 ORDER BY id LIMIT 1;
SET disabled_optimizers = 'LATE_MATERIALIZATION';
SELECT s, x FROM lm_pushdown_extract WHERE s.a = 1 ORDER BY id LIMIT 1;
SET disabled_optimizers = '';
PRAGMA explain_output = OPTIMIZED_ONLY;
EXPLAIN SELECT s, x FROM lm_pushdown_extract WHERE s.a = 1 ORDER BY id LIMIT 1;
PRAGMA explain_output = PHYSICAL_ONLY;
CREATE TABLE pushdown_extract_multi (
    s STRUCT(a INTEGER, b INTEGER),
    x INTEGER
);
INSERT INTO pushdown_extract_multi VALUES (row(1, 11), 10), (row(2, 22), 20);
SELECT x FROM pushdown_extract_multi WHERE s.a + s.b = 12;
