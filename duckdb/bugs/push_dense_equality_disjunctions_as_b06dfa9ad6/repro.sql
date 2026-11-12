.mode list
.nullvalue NULL
CREATE TABLE dense_or AS SELECT i::INTEGER AS x FROM range(-4, 9) t(i);
INSERT INTO dense_or VALUES (NULL);
SELECT x FROM dense_or WHERE x = 2 OR -1 = x OR x = 1 OR x = 0 ORDER BY x;
EXPLAIN (FORMAT JSON) SELECT x FROM dense_or WHERE x BETWEEN 0 AND 3 AND (x = 1 OR x = 2);
