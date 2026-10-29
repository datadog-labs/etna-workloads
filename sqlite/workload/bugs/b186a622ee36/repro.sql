CREATE VIRTUAL TABLE vt0 USING fts5(a);
PRAGMA reverse_unordered_selects = true;
INSERT INTO vt0 VALUES('365062398'), (0), (0);
INSERT INTO vt0(vt0, rank) VALUES('pgsz', '38');
UPDATE vt0 SET a = 399905135;
INSERT INTO vt0(vt0) VALUES('integrity-check');
INSERT INTO vt0(vt0, rank) VALUES('pgsz', '16');
