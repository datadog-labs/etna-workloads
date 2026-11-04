CREATE TABLE t AS SELECT with_metadata(column1, 'k', 'v') AS id, with_metadata(column2, 'k', 'v') AS name FROM (VALUES (1, 'a'), (3, 'b'), (NULL, NULL)) AS v;
SELECT name FROM (
  SELECT id, name FROM t
  UNION ALL
  SELECT NULL::int AS id, NULL::string AS name
) GROUP BY name ORDER BY name;
