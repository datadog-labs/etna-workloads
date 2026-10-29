# Rationale

Bug: for `UPDATE t SET (a,a,a,b)=(SELECT ...)` the LHS column count was recorded only on
the first TK_SELECT_COLUMN node (iTable), and the codegen check was `if( iTable && ... )`.
Duplicate target columns drop nodes, so the node carrying the count could be skipped and
the size mismatch went undetected.

Changes (src/expr.c):
1. `sqlite3ExprForVectorField`: removed `pRet->iTable = nField;`. Reverses the fix hunk in
   `sqlite3ExprListAppendVector` that set `pSubExpr->iTable = pColumns->nId` on every field
   (today that assignment lives in ForVectorField). Only the first node gets iTable, set in
   `sqlite3ExprListAppendVector` (`pFirst->iTable`, already present).
2. TK_SELECT_COLUMN case in `sqlite3ExprCodeTarget`: check restored to
   `if( pExpr->iTable && pExpr->iTable!=n )`, the pre-fix guarded form.

Oracle: rowvalue7-3.0 fails (assertion `memIsValid(pRec)` in sqlite3VdbeExec instead of
"4 columns assigned 2 values"). Other cases pass.
