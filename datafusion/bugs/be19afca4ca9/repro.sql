CREATE TABLE t AS SELECT * FROM (VALUES (1,'a'),(2,'b'),(1,'c')) v(id,n);

-- count distinct + cast + group by on a column carrying field metadata
SELECT m::text AS g, count(DISTINCT n) AS dist
FROM (SELECT with_metadata(id,'k','v') AS m, n FROM t)
GROUP BY g ORDER BY 1;

-- metadata preserved through cast
SELECT m::bigint AS c, arrow_metadata(m::bigint,'k') AS md
FROM (SELECT with_metadata(id,'k','v') AS m FROM t)
ORDER BY 1;
