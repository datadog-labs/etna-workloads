.mode list
.nullvalue NULL
CREATE TABLE t AS SELECT 'ä' AS s, 'aäb' AS s2, '\C' AS p, 'a\C' AS p2;
SELECT regexp_replace('ä', '\C', 'x');
