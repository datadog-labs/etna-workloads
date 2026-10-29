# Rationale

## Changed hunk
`tree/src/resolve.c`, `resolveExprStep()`, case `TK_IS`/`TK_ISNOT`: the condition
`pRight->op==TK_ID || pRight->op==TK_TRUEFALSE` is reduced to `pRight->op==TK_ID`
(the `ALWAYS(pRight)` wrapper added since 2020 is kept).

This reverses the single implementation hunk of the fix. In 3.54.1 the code is the
same as the post-fix code, so the revert is exact. When the rhs of an IN() contains
`x IS TRUE`, the parser has already converted `TRUE` to a TK_TRUEFALSE node. The
resolver is then reached a second time and no longer rewrites the IS node to TK_TRUTH,
so it is compiled as a plain `IS` comparison.

## Oracle failures
`test/in.test` case `in-20.1` (`SELECT (1 IN (2 IS TRUE));`) expects 1 and gets 0.
All other 126 cases pass.
