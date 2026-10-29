"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
CREATE VIRTUAL TABLE t1 USING fts5(content);
INSERT INTO t1(t1,rank) VALUES('secure-delete',1);
INSERT INTO t1 VALUES('active'),('boomer'),('atom'),('atomic'),
       ('alpha channel backup abandon test aback boomer atom alpha active');
DELETE FROM t1 WHERE t1 MATCH 'abandon';
INSERT INTO t1(t1) VALUES('rebuild');
DELETE FROM t1 WHERE rowid NOTNULL<5;
SQL
"$SQLITE3" -batch -init /dev/null test.db "PRAGMA integrity_check;"
