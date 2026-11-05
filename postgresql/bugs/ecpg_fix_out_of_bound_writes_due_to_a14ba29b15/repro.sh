set -e
P=$(dirname "$(command -v ecpg)")/..
T=$PWD/repro_tmp; rm -rf $T; mkdir $T; cd $T
cat > t.pgc <<'X'
#include <stdio.h>
#include <stdlib.h>
EXEC SQL INCLUDE sqlca;
EXEC SQL BEGIN DECLARE SECTION;
bytea buf[16];
EXEC SQL END DECLARE SECTION;
int main(void){
  EXEC SQL CONNECT TO postgres;
  EXEC SQL select '' :: text into :buf;
  printf("empty: %ld\n", (long)sqlca.sqlcode);
  EXEC SQL select '\\a1234' :: text into :buf;
  printf("bad: %ld\n", (long)sqlca.sqlcode);
  EXEC SQL DISCONNECT;
  return 0;
}
X
ecpg -o t.c t.pgc
gcc -I$P/include -o t t.c -L$P/lib -Wl,-rpath,$P/lib -lecpg -lpq
./t 2>&1 || echo "exit $?"
cd ..; rm -rf $T
