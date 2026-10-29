# Rationale

## Change (tree/src/window.c, `windowInitAccum`)

The fix's `src/window.c` hunk added, in `windowInitAccum()`, a block that for
inline min()/max() window functions (`SQLITE_FUNC_MINMAX` with `csrApp`) runs
`OP_ResetSorter` on the ephemeral table `csrApp` and zeroes `regApp+1` (the
uniqueness counter). Without it, a new PARTITION starts with the previous
partition's values still in the min/max ephemeral table, so min()/max() with a
frame start other than UNBOUNDED PRECEDING return values from earlier partitions.

In 3.54.1 the same block exists (with `pWFunc` naming); I removed it, restoring
the pre-fix code. The other fix hunks are comments, opcode docs, or unrelated
refactors (no behavioural bug) and were not touched.

## Oracle failures

`test/window4.test` fails 27 cases (window4-4.5.19.1 ... 4.5.55.1): the
`max(c) OVER (...)`/`min(c) OVER (...)` queries with PARTITION BY and frames
such as `BETWEEN CURRENT ROW AND ...` return wrong results.
`test/window1.test` is unaffected.
