# Rationale

Fix (CVS 6137): in `isLikeOrGlob`, the "prefix ends in 0xff" guard was
`255==(u8)z[cnt]` (tests the wildcard/NUL after the prefix, so never true);
the fix changed it to `z[cnt-1]` (last prefix byte).

In 3.54.1 the same logic is in `src/whereexpr.c` `isLikeOrGlob`. Changes:

1. Line ~254: `ALWAYS(255!=(u8)z[cnt-1])` -> `ALWAYS(255!=(u8)z[cnt])`.
   Reverses the fix hunk `z[cnt]` -> `z[cnt-1]` directly: the guard checks the
   wrong byte again.
2. Lines ~233/235 (the prefix-counting loop): 0xff is no longer treated as a
   terminator (`c>=0x80 && c!=0xff`, removed `c==0xff ||`). This is the second
   path that later code added to cover the same case (it stops the prefix before
   a 0xff byte, making the final guard redundant, hence `ALWAYS`). It must be
   reverted too, or the bug can't be reached.

Result: a LIKE pattern like `'\xff%'` is optimized with a prefix ending in 0xff,
so the upper bound can't be computed by incrementing the last byte.

## Oracle failures
test/like.test like-9.4.1 (`LIKE '%ff%25'`, i.e. pattern "\xff%"): crashes with
`Assertion `*pC!=0xFF' failed` in exprAnalyze (the upper-bound increment).
Later cases (9.4.2, 9.4.3, 9.5.x) don't run after the crash.
