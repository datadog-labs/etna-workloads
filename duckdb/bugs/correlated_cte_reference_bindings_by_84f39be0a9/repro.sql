.mode list
.nullvalue NULL
SET threads=1;
PRAGMA enable_optimizer;
SELECT *
FROM (SELECT {x: 1} AS a, {y: 3} AS b) seed,
LATERAL (
    WITH RECURSIVE t(n) USING KEY (n) AS (
        SELECT a.x
        UNION ALL
        SELECT n + 1 FROM t
        WHERE n < b.y
          AND NOT EXISTS (SELECT 1 FROM recurring.t r WHERE r.n = b.y)
    )
    SELECT * FROM t
) q
ORDER BY n;
SELECT *
FROM (SELECT {y: 3} AS b, {x: 1} AS a) seed,
LATERAL (
    WITH RECURSIVE t(n) USING KEY (n) AS (
        SELECT a.x
        UNION ALL
        SELECT n + 1 FROM t
        WHERE n < b.y
          AND NOT EXISTS (SELECT 1 FROM recurring.t r WHERE r.n = b.y)
    )
    SELECT * FROM t
) q
ORDER BY n;
SELECT a.x, b.x, n
FROM (
    SELECT {x: lo} AS a, {x: hi} AS b
    FROM (VALUES (1, 3), (2, 4), (1, 3), (NULL, 3), (1, NULL)) bounds(lo, hi)
) seed,
LATERAL (
    WITH RECURSIVE t(n) USING KEY (n) AS (
        SELECT a.x
        UNION ALL
        SELECT n + 1 FROM t
        WHERE n < b.x
          AND NOT EXISTS (SELECT 1 FROM recurring.t r WHERE r.n = b.x)
    )
    SELECT * FROM t
) q;
SELECT *
FROM (SELECT {x: 1} AS a, {y: 3} AS b) seed,
LATERAL (
    WITH RECURSIVE t(n) AS (
        SELECT a.x
        UNION ALL
        SELECT n + 1 FROM t
        WHERE n < b.y
          AND NOT EXISTS (SELECT 1 FROM t r WHERE r.n = b.y)
    )
    SELECT * FROM t
) q
ORDER BY n;
SELECT n
FROM (SELECT {x: 1} AS a, {y: 5} AS b, {z: 3} AS c) seed,
LATERAL (
    WITH RECURSIVE t(n) USING KEY (n) AS (
        SELECT a.x
        UNION ALL
        SELECT n + 1 FROM t
        WHERE n < b.y
          AND NOT EXISTS (SELECT 1 FROM recurring.t r WHERE r.n = c.z)
    )
    SELECT * FROM t
) q
ORDER BY n;
SELECT n
FROM (SELECT {x: 1} AS a, {y: 3} AS b) seed,
LATERAL (
    WITH RECURSIVE t(n) USING KEY (n) AS (
        SELECT a.x
        UNION ALL
        SELECT n + 1 FROM t
        WHERE n < b.y
          AND NOT EXISTS (SELECT 1 FROM recurring.t r WHERE r.n = b.y AND r.n = t.n)
    )
    SELECT * FROM t
) q
ORDER BY n;
PRAGMA disable_optimizer;
SELECT *
FROM (SELECT {x: 1} AS a, {y: 3} AS b) seed,
LATERAL (
    WITH RECURSIVE t(n) USING KEY (n) AS (
        SELECT a.x
        UNION ALL
        SELECT n + 1 FROM t
        WHERE n < b.y
          AND NOT EXISTS (SELECT 1 FROM recurring.t r WHERE r.n = b.y)
    )
    SELECT * FROM t
) q
ORDER BY n;
