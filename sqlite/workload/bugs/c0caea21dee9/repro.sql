PRAGMA page_size=1024;
CREATE VIRTUAL TABLE x3 USING fts4;
INSERT INTO x3(docid,content) VALUES(8,'men wiped out city strongholds'),(7,'that is the most effective tactic'),(6,'trusting in your strength'),(5,'any man whose chariot'),(4,'and dont lag behind'),(3,'trusting in your strength and horsemanship'),(2,'dont any of you charge'),(1,'in your eagerness');
DELETE FROM x3 WHERE docid=7;
DELETE FROM x3 WHERE docid=8;
INSERT INTO x3(x3) VALUES('merge=500,10');
SELECT level, idx, end_block, length(root) FROM x3_segdir;
SELECT count(*) FROM x3_segdir;
