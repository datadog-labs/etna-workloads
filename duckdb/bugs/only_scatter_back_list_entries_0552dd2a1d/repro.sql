.mode list
.nullvalue NULL
CREATE TABLE t(l INTEGER[]);
INSERT INTO t VALUES ([1, NULL]), ([1, 2]), ([1, NULL, 3]);
SELECT l, l IS NOT DISTINCT FROM [1, NULL, 3] FROM t;
