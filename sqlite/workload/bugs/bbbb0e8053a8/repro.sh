# Needs gcc and sqlite3ext.h (path via SQLITE_INC, default ../tree/src relative to this script's dir parent).
set -e
INC=${SQLITE_INC:-/home/bits/sqlite-etna-work/repro/bbbb0e8053a8/tree/src}
cat > hook.c <<'EOC'
#include "sqlite3ext.h"
SQLITE_EXTENSION_INIT1
#include <stdio.h>
static void cb(void *p, int op, const char *db, const char *tbl, sqlite3_int64 r){
  printf("hook op=%d %s.%s rowid=%lld\n", op, db, tbl, (long long)r);
}
int sqlite3_hook_init(sqlite3 *db, char **err, const sqlite3_api_routines *api){
  SQLITE_EXTENSION_INIT2(api);
  sqlite3_update_hook(db, cb, 0);
  return SQLITE_OK;
}
EOC
gcc -shared -fPIC -I"$INC" -o hook.so hook.c
"$SQLITE3" -batch -init /dev/null :memory: <<'EOS' 2>&1
.load ./hook sqlite3_hook_init
CREATE TABLE t1w(a INT PRIMARY KEY, b) WITHOUT ROWID;
INSERT INTO t1w VALUES(1,'one'),(2,'two'),(3,'three');
DELETE FROM t1w WHERE b='two';
DELETE FROM t1w WHERE 1;
SELECT 'done';
EOS
