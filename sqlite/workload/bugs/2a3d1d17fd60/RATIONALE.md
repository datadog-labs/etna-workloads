# Rationale

Fix hunk (src/parse.y, `binaryToUnaryIfNull`): changed `pY->op==TK_NULL` guard to `pY && pA && pY->op==TK_NULL`, avoiding a NULL deref when the right side of IS is an illegal `#ID` variable (parse yields a NULL Expr).

In 3.54.1 that logic lives in `sqlite3PExprIs` (src/parse.y). Its guard `if( pRight && pRight->op==TK_NULL )` is the equivalent NULL check. I reverted it to `if( pRight->op==TK_NULL )`, the pre-fix unchecked dereference.

Oracle: expr-1.127 (`SELECT 1 IS #1;`, expecting `near "#1": syntax error`) now crashes testfixture with a NULL deref (the run ends at expr-1.127).
