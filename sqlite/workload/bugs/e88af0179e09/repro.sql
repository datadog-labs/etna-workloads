CREATE VIRTUAL TABLE vt0 USING fts4(c0, languageid="lid");
INSERT INTO vt0 VALUES ('a'), ('b');
BEGIN;
UPDATE vt0 SET lid = 1 WHERE lid=0;
INSERT INTO vt0(vt0) VALUES('integrity-check');
COMMIT;
INSERT INTO vt0(vt0) VALUES('integrity-check');
