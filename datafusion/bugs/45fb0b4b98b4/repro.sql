CREATE TABLE t AS SELECT * FROM (VALUES (1,'A','a'),(2,'A','b'),(3,'A','c'),(1,'B','x'),(2,'B','y'),(3,'B','z')) v(id,grp,val);
SELECT id, grp, string_agg(val, ',') OVER (PARTITION BY grp ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS s FROM t ORDER BY grp, id;
SELECT id, grp, percentile_cont(id, 0.5) OVER (PARTITION BY grp ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS p FROM t ORDER BY grp, id;
