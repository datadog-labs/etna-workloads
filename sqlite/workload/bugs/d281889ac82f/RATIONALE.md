# Rationale

In 3.54.1 the percentile functions live in `src/func.c` (`ext/misc/percentile.c` is not part of the testfixture build), so the fix's percentile.c hunks are re-expressed there.

## Changes
1. `src/func.c` percentStep, non-numeric Y: replaced `percentError(pCtx, "input to %%s() is not numeric")` with the old hard-coded `sqlite3_result_error(pCtx, "1st argument to percentile() is not numeric", -1)`. This reverses the fix hunk "1st argument to percentile() is not numeric" -> "input to %%s() is not numeric". Error text names `percentile()` even for percentile_cont/percentile_disc/median.
2. `src/func.c` percentStep, infinite Y: replaced `percentError(pCtx, "Inf input to %%s()")` with `sqlite3_result_error(pCtx, "Inf input to percentile()", -1)`. This reverses the fix's `Inf input to percentile()` hunk.
3. `src/parse.y` sqlite3ExprAddOrderedsetFunction: `sqlite3FindFunction(..., -2, ...)` back to `p->nExpr`, reversing the parse.y hunk. With the old nArg, `percentile(50) WITHIN GROUP (ORDER BY x)` looks up a 1-arg function (the registered one takes 2) and wrongly reports "not an ordered-set aggregate". This code is only compiled with SQLITE_ENABLE_ORDERED_SET_AGGREGATES, which the check build does not enable, so no oracle case exercises it.

The percentError helper and the "fraction argument" messages were left alone: the pre-fix inline `sqlite3_mprintf` versions produce the same text.

## Oracle failures
percentile-1.15.1/.2/.3/.4, 1.16 (wrong "not numeric" message), 1.20.2/.3/.4 (wrong "Inf input" function name). 8 failing.
