# Rationale

Fix (ticket dd6bffbfb6e61db9) made `sqlite3VdbeMemNumerify()` also yield an
integer when the REAL value is losslessly an integer (`CAST('1.0' AS NUMERIC)`
-> 1). The `alsoAnInt()` and `sqlite3RealSameAsInt()` hunks no longer map onto
current code (the range check is already folded into RealSameAsInt, which has
also been changed for 0.0).

Change: `src/vdbemem.c`, `sqlite3VdbeMemNumerify()` — removed the
`|| sqlite3RealSameAsInt(pMem->u.r, (ix = sqlite3RealToI64(pMem->u.r)))`
clause. This reverses the fix's added `|| sqlite3RealSameAsInt(...)` clause;
the result is integer only if the text itself parses as an integer, as before
the fix.

Oracle failures: e_expr-32.1.2 (CAST('45.0' AS NUMERIC) is real, not integer),
e_expr-32.1.6, e_expr-32.1.7, e_expr-32.2.8 (the -5.0 cases).
