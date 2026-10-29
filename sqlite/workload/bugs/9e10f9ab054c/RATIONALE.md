# Rationale

Fix: ticket 9c944882. When `sqlite3Select()` rewrites `SELECT DISTINCT ... ORDER BY` into
`GROUP BY`, it must also set `SF_Aggregate`. Without it the Select is left with
`pGroupBy!=0` but no `SF_Aggregate`, which is inconsistent if the Select is coded again.

## Changes

1. `src/select.c` (DISTINCT -> GROUP BY transform in `sqlite3Select`): deleted
   `p->selFlags |= SF_Aggregate;`. This is exactly the one line the fix added (hunk `@@ -6104`).

2. `src/expr.c` (`sqlite3CodeSubselect`): the "already coded, invoke as subroutine" shortcut
   is disabled (`if( 0 && ExprHasProperty(pExpr, EP_Subrtn) )`).
   Reversing hunk 1 alone does not fail anything on 3.54.1. A correlated scalar subquery
   used to be coded once per reference to the same Expr, which is how the 2020 test hit the
   inconsistent Select. Today the second reference is turned into an `OP_Gosub` to the
   first coding (the "REUSE SUBQUERY" path). That path covers the case a second time, so
   the Select is never visited twice. Disabling it restores the 2020 behaviour of
   re-coding the Select, which is the only way the missing flag is observable.
   I checked with instrumentation, over the select/with/view/subquery/window/in/where
   test files, that no resolved Select with a GROUP BY and no `SF_Aggregate` is
   ever coded or duplicated again while the reuse path is active.

## Oracle failure

`distinct-7.1` (test/distinct.test) fails with
`sqlite3Select: Assertion 'pSub->pGroupBy==0' failed`.
The correlated scalar subquery `SELECT count(*) FROM t2 WHERE t4.x!='abc'` is coded twice.
On the second pass its FROM-clause subquery (the CTE `SELECT DISTINCT y ... ORDER BY y`)
already has the GROUP BY from the first pass but lacks `SF_Aggregate`. The flattener's
check `if( pSub->selFlags & SF_Aggregate ) continue;` therefore misses it and the
assert fires. This is the same assertion the 2020 test guarded against.
All other oracle cases still pass. The distinct-7.1 assert aborts the run, so the cases after it were not run.
