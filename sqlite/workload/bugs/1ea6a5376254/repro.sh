"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size = 1024;
PRAGMA auto_vacuum = 0;
PRAGMA synchronous = NORMAL;
PRAGMA journal_mode = WAL;
PRAGMA cache_size = 1;
CREATE TABLE t1 (i INTEGER PRIMARY KEY, b BLOB, t TEXT);
PRAGMA wal_checkpoint;
INSERT INTO t1 VALUES(1, randomblob(2048), 'one');
SAVEPOINT one;
  INSERT INTO t1 VALUES(2, randomblob(2048), 'two');
  INSERT INTO t1 VALUES(3, randomblob(2048), 'three');
  INSERT INTO t1 VALUES(4, randomblob(2048), 'four');
  INSERT INTO t1 VALUES(5, randomblob(2048), 'five');
  INSERT INTO t1 VALUES(6, randomblob(2048), 'six');
  INSERT INTO t1 VALUES(7, randomblob(2048), 'seven');
  UPDATE t1 SET b=randomblob(2048) WHERE i=5;
  UPDATE t1 SET b=randomblob(2048) WHERE i=6;
  UPDATE t1 SET b=randomblob(2048) WHERE i=7;
ROLLBACK TO one;
INSERT INTO t1 VALUES(8, NULL, 'eight');
RELEASE one;
SELECT i, t FROM t1;
.shell cp test.db test2.db
.shell cp test.db-wal test2.db-wal
SQL
"$SQLITE3" -batch -init /dev/null test2.db "SELECT i, t FROM t1"
