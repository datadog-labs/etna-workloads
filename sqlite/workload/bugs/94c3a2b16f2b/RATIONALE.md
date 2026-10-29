# Rationale

Fix hunk reversed: `src/vdbemem.c` `sqlite3VdbeIntegerAffinity` (fix added `(pMem->u.i-1) < (pMem->u.i+1)` to exclude the largest/smallest int64, ticket #3922).
In 3.54.1 the equivalent guard is `ix>SMALLEST_INT64 && ix<LARGEST_INT64`; I removed it, so the condition is back to the pre-fix `pMem->u.r==ix`. Because `sqlite3RealToI64` clamps, reals >= 2^63 or <= -2^63 round-trip exactly to the extreme ints and are wrongly marked MEM_Int.

The `compare2pow63` hunk in util.c (`*10`) was not touched; it is a separate, already-present mechanism.

Oracle failures (test/tkt3922.test): tkt3922.2 and .3 (-9223372036854775809, -9223372036854776832 become integer -9223372036854775808 instead of real) and tkt3922.6 (9223372036854775808 becomes integer 9223372036854775807 instead of real).
