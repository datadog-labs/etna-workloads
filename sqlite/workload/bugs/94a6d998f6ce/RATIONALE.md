# Rationale

## Changed: `minmaxStep` in tree/src/func.c
Reverses the `minmaxStep` hunk of fix.patch. The pre-fix code returned early on a NULL
argument, before fetching the aggregate context and without calling
`sqlite3SkipAccumulatorLoad()`. The fixed code (still present in 3.54.1) skips the
accumulator load when the current best is set and the new value is NULL. I restored the
early `return`. The code is equivalent to the original (the variable is `pArg` today).

Effect: in `SELECT p, max(q) FROM t1`, a row with q NULL is no longer skipped, so the bare
column `p` is loaded from that NULL row instead of the row holding the min or max.

The `ALWAYS(pRes->flags)` hunk in `minMaxFinalize` was not touched. It is an assert-style
hint, and 3.54.1 has since been restructured into `minMaxValueFinalize`.

## Oracle failures
minmax4-1.11 and minmax4-1.12 fail. After `INSERT INTO t1 VALUES(7,NULL)`, `SELECT p, max(q)`
and `SELECT p, min(q)` return p=7 instead of the expected 3 and 5.
