# Rationale

## Changed hunk: src/expr.c, `sqlite3ExprCodeTarget`, `case TK_COLLATE`
Reverses the fix's only implementation hunk. The fix widened the soft-COLLATE
(no EP_Collate) branch so it applies to any TK_COLLATE node. Before it, the
branch only applied when `pExpr->pLeft->op==TK_FUNCTION`. I restored that
condition (`&& ALWAYS(pExpr->pLeft) && pExpr->pLeft->op==TK_FUNCTION`).
The body (now OP_ClrSubtype in 3.54.1 rather than the old SCopy code) is unchanged.
A soft-COLLATE wrapped around a larger expression (CASE, unary +) then skips
OP_ClrSubtype, so subtypes cross the subquery boundary again.

## Oracle failures
subtype1-300 and subtype1-320 fail (the CASE-wrapped json_patch view and the
pushed-down `json_quote(y)` constraint over `+json('1')`).
