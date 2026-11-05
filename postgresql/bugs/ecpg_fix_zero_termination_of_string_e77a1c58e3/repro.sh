B=$(dirname "$(command -v psql)")
P=$(dirname "$B")
D=$(mktemp -d)
cat > $D/t.c <<'EOC'
#include <stdio.h>
#include <stdlib.h>
#include <ecpg_informix.h>
#include <pgtypes_interval.h>
int main(void){
 char s[100]="aaaaaaaaa_bbbbbbbb_ccccccccc_ddddddddd_";
 interval *i=malloc(sizeof(interval));
 i->time=100000000; i->month=240;
 intoasc(i,s);
 printf("after: %s\n",s);
 return 0;}
EOC
gcc -I$P/include -o $D/t $D/t.c -L$P/lib -lecpg_compat -lecpg -lpgtypes -Wl,-rpath,$P/lib 2>&1
$D/t
rm -rf $D
