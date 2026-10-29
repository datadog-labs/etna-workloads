# Rationale (fix 781592f3, ticket d666d600a6)

Bug: `x COLLATE nocase BETWEEN a AND c` lost the COLLATE. exprCodeBetween
turned the left operand into a TK_REGISTER node, overwriting a TK_COLLATE
node without recording the old op in op2, so sqlite3ExprCollSeq never saw
the collation.

In 3.54.1 the two fix hunks are covered differently:
the collate-aware TK_REGISTER lookup is `if( op==TK_REGISTER ) op = p->op2;`
in sqlite3ExprCollSeq, and the op2 save lives in sqlite3ExprToRegister, which
also skips COLLATE wrappers. I reverted both in src/expr.c:

1. sqlite3ExprCollSeq: `if( op==TK_REGISTER && p->op2!=TK_COLLATE ) op = p->op2;`
   Reverses the hunk that added `(op==TK_REGISTER && p->op2==TK_COLLATE)` to
   the TK_COLLATE test: a register node whose original op was COLLATE is no
   longer treated as a COLLATE node.
2. sqlite3ExprToRegister: `Expr *p = pExpr;` instead of
   `sqlite3ExprSkipCollateAndLikely(pExpr)`. This is the pre-fix behaviour
   of converting the top node (the COLLATE node) itself into TK_REGISTER,
   which the `exprX.op2 = exprX.op` hunk had to accommodate.

Oracle failures (test/collate2.test): collate2-6.2, 6.4, 6.5, 6.7 return
`b` instead of `b B` (collation ignored when the left side of BETWEEN has an
explicit COLLATE). 6.3 and 6.6 (COLLATE on the bounds) still pass, as before the fix.
