CREATE TABLE t (
  a DOUBLE,
  b BIGINT,
  c INT
) AS VALUES
(1.0, 10, -5),
(2.0, 20, -5),
(3.0, 20, 4);

WITH s AS (
    SELECT
        COUNT(a) FILTER (WHERE (b * b) - 3600 <= b),
        COUNT(a) FILTER (WHERE (b * b) - 3000 <= b AND (c >= 0)),
        COUNT(a) FILTER (WHERE (b * b) - 3000 <= b AND (c >= 0) AND (c >= 0))
    FROM t
) SELECT * FROM s;
