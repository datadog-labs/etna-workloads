#!/bin/bash
# Needs gcc and the SQLite source headers (../tree/src relative to the shell's bin/ dir,
# or set SQLITE_SRC). Builds the loadable extension ext/misc/eval.c, whose eval()
# runs SQL on the calling connection, so a CREATE INDEX happens while a SELECT on
# that same connection is still stepping.
SRC=${SQLITE_SRC:-$(dirname "$(readlink -f "$SQLITE3")")/../tree}
gcc -shared -fPIC -I "$SRC/src" -o ./eval.so "$SRC/ext/misc/eval.c" || exit 1
"$SQLITE3" -batch -init /dev/null :memory: <<'EOS'
.load ./eval
CREATE TABLE t1(a INTEGER PRIMARY KEY);
CREATE TABLE t2(d INTEGER PRIMARY KEY,e,f);
INSERT INTO t1(a) VALUES(1),(2),(3),(4);
SELECT a, CASE WHEN a=3 THEN eval('CREATE INDEX t2e ON t2(e)') END
  FROM t1 WHERE NOT EXISTS(SELECT 1 FROM t2 WHERE d=a);
EOS
