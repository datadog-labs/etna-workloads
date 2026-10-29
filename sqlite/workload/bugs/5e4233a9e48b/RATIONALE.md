# Rationale

The fix (5e4233a9e48b) added `NameContext.nNestedSelect` and used it in
`src/resolve.c` to correct `op2` (aggregate nesting level) when an aggregate
appears in a FROM-clause subquery of a sub-select of the select owning it.
version-3.54.1 still contains all of it; I removed it all, restoring the pre-fix code:

- `src/sqliteInt.h`: removed the `nNestedSelect` field (fix hunk 1).
- `src/resolve.c` resolveSelectStep: removed `pOuterNC->nNestedSelect++` before the
  FROM-clause subquery loop and the matching decrement after it (fix hunks 3, 4;
  the decrement is written as an ALWAYS-guarded block in 3.54.1).
- `src/resolve.c` resolveExprStep (TK_FUNCTION): `pExpr->op2 += (1 + pNC2->nNestedSelect)`
  back to `pExpr->op2++`, and removed `pExpr->op2 += pNC2->nNestedSelect` (fix hunk 2).

Result: the aggregate is attributed to the wrong nesting level, giving a spurious
"misuse of aggregate" error.

Failing oracle cases: window1-57.3 (gets the misuse error instead of `0 5`),
aggnested-7.1, 7.2, 8.0, 8.1, 8.2 (the new tests from the fix), plus
aggnested-9.1–9.5 and 10.1.
