# Rationale

The fix (f00d096ca) added a `sqlite3WindowRewrite()` call at the top of
`removeUnindexableInClauseTerms()` in src/wherecode.c. That call is gone in
3.54.1, and reversing the hunk would change nothing, because a later change
keeps window-function SELECTs out of that function altogether.

## Changed hunk
`src/whereexpr.c`, `exprAnalyze()`: removed the `&& pExpr->x.pSelect->pWin==0`
condition (and the matching sentence in the comment). The condition stops the
planner from creating per-column virtual terms (TERM_SLICE) for a vector
`(a,b) IN (SELECT ...)` whose RHS uses window functions. That keeps
`removeUnindexableInClauseTerms()` from stripping the RHS of such a SELECT.

This is the same defect as the fix: the planner trims columns, and so window
functions, from a resolved SELECT before `sqlite3WindowRewrite()` has run on it.
If every window function in `Select.pWin` is removed, `pWin` becomes NULL and
the delegated window functions with a different frame are never rewritten.

## Oracle
Running `./check.sh` ends with `sqlite3VdbeExec: Assertion memIsValid(pRec)
failed` while running windowfault test 11 (the fix's new test, `(0, t0.c0) IN
(SELECT DENSE_RANK() OVER(), LAG(0) OVER() FROM t0)`). That crash aborts the
run, so the remaining windowfault cases don't run. The window2 6.2 case from the
fix is the same query.
