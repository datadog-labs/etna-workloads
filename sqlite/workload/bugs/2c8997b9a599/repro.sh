# Count fsync/fdatasync calls (via LD_PRELOAD) during a multi-db commit
# with PRAGMA synchronous=OFF on every database.
cat > shim.c <<'EOC'
#define _GNU_SOURCE
#include <unistd.h>
#include <stdio.h>
static int n;
int fsync(int fd){ n++; return 0; }
int fdatasync(int fd){ n++; return 0; }
__attribute__((destructor)) static void fin(void){ fprintf(stderr,"syncs=%d\n",n); }
EOC
gcc -shared -fPIC -o shim.so shim.c || exit 1
cat > setup.sql <<'EOS'
CREATE TABLE t1(a,b);
ATTACH 'test2.db' AS db2;
CREATE TABLE db2.t2(x,y);
EOS
"$SQLITE3" -batch -init /dev/null test.db < setup.sql
LD_PRELOAD=$PWD/shim.so "$SQLITE3" -batch -init /dev/null test.db <<'EOS'
ATTACH 'test2.db' AS db2;
PRAGMA main.synchronous=off;
PRAGMA db2.synchronous=off;
BEGIN;
INSERT INTO t1 VALUES(5,6);
INSERT INTO t2 VALUES(7,8);
COMMIT;
EOS
