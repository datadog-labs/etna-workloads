# Rationale

## Change: src/pragma.c, CHECK-constraint verification in integrity_check
Reverses the fix.patch hunk in src/pragma.c. The fix made integrity_check code-generate
from a duplicate (`sqlite3ExprListDup`) of `pTab->pCheck`, freeing it afterwards.
Pre-fix code used `pTab->pCheck` directly, so the code generator
(`sqlite3ExprIfFalse/IfTrue` with `iSelfTab`) modified the table's shared CHECK
expressions in place. That in-place modification disabled the xfer optimization for later
INSERT..SELECT/VACUUM on tables with CHECK constraints.
In 3.54.1 I replaced the Dup with `ExprList *pCheck = pTab->pCheck;`, dropped the
`mallocFailed` guard, and dropped the `sqlite3ExprListDelete` call. These are the same
things the fix added. The block is left in `{ }` to keep the diff small.

## Oracle failures
- insert4-10.3: after `PRAGMA integrity_check`, the test crashes with the assertion
  `!ExprHasVVAProperty(pExpr, EP_Immutable)` in sqlite3ExprIfTrue. The shared CHECK
  expression is now code-generated in place.
- pragmafault.test: the run aborts on the same assertion (339 of 340 cases fail).
