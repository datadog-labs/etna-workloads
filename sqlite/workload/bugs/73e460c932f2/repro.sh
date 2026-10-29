#!/bin/bash
# Reader holds a read txn; writer creates fts5 table, COMMIT fails (locked),
# then SAVEPOINT on the writer after the failed commit.
rm -f test.db
"$SQLITE3" -batch -init /dev/null test.db "CREATE TABLE t1(a,b);" 
( echo "BEGIN; SELECT * FROM t1;"; sleep 3 ) | "$SQLITE3" -batch -init /dev/null test.db >/dev/null 2>&1 &
sleep 1
"$SQLITE3" -batch -init /dev/null test.db <<'SQL' 2>&1
.timeout 0
BEGIN;
CREATE VIRTUAL TABLE x1 USING fts5(y);
COMMIT;
SAVEPOINT one;
SQL
echo "exit=$?"
wait
