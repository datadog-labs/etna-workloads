# Rationale

The fix removed one line, an `assert()` in `sqlite3FindInIndex()` (src/expr.c):
`assert( pReq!=0 || pRhs->iColumn==XN_ROWID || pParse->nErr );`
The assert was wrong because the query planner can now use an index on an expression such as `+a COLLATE NOCASE`. In that case pReq can legitimately be NULL.

In version-3.54.1 the same loop still exists, and the assert is absent. I re-added it, in the same place, right after `int j;` in src/expr.c. That is the only change.

Oracle failure: test/in.test case in-23.0 aborts with `Assertion 'pReq!=0 || pRhs->iColumn==XN_ROWID || pParse->nErr' failed`. This needs a build with assertions enabled, which check.sh uses.
