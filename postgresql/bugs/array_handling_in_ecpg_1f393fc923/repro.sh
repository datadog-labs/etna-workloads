B=$(dirname "$(command -v ecpg)")
mkdir -p t.$$ && cd t.$$
cat > a.pgc <<'X'
#include <stdio.h>
EXEC SQL INCLUDE sqlca;
int main(void){
  EXEC SQL BEGIN DECLARE SECTION;
  int a[3] = {1,2,3};
  char r[100];
  EXEC SQL END DECLARE SECTION;
  EXEC SQL CONNECT TO postgres;
  EXEC SQL CREATE TEMP TABLE t(a int[]);
  EXEC SQL INSERT INTO t VALUES (:a);
  printf("insert sqlcode=%d\n", (int)sqlca.sqlcode);
  EXEC SQL SELECT a::text INTO :r FROM t;
  printf("sqlcode=%d r=%s\n", (int)sqlca.sqlcode, sqlca.sqlcode?"":r);
  EXEC SQL DISCONNECT;
  return 0;
}
X
ecpg a.pgc || exit 1
INC=$B/../include; LIB=$B/../lib
gcc -I"$INC" a.c -o a -L"$LIB" -Wl,-rpath,"$LIB" -lecpg -lpgtypes -lpq 2>&1 | grep -i error
./a
cd ..; rm -rf t.$$
