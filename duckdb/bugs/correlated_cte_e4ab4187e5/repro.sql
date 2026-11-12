.mode list
.nullvalue NULL
CREATE TABLE inputs(id INTEGER, xs INTEGER[], ys INTEGER[]);
INSERT INTO inputs VALUES
    (1, [1, 2, NULL], [1]),
    (2, [1, 2, NULL], [2]),
    (3, [1, 2, NULL], []),
    (4, [1, 2, NULL], [NULL]),
    (5, [1, 2, NULL], [1, NULL]),
    (6, [], [1]),
    (7, [1, 1, 2], [1]),
    (8, [NULL], []),
    (9, [1, 2, NULL], NULL),
    (10, [1, 2, NULL], [1]);
SET enable_optimizer=true;
SET delim_join_as_cte=true;
SELECT needle, (
    WITH a AS (SELECT unnest(v.xs) AS x),
         b AS (SELECT v.needle AS x)
    SELECT list(x ORDER BY x) FROM a WHERE x IN (SELECT x FROM b)
) AS found
FROM (VALUES ([1, 2], 1), ([1, 2], 2)) v(xs, needle)
ORDER BY needle;
SELECT n, (
    WITH a AS (SELECT unnest(string_split(v.t, ' ')) AS w),
         b AS (SELECT unnest(string_split(v.q, ' ')) AS w)
    SELECT list(w ORDER BY w) FROM a WHERE w IN (SELECT w FROM b)
) AS found
FROM (VALUES (1, 'alpha beta gamma', 'alpha'),
             (2, 'beta gamma delta', 'gamma'),
             (3, 'delta alpha beta', 'delta')) v(n, t, q)
ORDER BY n;
SELECT id, (
    WITH a AS MATERIALIZED (SELECT unnest(v.xs) AS x),
         b AS MATERIALIZED (SELECT unnest(v.ys) AS y)
    SELECT [list(x IN (SELECT y FROM b) ORDER BY x NULLS LAST),
            list(x NOT IN (SELECT y FROM b) ORDER BY x NULLS LAST)]
    FROM a
) AS found
FROM inputs v ORDER BY id;
SELECT id, (
    WITH b AS (SELECT unnest(v.ys) AS y)
    SELECT list(x IN (SELECT y FROM b) ORDER BY x NULLS LAST)
    FROM (VALUES (1), (2), (NULL)) a(x)
) AS found
FROM inputs v ORDER BY id;
SELECT id, (
    WITH a AS NOT MATERIALIZED (SELECT unnest(v.xs) AS x),
         b AS NOT MATERIALIZED (SELECT unnest(v.ys) AS y),
         c AS (SELECT y FROM b UNION ALL SELECT y FROM b)
    SELECT list(x ORDER BY x) FROM a WHERE x IN (SELECT y FROM (SELECT y FROM c))
) AS found
FROM inputs v ORDER BY id;
SET delim_join_as_cte=false;
SELECT needle, (
    WITH a AS (SELECT unnest(v.xs) AS x),
         b AS (SELECT v.needle AS x)
    SELECT list(x ORDER BY x) FROM a WHERE x IN (SELECT x FROM b)
) AS found
FROM (VALUES ([1, 2], 1), ([1, 2], 2)) v(xs, needle)
ORDER BY needle;
SELECT n, (
    WITH a AS (SELECT unnest(string_split(v.t, ' ')) AS w),
         b AS (SELECT unnest(string_split(v.q, ' ')) AS w)
    SELECT list(w ORDER BY w) FROM a WHERE w IN (SELECT w FROM b)
) AS found
FROM (VALUES (1, 'alpha beta gamma', 'alpha'),
             (2, 'beta gamma delta', 'gamma'),
             (3, 'delta alpha beta', 'delta')) v(n, t, q)
ORDER BY n;
SELECT id, (
    WITH a AS MATERIALIZED (SELECT unnest(v.xs) AS x),
         b AS MATERIALIZED (SELECT unnest(v.ys) AS y)
    SELECT [list(x IN (SELECT y FROM b) ORDER BY x NULLS LAST),
            list(x NOT IN (SELECT y FROM b) ORDER BY x NULLS LAST)]
    FROM a
) AS found
FROM inputs v ORDER BY id;
SELECT id, (
    WITH b AS (SELECT unnest(v.ys) AS y)
    SELECT list(x IN (SELECT y FROM b) ORDER BY x NULLS LAST)
    FROM (VALUES (1), (2), (NULL)) a(x)
) AS found
FROM inputs v ORDER BY id;
SELECT id, (
    WITH a AS NOT MATERIALIZED (SELECT unnest(v.xs) AS x),
         b AS NOT MATERIALIZED (SELECT unnest(v.ys) AS y),
         c AS (SELECT y FROM b UNION ALL SELECT y FROM b)
    SELECT list(x ORDER BY x) FROM a WHERE x IN (SELECT y FROM (SELECT y FROM c))
) AS found
FROM inputs v ORDER BY id;
SET enable_optimizer=false;
SET delim_join_as_cte=true;
SELECT needle, (
    WITH a AS (SELECT unnest(v.xs) AS x),
         b AS (SELECT v.needle AS x)
    SELECT list(x ORDER BY x) FROM a WHERE x IN (SELECT x FROM b)
) AS found
FROM (VALUES ([1, 2], 1), ([1, 2], 2)) v(xs, needle)
ORDER BY needle;
SELECT n, (
    WITH a AS (SELECT unnest(string_split(v.t, ' ')) AS w),
         b AS (SELECT unnest(string_split(v.q, ' ')) AS w)
    SELECT list(w ORDER BY w) FROM a WHERE w IN (SELECT w FROM b)
) AS found
FROM (VALUES (1, 'alpha beta gamma', 'alpha'),
             (2, 'beta gamma delta', 'gamma'),
             (3, 'delta alpha beta', 'delta')) v(n, t, q)
ORDER BY n;
SELECT id, (
    WITH a AS MATERIALIZED (SELECT unnest(v.xs) AS x),
         b AS MATERIALIZED (SELECT unnest(v.ys) AS y)
    SELECT [list(x IN (SELECT y FROM b) ORDER BY x NULLS LAST),
            list(x NOT IN (SELECT y FROM b) ORDER BY x NULLS LAST)]
    FROM a
) AS found
FROM inputs v ORDER BY id;
SELECT id, (
    WITH b AS (SELECT unnest(v.ys) AS y)
    SELECT list(x IN (SELECT y FROM b) ORDER BY x NULLS LAST)
    FROM (VALUES (1), (2), (NULL)) a(x)
) AS found
FROM inputs v ORDER BY id;
SELECT id, (
    WITH a AS NOT MATERIALIZED (SELECT unnest(v.xs) AS x),
         b AS NOT MATERIALIZED (SELECT unnest(v.ys) AS y),
         c AS (SELECT y FROM b UNION ALL SELECT y FROM b)
    SELECT list(x ORDER BY x) FROM a WHERE x IN (SELECT y FROM (SELECT y FROM c))
) AS found
FROM inputs v ORDER BY id;
SET delim_join_as_cte=false;
SELECT needle, (
    WITH a AS (SELECT unnest(v.xs) AS x),
         b AS (SELECT v.needle AS x)
    SELECT list(x ORDER BY x) FROM a WHERE x IN (SELECT x FROM b)
) AS found
FROM (VALUES ([1, 2], 1), ([1, 2], 2)) v(xs, needle)
ORDER BY needle;
