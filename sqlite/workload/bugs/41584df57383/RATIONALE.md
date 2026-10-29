# Rationale

Bug: RETURNING did not honor REAL column affinity (5.0 came back as integer 5).

Changes (reversing both implementation hunks of the fix):
- `tree/src/resolve.c` (lookupName, bReturning branch): removed `pExpr->op2 = TK_COLUMN;`. Reverses the resolve.c hunk. Without it, the TK_REGISTER expression loses its column identity, so `sqlite3ExprAffinity()` no longer reports the column's affinity.
- `tree/src/trigger.c` (codeReturningTrigger): removed the `if( sqlite3ExprAffinity(pCol)==SQLITE_AFF_REAL ) OP_RealAffinity` after `sqlite3ExprCodeFactorable`. Reverses the trigger.c hunk. The `pCol==0` guard from the fix was already handled differently in 3.54.1 and is left alone, since it is not related to the bug.

Oracle failures: returning1-15.0, 15.1, 15.2 (REAL values that are integral are returned without REAL affinity, so affinity(x) is wrong).
