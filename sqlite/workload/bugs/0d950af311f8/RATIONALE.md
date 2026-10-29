# Rationale

Fix (ticket 7e07a3dbf5a8cd26) split `sqlite3ExprSkipCollate()` (collate only) from the new
`sqlite3ExprSkipCollateAndLikely()`, and switched callers that need to see through
likely()/unlikely()/likelihood() to the latter. In 3.54.1 those callers are already switched,
so reversing each call-site hunk is not possible/does not reintroduce the bug.

## Change (src/expr.c)
`sqlite3ExprSkipCollate()` again also skips likely()/unlikely()/likelihood() at the root
(it now delegates to `sqlite3ExprSkipCollateAndLikely()`). This reverses the hunk in expr.c
that narrowed `sqlite3ExprSkipCollate` to `EP_Skip` only; it restores the pre-fix semantics
for the callers the fix did NOT convert (e.g. `sqlite3ExprCompareSkip`, whereexpr.c
comparisons at ~1233, vdbemem.c, build.c), so likely(x) is again treated as x
(giving it the affinity of x) instead of as a function with no affinity.

## Oracle failures (test/whereG.test)
whereG-8.2, 8.6, 8.7, 8.12 fail: e.g. `SELECT * FROM t0 WHERE LIKELY(t0.rowid) <= '0'`
returns no rows (the rowid's INTEGER affinity is applied to '0') instead of `a`.
