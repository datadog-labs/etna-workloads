"$SQLITE3" -batch -init /dev/null test.db <<'SQL'
PRAGMA page_size=1024;
CREATE TABLE t1(a INTEGER PRIMARY KEY, b TEXT);
WITH c(i) AS (SELECT 0 UNION ALL SELECT i+1 FROM c WHERE i<9)
INSERT INTO t1 SELECT i, substr(replace(hex(zeroblob(110)),'00',i),1,220) FROM c;
CREATE INDEX i1 ON t1(b);
SQL
root=$("$SQLITE3" test.db "SELECT rootpage FROM sqlite_master WHERE name='i1'")
base=$(( (root-1)*1024 ))
off=$(od -An -tu1 -j $((base+12)) -N2 test.db | awk '{print $1*256+$2}')
printf "$(printf '\\x%02x\\x%02x\\x%02x\\x%02x' 0 0 0 $((root-1)))" |
  dd of=test.db bs=1 seek=$((base+off)) conv=notrunc 2>/dev/null
"$SQLITE3" -batch -init /dev/null test.db "DELETE FROM t1 WHERE rowid=3;" 2>&1
echo "exit=$?"
