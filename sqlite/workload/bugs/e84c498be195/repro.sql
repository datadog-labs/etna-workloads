CREATE VIRTUAL TABLE zt USING fts4(a, b);
INSERT INTO zt(rowid, a, b) VALUES(1, 'unus duo', NULL);
INSERT INTO zt(rowid, a, b) VALUES(2, NULL, NULL);
BEGIN;
  UPDATE zt SET b='septum' WHERE rowid = 1;
  UPDATE zt SET b='octo' WHERE rowid = 1;
COMMIT;
SELECT count(*) FROM zt_segdir;
