.dbconfig defensive off
CREATE VIRTUAL TABLE o1 USING fts5(a, b, c, detail=full);
INSERT INTO o1(o1, rank) VALUES('pgsz', 32);
WITH s(i) AS ( SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<60 )
INSERT INTO o1 SELECT 'A', 'B', 'C' FROM s;
WITH s(i) AS ( SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<60 )
INSERT INTO o1 SELECT 'C', 'A', 'B' FROM s;
WITH s(i) AS ( SELECT 1 UNION ALL SELECT i+1 FROM s WHERE i<60 )
INSERT INTO o1 SELECT 'B', 'C', 'A' FROM s;
UPDATE o1_data SET block=substr(block,1,length(block)/2) WHERE id=(SELECT id FROM o1_data LIMIT 1 OFFSET 43);
SELECT count(*) FROM o1('{b c}:b AND a:a');
