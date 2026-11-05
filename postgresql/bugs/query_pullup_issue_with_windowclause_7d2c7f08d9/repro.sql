EXPLAIN (COSTS OFF)
SELECT 1 FROM
  (SELECT ntile(s1.x) OVER () AS c
   FROM (SELECT (SELECT 1) AS x) AS s1) s
WHERE s.c = 1;
SELECT * FROM (SELECT g, row_number() OVER (ORDER BY g) rn FROM generate_series(1,5) g) s WHERE rn < 3;
