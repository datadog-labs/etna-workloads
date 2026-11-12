.mode list
.nullvalue NULL
SET threads=1;
CREATE TABLE d (id INT, j INT, x INT, y INT, z INT, k INT);
INSERT INTO d VALUES (1, 1, 1, 1, NULL, 1), (2, 2, NULL, NULL, 1, 2);
CREATE VIEW v AS SELECT id, j, x, y, z FROM d QUALIFY ROW_NUMBER() OVER (PARTITION BY k) = 1;
SELECT a.id, b.y FROM v a LEFT JOIN v b ON a.j = b.j WHERE a.x IS NOT NULL AND (b.y > 5 OR a.x > 5) IS NULL
UNION ALL SELECT a.id, b.y FROM v a, v b WHERE a.x IS NOT NULL
UNION ALL SELECT a.id, b.y FROM v a, v b WHERE a.x IS NOT NULL
UNION ALL SELECT a.id, b.y FROM v a, v b WHERE a.x IS NOT NULL
UNION ALL SELECT a.id, b.y FROM v a LEFT JOIN v b ON a.j = b.j WHERE a.x IS NOT NULL AND b.z IS NULL;
