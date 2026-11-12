.mode list
.nullvalue NULL
CREATE TABLE range_dimension AS
SELECT i::INTEGER k, (i % 10)::INTEGER grp, (i % 3)::INTEGER v FROM range(10000) r(i);
CREATE TABLE range_fact AS
SELECT (i % 1000)::INTEGER k, (i % 7)::INTEGER v FROM range(100000) r(i);
CHECKPOINT;
ANALYZE range_dimension;
ANALYZE range_fact;
EXPLAIN (FORMAT JSON)
SELECT count(*) FROM range_fact f JOIN range_dimension d USING (k)
WHERE d.grp = 1 AND (d.v = 1 OR f.v IN (SELECT v FROM range_dimension WHERE grp = 2));
