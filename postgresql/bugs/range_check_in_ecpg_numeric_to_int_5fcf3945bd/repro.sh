D=$(dirname "$(dirname "$(command -v psql)")")
mkdir -p rt_tmp
cat > rt_tmp/t.c <<'C'
#include <stdio.h>
#include <stdlib.h>
#include <pgtypes_numeric.h>
int main(void){
  int i = 0;
  numeric *n = PGTYPESnumeric_from_asc("-2147483648", NULL);
  int r = PGTYPESnumeric_to_int(n, &i);
  printf("rc=%d min=%d\n", r, i);
  return 0;
}
C
gcc -I"$D/include" -o rt_tmp/t rt_tmp/t.c -L"$D/lib" -lpgtypes -Wl,-rpath,"$D/lib" && ./rt_tmp/t
rm -rf rt_tmp
