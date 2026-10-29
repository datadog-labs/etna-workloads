CREATE VIRTUAL TABLE fts USING fts4 (t);
BEGIN;
INSERT INTO fts (rowid, t) VALUES (2, 'test');
INSERT INTO fts (fts) VALUES ('optimize');
COMMIT;
SELECT level, idx FROM fts_segdir;
SELECT rowid FROM fts WHERE fts MATCH 'test';
INSERT INTO fts(fts) VALUES('integrity-check');
