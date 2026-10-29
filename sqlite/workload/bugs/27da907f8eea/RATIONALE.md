# Rationale

Fix hunks (src/window.c, selectWindowRewriteExprCb): the fix saved `pExpr->flags & EP_Collate`
before the expression is wiped with memset() and restored it on the rewritten TK_COLUMN.
In 3.54.1 the saved mask is `EP_Collate|EP_OuterON|EP_InnerON` (later code added the join flags).
I dropped `EP_Collate` from the mask in `int f = pExpr->flags & (...)` (src/window.c:811), so the
COLLATE flag is lost on rewritten expressions again, which is the pre-fix behaviour. The join-flag
handling is unrelated and left intact.

Failing oracle case: window1-64.3 (count() OVER () with ORDER BY max(b COLLATE nocase)||'' ignores
the collation, so the ordering is wrong).
