"$SQLITE3" -batch -init /dev/null t.db <<'S' >/dev/null
PRAGMA page_size=1024;
PRAGMA auto_vacuum=1;
CREATE TABLE t1(x);
INSERT INTO t1 VALUES(randomblob(200));
INSERT INTO t1 SELECT randomblob(200) FROM t1;
INSERT INTO t1 SELECT randomblob(200) FROM t1;
INSERT INTO t1 SELECT randomblob(200) FROM t1;
INSERT INTO t1 SELECT randomblob(200) FROM t1;
INSERT INTO t1 SELECT randomblob(200) FROM t1;
S

root=$("$SQLITE3" -batch -init /dev/null t.db "SELECT rootpage FROM sqlite_master;")

# Corrupt the file: make the right-child pointer of the table's root page
# (a B-Tree interior page) refer to the root page itself, creating a loop
# in the B-Tree structure.
python3 -I - "$root" <<'PY'
import sys
root = int(sys.argv[1])
with open("t.db", "r+b") as f:
    offset = (root - 1) * 1024
    f.seek(offset + 8)
    f.write(root.to_bytes(4, "big"))
PY

"$SQLITE3" -batch -init /dev/null t.db "SELECT count(*) FROM t1;" 2>&1
echo "exit=$?"
