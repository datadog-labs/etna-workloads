# Rationale

Changed `codeEqualityTerm()` in `tree/src/wherecode.c` (the IN-loop setup, where `OP_IsNull` is emitted after the `OP_Rowid`/`OP_Column` that reads each IN-RHS value).

Fix hunk reversed: the fix moved `OP_IsNull` inside the `if( aLTerm[i]->pExpr==pX )` block and made it test the register just written (`iOut`). Before the fix, `OP_IsNull` was emitted once per loop iteration, after the block, and tested only the first register (`iReg`). In 3.54.1 the loop is the same shape (`iTarget` replaces `iReg`). I removed the per-column `IsNull(iOut)` and re-added a single `OP_IsNull iTarget`, which tests only the first vector column, after the loop.

The result is that a NULL in a non-first column of a vector IN (`(a,b) IN (SELECT x,y ...)`) no longer causes the row to be skipped.

Oracle failures (rowvalue6.test):
- 1.1: expected `{}`, got `200`. The RHS row (1,NULL) should never match, but it does.
- 1.2: expected `400`, got `200 400`, for the same reason.
