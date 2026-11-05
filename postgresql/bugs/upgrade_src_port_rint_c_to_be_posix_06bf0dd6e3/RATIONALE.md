# Rationale

In REL_18_6, src/port/rint.c no longer exists, because rint() comes from libc. The fix's single hunk rewrote `rint()` in src/port/rint.c from the naive version to a POSIX-compliant one. The only way to bring the bug back is to re-introduce the naive implementation.

## Changed hunk
- File: `src/include/port.h`. There is no function change; the hunk adds `pg_naive_rint()` and a `#define rint(x)` that overrides libc's `rint`.
- Traces to: the fix.patch hunk in `src/port/rint.c` `rint()`. The removed line was `return (x >= 0.0) ? floor(x + 0.5) : ceil(x - 0.5);`, and the hunk restores exactly that line.
- Why it brings the bug back: the naive formula rounds halfway cases away from zero instead of to the nearest even. It also mishandles NaN, signed zero, and values near ±0.5. Float-to-int casts (`dtoi2`, `dtoi4`, `dtoi8`) call `rint()`, so for example `2.5` becomes 3 instead of 2.

## Failing oracle cases
- src/test/regress||int2
- src/test/regress||int4
- src/test/regress||int8
