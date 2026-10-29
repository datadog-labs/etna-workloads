# Rationale

Fix: RETURNING subqueries referencing the modified table must be marked correlated (SF_Correlated / EP_VarSelect) so they're re-evaluated per row.

Changes in `tree/src/trigger.c` (reverses the fix's trigger.c hunks):
- Removed the call `sqlite3ProcessReturningSubqueries(pNew, pTab);` in `codeReturningTrigger()` (reverses the third hunk).
- Removed the helpers `sqlite3ReturningSubqueryVarSelect`, `sqlite3ReturningSubqueryCorrelated` and `sqlite3ProcessReturningSubqueries` (reverses the first hunk, which added them; they would otherwise be unused statics). They already existed unchanged apart from `pSTab` naming, so the removal is the exact pre-fix state.

Oracle failures: returning1-20.1 and returning1-20.2 (the subqueries `(SELECT min(a) FROM t1)` etc. are computed once and reused, so later rows show stale values).
