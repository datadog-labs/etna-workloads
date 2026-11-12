.mode list
.nullvalue NULL
SELECT 
	i,
	(i * 29) % 11 AS outside,
	i // 2 AS inside,
	cume_dist(ORDER BY inside DESC) OVER w AS cd,
FROM range(10) tbl(i)
WINDOW w AS (
	ORDER BY outside
)
ORDER BY inside DESC, i;
SELECT 
	i,
	i // 2 AS inside,
	cume_dist(ORDER BY i // 2) OVER w AS cd,
FROM range(10) tbl(i)
WINDOW w AS (
	ORDER BY i // 2
	ROWS BETWEEN 3 PRECEDING AND 3 FOLLOWING
)
ORDER BY 1;
WITH t(id) AS (
  VALUES (1), (2), (3)
)
SELECT
  id,
  CUME_DIST(ORDER BY id) OVER (
    ORDER BY id
    ROWS BETWEEN 2 FOLLOWING AND 2 FOLLOWING
  ) AS actual,
  0.0 AS expected
FROM t
ORDER BY id;
SELECT
	id,
	k,
	cume_dist(ORDER BY k) OVER w AS cd,
FROM (VALUES (1, 1), (2, 1), (3, 2)) tbl(id, k)
WINDOW w AS (
	ORDER BY k, id
	ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
)
ORDER BY id;
