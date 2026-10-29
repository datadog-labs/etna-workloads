.limit expr_depth 11
WITH c00 AS (SELECT 1 AS x),
     c1 AS (SELECT x FROM c00),
     c2 AS (SELECT x FROM c1),
     c3 AS (SELECT x FROM c2),
     c4 AS (SELECT x FROM c3),
     c5 AS (SELECT x FROM c4),
     c6 AS (SELECT x FROM c5),
     c7 AS (SELECT x FROM c6),
     c8 AS (SELECT x FROM c7),
     c9 AS (SELECT x FROM c8),
     c10 AS (SELECT x FROM c9)
SELECT x FROM c10;
