# Rationale

Fix hunk (src/wherecode.c): added `bSeekPastNull = 0;` in the `if( pRangeStart )`
branch, so a real lower-bound constraint is not treated as a "seek past NULLs" start.
Left set, `codeApplyAffinity(..., nConstraint - bSeekPastNull, ...)` skips the
affinity on the lower-bound register (e.g. `a>'50'` on an INTEGER column stays text).

In 3.54.1 that reset line existed (2073) but was redundant, because
`bSeekPastNull` was only set when `pRangeStart==0`. Two changes in
src/wherecode.c (sqlite3WhereCodeOneLoopStart) restore the pre-fix state:
1. Deleted `bSeekPastNull = 0;` in the `pRangeStart` branch (the fix hunk reversed).
2. Replaced the guard `if( pRangeStart==0 ){...bSeekPastNull = 1}` (inside the
   TOP_LIMIT block) with an unconditional-on-pRangeStart one, taken when
   BTM_LIMIT or TOP_LIMIT is present. This is the "other path" that now also
   prevented the bug, and is needed to put the flag and a range start together.

Oracle: minmax-14.2 fails (`SELECT min(a) FROM t14 WHERE b='2' AND a>'50'` with
index t14ba(b,a) returns empty instead of 100), as the fix's test guards against.
