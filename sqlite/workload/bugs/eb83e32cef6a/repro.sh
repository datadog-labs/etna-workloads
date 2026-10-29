rm -f test.db
"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
CREATE VIRTUAL TABLE t1 USING fts5(a);
BEGIN;
INSERT INTO t1(rowid, a) VALUES(1, 'aaaa');
INSERT INTO t1(rowid, a) VALUES(2, 'bbbb');
INSERT INTO t1(rowid, a) VALUES(3, 'cccc');
COMMIT;
SQL
off=$(LC_ALL=C grep -obUaP '\x01\x04cccc' test.db | head -1 | cut -d: -f1)
printf '\x01\x7f' | dd of=test.db bs=1 seek=$off conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db <<'SQL' 2>&1
SELECT rowid FROM t1('cccccccccccccccccccccccccccccccccccccccccccccccc');
SQL
echo "exit=$?"
