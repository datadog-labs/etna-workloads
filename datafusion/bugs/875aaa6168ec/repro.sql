CREATE TABLE t AS VALUES (1),(2);
SELECT arrow_metadata(c, 'k') AS m FROM (SELECT CAST(c1 AS INT) AS c FROM (SELECT with_metadata(column1, 'k', 'v') AS c1 FROM t) ORDER BY 1);
SELECT arrow_metadata(c1, 'k') AS m FROM (SELECT CAST(with_metadata(column1, 'k', 'v') AS INT) AS c1 FROM t);
