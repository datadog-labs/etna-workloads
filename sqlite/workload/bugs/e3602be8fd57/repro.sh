#!/bin/bash
# Needs gcc and the SQLite headers: SQLITE_INC=<built 3.54.1 tree>/src
SRC=${SQLITE_INC:?set SQLITE_INC to a built SQLite 3.54.1 tree's src/ directory}
cat > ext.c <<'EOC'
#include "sqlite3ext.h"
SQLITE_EXTENSION_INIT1
static void nl(sqlite3_context*c,int n,sqlite3_value**v){sqlite3_result_int(c,1);}
int sqlite3_ext_init(sqlite3*db,char**e,const sqlite3_api_routines*api){
  SQLITE_EXTENSION_INIT2(api);
  sqlite3_create_function(db,"like",-1,SQLITE_UTF8,0,nl,0,0);
  return 0;}
EOC
gcc -shared -fPIC -I"$SRC" -I"$SRC/.." -o ext.so ext.c || exit 1
"$SQLITE3" -batch -init /dev/null :memory: <<'EOS' 2>&1
PRAGMA case_sensitive_like=off;
CREATE TABLE t8(x);
INSERT INTO t8 VALUES('abcdef'),('ghijkl'),('mnopqr');
.load ./ext
SELECT 1, x FROM t8 WHERE x LIKE '%h%';
SELECT 2, x FROM t8 WHERE x LIKE '%h%' ESCAPE 'x';
EOS
echo "exit=$?"
