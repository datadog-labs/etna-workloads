D=${TMPDIR:-/tmp}/repro_$$
mkdir -p $D
BIN=$(dirname "$(command -v psql)")
P=$(dirname "$BIN")
cat > $D/t.c <<'EOC'
#include <stdio.h>
#include <ecpg_informix.h>
#include <pgtypes_numeric.h>
#include <pgtypes_error.h>
int main(void)
{
  decimal d; int i=0; long l=0; int r;
  numeric *n = PGTYPESnumeric_from_asc("12345678901234567890123", NULL);
  PGTYPESnumeric_to_decimal(n, &d);
  r = dectoint(&d,&i); printf("dectoint: %d\n", r);
  r = dectolong(&d,&l); printf("dectolong: %d\n", r);
  return 0;
}
EOC
gcc -I$P/include -I$P/include/informix -I$P/include/postgresql/informix $D/t.c -o $D/t -L$P/lib -lecpg_compat -lpgtypes -lecpg -Wl,-rpath,$P/lib 2>&1 | head -5
$D/t
rm -rf $D
