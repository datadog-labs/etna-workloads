D=$(mktemp -d -p "$PWD" XXXXXX)
BIN=$(dirname "$(command -v psql)")
INC=$BIN/../include; LIB=$BIN/../lib
cat > $D/t.pgc <<'X'
#include <stdio.h>
#include <stdlib.h>
#include <pgtypes_numeric.h>
EXEC SQL INCLUDE sqlda.h;
int main() {
  sqlda_t *sqlda = NULL;
  EXEC SQL CONNECT TO postgres;
  EXEC SQL PREPARE stmt1 FROM "SELECT 123::numeric(3,0), 't'::varchar(2)";
  EXEC SQL DECLARE cur1 CURSOR FOR stmt1;
  EXEC SQL OPEN cur1;
  EXEC SQL FETCH NEXT FROM cur1 INTO DESCRIPTOR sqlda;
  for (int i = 0; i < sqlda->sqld; i++) {
    sqlvar_t v = sqlda->sqlvar[i];
    char *d = v.sqldata;
    if (v.sqltype == ECPGt_numeric) d = PGTYPESnumeric_to_asc((numeric*)v.sqldata, -1);
    printf("%s: [%s]\n", v.sqlname.data, d);
  }
  EXEC SQL CLOSE cur1;
  EXEC SQL DISCONNECT ALL;
  return 0;
}
X
cd $D
ecpg -C ORACLE -I"$INC" t.pgc && gcc -I"$INC" t.c -o t -L"$LIB" -Wl,-rpath,"$LIB" -lecpg -lpgtypes -lpq 2>&1 | grep -i error
./t
cd ..; rm -rf "$D"
