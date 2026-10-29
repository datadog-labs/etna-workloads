.dbconfig defensive off
CREATE VIRTUAL TABLE ft USING fts5(abc, def);
WITH a(i) AS (
  SELECT 1 UNION ALL SELECT i+1 FROM a WHERE i<1000
)
INSERT INTO ft SELECT 'abc abc abc abc abc abc abc abc abc abc',
    'def def def def def def def def def def' FROM a;
UPDATE ft_data SET block = x'4e20' || substr(block, 3) WHERE id=(
  SELECT id FROM ft_data ORDER BY id LIMIT 1 OFFSET 5
);
SELECT rowid FROM ft('def') ORDER BY rowid DESC LIMIT 1 OFFSET 9999;
