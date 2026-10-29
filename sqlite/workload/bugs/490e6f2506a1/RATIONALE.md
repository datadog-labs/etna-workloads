# Rationale

## Hunk: src/resolve.c, resolveExprStep (window function branch)
Reverses the fix hunk that wrapped `sqlite3WindowUpdate()` in `if( IN_RENAME_OBJECT==0 )`.
In 3.54.1 the guard sits at the equivalent spot (the call now passes `pSel ? pSel->pWinDefn : 0`,
and is followed by a mallocFailed check). I removed the guard and kept the call and the
mallocFailed check as they were, so `sqlite3WindowUpdate()` runs again during ALTER TABLE RENAME.
That is the pre-fix behaviour. With a window definition that refers to itself
(`WINDOW w1 AS (PARTITION BY b, percent_rank() OVER w1)`), it recurses without end and overflows the stack.

## Oracle
test/altertab3.test case 7.1.2 (the rename of t1 with the self-referential window trigger) crashes
the testfixture. The run is incomplete, so cases 7.x and later are not reached.
This is the stack overflow the fix describes.
