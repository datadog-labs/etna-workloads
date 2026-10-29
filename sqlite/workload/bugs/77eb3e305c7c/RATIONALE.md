# Rationale

Changed `src/printf.c` (~line 645), in the `etFLOAT` branch of `sqlite3_str_vappendf`:
`if( cThousand && e2>0 ) szBufNeeded += (e2+2)/3;` is now `if( cThousand ) szBufNeeded += (e2+2)/3;`.
This reverses the only implementation hunk of the fix. For a very small real value, e2 is negative, so `(e2+2)/3` is negative and the temporary buffer is sized too small. That causes the buffer overrun.

Oracle failure: `printf-18.1` (`format('%,.249f', -5.0e-300)`) hits the assertion `length <= szBufNeeded` in `sqlite3_str_vappendf`. The other oracle cases still pass.
