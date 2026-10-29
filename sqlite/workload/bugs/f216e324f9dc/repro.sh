"$SQLITE3" -batch -init /dev/null test.db <<'S'
PRAGMA auto_vacuum=0;
PRAGMA page_size=512;
CREATE TABLE t1(a INTEGER PRIMARY KEY, b);
WITH s(a, b) AS (
  SELECT 2, 'abcdefghij'
  UNION ALL
  SELECT a+2, b FROM s WHERE a < 40
)
INSERT INTO t1 SELECT * FROM s;
S
printf '\x00\x54' | dd of=test.db bs=1 seek=515 conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db <<'S'
INSERT INTO t1 VALUES(5, 'klmnopqrst');
INSERT INTO t1 VALUES(7, 'klmnopqrst');
S
"$SQLITE3" -batch -init /dev/null test.db <<'S'
INSERT INTO t1 VALUES(9, 'klmnopqrst');
S
echo "exit=$?"
