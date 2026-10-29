# Rationale

Fix: DEFAULT clauses must reject bound parameters in new CREATE TABLE
statements, and convert them to NULL when loading an existing schema.

Changed: `src/expr.c`, `exprNodeIsConstant()`: removed the `case TK_VARIABLE:`
branch (eCode==5 -> `pExpr->op = TK_NULL`; eCode==4 -> not constant).
This reverses the fix's added `case TK_VARIABLE` hunk. Without it a variable
falls to `default` and is treated as constant, as before the fix. The
`db->init.busy` plumbing in build.c/sqliteInt.h (the isInit argument) still
exists but now has no effect on variables.

Oracle: default-4.1 aborts (assert `pOp->p1>0 && pOp->p1<=p->nVar` in
sqlite3VdbeExec: the schema's `:xyz` is not converted to NULL), which kills
the rest of the file; default-4.2..4.4 would also fail (no "not constant"
error). Other listed cases fail only because the run aborts.
