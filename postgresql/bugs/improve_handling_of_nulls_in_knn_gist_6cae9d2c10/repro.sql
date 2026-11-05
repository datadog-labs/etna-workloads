CREATE TABLE t(p point);
INSERT INTO t SELECT point(i, i*2) FROM generate_series(1,2000) i;
CREATE INDEX ON t USING spgist(p kd_point_ops);
SET enable_seqscan=off; SET enable_bitmapscan=off;
SELECT (SELECT p FROM t ORDER BY p <-> pt LIMIT 1)
FROM (VALUES (point '1,2'), (NULL), ('1234,5678')) pts(pt);
