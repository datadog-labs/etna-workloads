# Rationale

Fix 557c69055a (ticket 7bbfb7d442) made OP_Once work in trigger sub-programs by
giving each sub-program invocation its own flag array, zeroed on every
OP_Program entry (`memset(p->aOnceFlag, 0, p->nOnceFlag)`).

In 3.54.1 the flags are the per-VdbeFrame bitmask `aOnce`, cleared in OP_Program
(src/vdbe.c) by `memset(pFrame->aOnce, 0, (pProgram->nOp + 7)/8)`.

## Change
src/vdbe.c, OP_Program: removed that memset. This reverses the fix hunk
adding `memset(p->aOnceFlag, 0, p->nOnceFlag)` in OP_Program. The frame is cached
and reused across firings of the same trigger, so OP_Once flags stay set from the
previous firing. The once-only code (materialized subqueries, IN-lists, automatic
indexes) is then skipped on later firings even though the registers/cursors were
reset, giving wrong results or stale data.

## Oracle
tkt-7bbfb7d442-1.1 to 1.3 pass. 1.4 (multi-row insert firing the trigger several times)
hits `Assertion memIsValid(pRec) failed` in sqlite3VdbeExec, and the run aborts, so
2.1-2.3 also fail.
