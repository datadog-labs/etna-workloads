D=$(dirname "$(command -v psql)")/..
T=${TMPDIR:-/tmp}/pgt$$
mkdir -p $T
cat > $T/t.c <<'C'
#include <stdio.h>
#include <pgtypes_timestamp.h>
int main(void){
 timestamp ts; char out[64];
 const char *fmt="%a %b %d %H:%M:%S %Y";
 PGTYPEStimestamp_defmt_asc("Mon Nov 25 17:28:44 2019", fmt, &ts);
 PGTYPEStimestamp_fmt_asc(&ts, out, 63, fmt); puts(out);
 PGTYPEStimestamp_fmt_asc(&ts, out, 63, "%B"); puts(out);
 return 0;}
C
gcc -I$D/include -o $T/t $T/t.c -L$D/lib -lpgtypes -Wl,-rpath,$D/lib && $T/t
rm -rf $T
