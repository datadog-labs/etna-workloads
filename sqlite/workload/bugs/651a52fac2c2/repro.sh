"$SQLITE3" -unsafe-testing -batch -init /dev/null test.db <<'SQL' 2>&1
PRAGMA page_size=1024;
CREATE TABLE t1(a PRIMARY KEY, b);
INSERT INTO t1 VALUES(1, 2);
PRAGMA journal_mode = off;
BEGIN;
INSERT INTO t1 VALUES(3, 4);
INSERT INTO t1 SELECT a+4,b+4 FROM t1;
COMMIT;
BEGIN;
  INSERT INTO t1 VALUES(9, 10);
  SAVEPOINT s1;
    INSERT INTO t1 VALUES(11, 12);
COMMIT;
SELECT * FROM t1;
SQL
echo "exit=$?"
