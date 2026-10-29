.dbconfig defensive off
PRAGMA page_size=1024;
CREATE TABLE t1(words);
WITH c(i) AS (SELECT 1 UNION ALL SELECT i+1 FROM c WHERE i<300)
INSERT INTO t1 SELECT 'w'||i||' x'||(i*7%101)||' y'||(i*13%53)||' z'||(i*31%17)||' common text here' FROM c;
CREATE VIRTUAL TABLE x6 USING fts4;
INSERT INTO x6 SELECT words FROM t1;
INSERT INTO x6 SELECT words FROM t1;
INSERT INTO x6 SELECT words FROM t1;
INSERT INTO x6 SELECT words FROM t1;
INSERT INTO x6 SELECT words FROM t1;
INSERT INTO x6 SELECT words FROM t1;
INSERT INTO x6(x6) VALUES('merge=25,4');
UPDATE x6_segdir SET end_block = CAST(end_block AS INTEGER) WHERE level=1;
INSERT INTO x6(x6) VALUES('merge=25,4');
INSERT INTO x6(x6) VALUES('merge=2500,4');
INSERT INTO x6(x6) VALUES('merge=2500,2');
SELECT level, idx, end_block FROM x6_segdir;
