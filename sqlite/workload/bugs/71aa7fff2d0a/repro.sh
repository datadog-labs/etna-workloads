rm -f a.db b.db
"$SQLITE3" -batch -init /dev/null a.db <<'S'
.dbconfig defensive off
PRAGMA journal_mode=OFF;
ATTACH 'b.db' AS b;
PRAGMA b.journal_mode=OFF;
CREATE TABLE t1(x);
CREATE TABLE b.t2(x);
BEGIN;
INSERT INTO t1 VALUES(1);
INSERT INTO t2 VALUES(2);
COMMIT;
SELECT * FROM t1, t2;
S
echo "exit $?"
