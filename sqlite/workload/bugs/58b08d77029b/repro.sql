CREATE TABLE t1(x);
SELECT min(x) OVER w1 FROM t1 WINDOW w1 AS (PARTITION BY geopoly_group_bbox(x) OVER w1);
