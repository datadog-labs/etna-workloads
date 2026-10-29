CREATE VIRTUAL TABLE vt0 USING fts5(c0);
INSERT INTO vt0(c0) VALUES ('xyz');
BEGIN;
  INSERT INTO vt0(vt0) VALUES('rebuild');
  INSERT INTO vt0(vt0) VALUES('rebuild');
COMMIT;
INSERT INTO vt0(vt0) VALUES('integrity-check');
