# Rationale

Fix: the `x IN (?)` -> `x == ?` rewrite added `COLLATE binary` to the RHS, which
overrode the LHS's implicit collation (in4-5.1). The fix replaced this with an
EP_Generic flag (hunks in expr.c, sqliteInt.h, parse.y).

In 3.54.1 the EP_Generic mechanism does not exist; the rewrite lives in
`src/parse.y` (`expr ::= expr in_op LP exprlist RP`) and wraps the constant RHS
in TK_UPLUS only. I restored the pre-fix behaviour by calling
`sqlite3ExprAddCollateString(pParse, pRHS, "binary")` on the RHS before the
TK_UPLUS wrap, exactly as the pre-fix parse.y hunk did. Only the parse.y
change was needed; the EP_Generic hunks in expr.c/sqliteInt.h are the added
mechanism, whose absence is what makes the bug.

Oracle: in4-5.1 fails. `d IN ('FUZZ')` with d TEXT COLLATE nocase no longer
matches, since the RHS's explicit COLLATE binary wins over the column collation.
