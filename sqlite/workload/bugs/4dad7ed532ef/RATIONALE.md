# Rationale

Fix hunk (src/expr.c, sqlite3ExprCodeGeneratedColumn) added an OP_IfNullRow
guard so a generated column on a NULL-complemented LEFT JOIN row evaluates to
NULL. In 3.54.1 the function has the same guard (plus TypeCheck/ExprCodeCopy
changes). I removed the guard: `iAddr = 0;` replaces the
`if( pParse->iSelfTab>0 ){ iAddr = OP_IfNullRow ... }` block, so the expression
is always evaluated and the later `if( iAddr ) JumpHere` is a no-op. This is the
pre-fix behaviour (no IfNullRow, expression evaluated unconditionally).

Failing oracle cases: gencol1-16.10, 16.20, 16.40 (generated column returns
1 / 1 instead of NULL on the NULL right-hand LEFT JOIN row).
