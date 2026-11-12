.mode list
.nullvalue NULL
CREATE TABLE t(id INTEGER, k INTEGER);
INSERT INTO t VALUES (1, 1), (2, 1), (3, NULL), (4, NULL);
SELECT * FROM t l ASOF JOIN t r ON l.k IS NOT DISTINCT FROM r.k AND l.id >= r.id AND l.id <> r.id ORDER BY ALL;
