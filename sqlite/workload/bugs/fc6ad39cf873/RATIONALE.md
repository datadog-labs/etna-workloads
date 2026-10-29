# Ticket #1664: sum() of large integers loses precision

Fix hunk reversed: `SumCtx.sum` changed from `double` to `LONGDOUBLE_TYPE` (more mantissa bits
for summing large integers). The pre-fix code kept the running integer sum in a double, so
integers beyond the mantissa width were rounded. (The `CountCtx.n`/`countFinalize` hunk is
already `i64` in 3.54.1 and is not reintroduced.)

Change: `sumStep()` in src/func.c, non-approximate integer branch. After the exact
`sqlite3AddInt64`, the running sum is rounded through a `double` (`x = (i64)(double)x`),
emulating the old double accumulator. The range guard avoids UB converting values near 2^63.
Modern code accumulates exactly in `iSum`, so this is the equivalent of the old lossy accumulator.

Oracle failure: `func-18.10` (`sum(1, 1<<62) - ((1<<62)+1)`) returns -1 instead of 0,
since 2^62+1 rounds to 2^62. All other tests pass.
