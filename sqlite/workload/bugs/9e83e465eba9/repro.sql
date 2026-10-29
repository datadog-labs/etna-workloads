.dbconfig defensive off
PRAGMA page_size=1024;
CREATE VIRTUAL TABLE x USING fts4;
WITH c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<400)
INSERT INTO x SELECT 'word'||i||' alpha'||(i%37)||' beta'||(i*7%101)||' gamma'||(i*13%53) FROM c;
INSERT INTO x(x) VALUES('optimize');
UPDATE x_segdir SET level=2, end_block = CAST(substr(end_block,1,instr(end_block,' ')-1) AS INTEGER);
WITH c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<150)
INSERT INTO x SELECT 'w'||i||' alpha'||(i%37)||' beta'||(i*7%101) FROM c;
SELECT level, idx, end_block FROM x_segdir;
