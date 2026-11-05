D=$PWD/ecpgtmp
rm -rf $D
mkdir -p $D && cd $D
P=$(dirname $(command -v ecpg))/..
INC=$P/include
LIB=$P/lib
cat > t.pgc <<'X'
#include <stdio.h>
#include <stdlib.h>
#include <pgtypes_numeric.h>
EXEC SQL INCLUDE sqlda.h;
EXEC SQL INCLUDE sqlda-native.h;
sqlda_t *outp;
int main(void)
{
	int i;
	EXEC SQL CONNECT TO postgres;
	EXEC SQL DECLARE c CURSOR FOR SELECT 0.001234::numeric, 0.0::numeric, 1.0::numeric, 0.5::numeric;
	EXEC SQL OPEN c;
	EXEC SQL FETCH 1 FROM c INTO DESCRIPTOR outp;
	for (i = 0; i < outp->sqld; i++)
		printf("%s\n", PGTYPESnumeric_to_asc((numeric *) outp->sqlvar[i].sqldata, -1));
	EXEC SQL CLOSE c;
	EXEC SQL DISCONNECT;
	return 0;
}
X
ecpg -I$INC/ecpg t.pgc 2>&1
gcc -I$INC -I$INC/ecpg t.c -o t -L$LIB -lecpg -lpgtypes -lpq -Wl,-rpath,$LIB 2>&1 | head
./t 2>&1
cd ..
rm -rf $D
