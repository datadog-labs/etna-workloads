.mode list
.nullvalue NULL
CREATE TABLE a1 AS SELECT i AS x FROM range(8) s(i);
CREATE TABLE b1 AS SELECT i AS x FROM range(8) s(i);
CREATE TABLE c1 AS SELECT i AS x FROM range(16) s(i);
CREATE TABLE d1 AS SELECT i AS x FROM range(8) s(i);
SELECT count(*) FROM a1, b1, c1 INNER JOIN d1 ON (c1.x > 0);
