# Rationale

The fix removed bad `assert( sqlite3VdbeAssertAggContext(pCtx) )` statements from
the step functions of percent_rank() and cume_dist(), along with the helper itself
and the `ALWAYS(p)` wrapper. The assert is wrong because the step function is the
first call on a fresh aggregate context, so MEM_Agg is not yet set.

Changes (all reverse fix hunks):
- src/vdbeapi.c: restore `sqlite3VdbeAssertAggContext()` (SQLITE_DEBUG only). Reverses the vdbeapi.c hunk.
- src/vdbe.h: restore its declaration. Reverses the vdbe.h hunk.
- src/window.c: in `percent_rankStepFunc` and `cume_distStepFunc`, re-add
  `assert( sqlite3VdbeAssertAggContext(pCtx) )` before `sqlite3_aggregate_context()`
  and change `if( p )` back to `if( ALWAYS(p) )`. Reverses the two window.c hunks.
  The `assert( nArg==0 )` lines are left as they are in 3.54.1.

Oracle failure: any query that calls percent_rank() or cume_dist() in a debug build
(test 9.6/9.7 in window4, windowfault 6) aborts with
`cume_distStepFunc: Assertion 'sqlite3VdbeAssertAggContext(pCtx)' failed`.
The check.sh run crashed testfixture with this assertion.
