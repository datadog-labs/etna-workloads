CREATE TABLE sqliteDemo(a);
INSERT INTO sqliteDemo(a) VALUES(1),(2),(3);
ANALYZE;
SELECT tbl FROM sqlite_stat1 ORDER BY tbl;
