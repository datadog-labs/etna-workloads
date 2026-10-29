# Rationale

Fix: "Fix rounding in zero-precision %f and %g printf conversions" (forum 393708f4a8).

## Hunks reversed
1. `src/printf.c` (etGENERIC branch): removed `if( precision==0 ) precision = 1;`
   before `iRound = precision;`. With `%0.0g`, precision stays 0, so iRound=0 is
   handed to sqlite3FpDecode (treated as "round to decimal places") and the later
   `assert( precision>0 )` / `precision--` in the etGENERIC conversion breaks.
2. `src/util.c` sqlite3FpDecode: `if( iRound<=0 )` changed back to `if( iRound<0 )`.
   (Line is at the same place in the rewritten function.) With iRound==0, `%0.0f`
   no longer takes the decimal-place rounding path, so 0.9 is not rounded to 1.

## Oracle failures
test/printf.test: the run asserts at `assert( precision>0 )` in
sqlite3_str_vappendf (printf-2.9.1, a `%.0g`-style case), aborting the file
with many cases unfinished. printf-19.x (`%0.0f`, `%0.0g`) guard the same behaviour.
