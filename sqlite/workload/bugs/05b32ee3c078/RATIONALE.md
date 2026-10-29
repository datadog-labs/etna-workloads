# Rationale

Bug: edgy (DIRECTONLY/innocuous-less) functions were rejected in TEMP tables'
generated columns, CHECK constraints, partial indexes and index expressions,
because EP_FromDDL was set on every self-referencing TK_FUNCTION node, TEMP or not.

Changes (src/resolve.c only):
1. `resolveExprStep`: `if( pNC->ncFlags & NC_FromDDL ) ExprSetProperty(...)` back to
   `if( pExpr->op2 ) ExprSetProperty(...)`. Reverses the first fix hunk (op2 holds
   the NC_SelfRef bits, so EP_FromDDL is set for any self-ref context, TEMP included).
2. `sqlite3ResolveSelfReference`: removed the block that sets `NC_FromDDL` only when
   the table is not in the TEMP schema. Reverses the second fix hunk. The NC_FromDDL
   define in sqliteInt.h is left (now unused), harmless.

Oracle failures (trustschema1): 1.160, 1.240, 1.440, 1.540 ("unsafe use of f3()"
in TEMP tables), matching what the fix's new tests guard against.
