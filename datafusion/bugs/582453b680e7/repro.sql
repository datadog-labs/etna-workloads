create table foo (a int, b int) as values (1, 2), (3, 4), (5, 6), (null, null), (6, null), (null, 7);

SELECT count(endpoint)
FROM (
  SELECT CASE
    WHEN a IS NOT NULL THEN CAST(a AS BIGINT)
    ELSE CAST(0 AS BIGINT)
  END AS endpoint
  FROM foo
);
