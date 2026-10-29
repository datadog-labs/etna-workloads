"$SQLITE3" -batch -init /dev/null src.db <<'EOF'
.dbconfig defensive off
CREATE TABLE t1(a INTEGER);
INSERT INTO t1 VALUES('abc');
PRAGMA writable_schema=ON;
UPDATE sqlite_schema SET sql='CREATE TABLE t1(a INTEGER) STRICT';
EOF
"$SQLITE3" -batch -init /dev/null src.db ".clone dst.db" 2>&1
