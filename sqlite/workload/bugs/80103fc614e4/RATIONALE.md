# Rationale

Change: `src/expr.c`, `sqlite3ExprAddCollateString()` now passes `dequote=1` to
`sqlite3ExprAddCollateToken()` (the fix passed 0).

Reverses the fix hunk in `sqlite3ExprAddCollateString` (`..., &s, 0)`). Before the fix, the
token function always dequoted, so internally generated collation names (from
CollSeq->zName, e.g. in resolve.c ORDER BY handling, select.c, fkey.c, whereexpr.c LIKE
optimization) were dequoted a second time. A name such as `"""` is dequoted again, which
yields a wrong name or an assertion failure. The `dequote` parameter already exists in
3.54.1, so only the string wrapper needed reverting. The parse.y callers already pass 1.

Oracle: collate1-6.3 fails (`sqlite3Dequote: Assertion z[i] failed`, crash), so
later 6.x cases do not run.
