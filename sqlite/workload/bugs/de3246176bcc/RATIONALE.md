# Rationale

Fix hunks: (1) vdbe.c OP_SeekGT/SeekGE: compare via `sqlite3IntFloatCompare(iKey, r)` instead of `(double)iKey`; (2)/(3) make that function non-static and declare it in vdbeInt.h (visibility only, nothing to revert: the function is still used by vdbeaux.c).

Change made (src/vdbe.c, OP_SeekGT block): removed `int c` and the `c = sqlite3IntFloatCompare(iKey, pIn3->u.r)` call; restored the pre-fix `}else` and the comparisons `pIn3->u.r<(double)iKey` / `pIn3->u.r>(double)iKey` in place of `c>0` / `c<0`. Converting iKey to double loses precision near 2^63, so the seek direction adjustment is wrong.

Oracle: where-27.1 fails (`a>=(9223372036854775807+1)` returns a row, expected none): iKey=2^63-1 converts to 2^63 == r, so no adjustment and the seek lands on the max rowid.
