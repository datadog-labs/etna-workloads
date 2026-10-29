# Rationale

Bug (1be72aab9): BETWEEN/CASE coding converted a node of the *original* expression into TK_REGISTER (via a shallow copy whose children are shared, `sqlite3ExprToRegister` skipping COLLATE onto the shared child). Schema CHECK expressions got corrupted.

## Changes (all tree/src)
1. `expr.c` `exprCodeBetween`: reverses the fix hunk that replaced `exprNodeCopy(&exprX, ...)` with `sqlite3ExprDup`. Restores the stack `Expr exprX` shallow copy, drops pDel / mallocFailed handling.
2. `expr.c` `TK_CASE` in `sqlite3ExprCodeTarget`: same reversal with `tempX` (stack shallow copy) in place of `pDel`.
3. `expr.c`: re-added `exprNodeCopy()` (the helper the fix deleted).
4. `insert.c` `sqlite3GenerateConstraintChecks`: the later code that duplicates each CHECK expression (`pCopy = sqlite3ExprDup`) before coding it covers the same defect from another path (it protects `Table.pCheck` from being mutated into TK_REGISTER). Reverted to code `pExpr` directly, as before that protection.

Hunks 1-3 alone do not fail the oracle because of path 4's duplicate.

## Oracle failures
With all four, `sqlite3ExprIfTrue` hits `assert(!ExprHasVVAProperty(pExpr, EP_Immutable))` on the first CHECK insert, aborting test/check.test (check-1.2 onward, incl. 11.x) and test/checkfault.test (cffault-1.1/1.2). Note this fires for every CHECK constraint, not only BETWEEN/CASE ones, which is broader than the original failure.
