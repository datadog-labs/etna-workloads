# Rationale

## Change
`tree/src/insert.c`, `sqlite3MultiValues()`, condition (c): the call
`sqlite3ExprListIsConstant(pParse, pRow, 1)` now passes `bNoIs=0`.

Reverses the fix hunk that changed condition (c) from
`exprListIsConstant(pParse,pRow)==0` (which used plain `sqlite3ExprIsConstant`)
to `sqlite3ExprListIsConstant(pParse, pRow, 1)`. With `bNoIs=0` the walker uses
eCode 1, the same as the old code, so a row containing `x IS TRUE` is again
treated as constant and coded with the co-routine method. This skips the
TK_IS -> TK_TRUTH transform that happens during name resolution. The
`TK_IS`/eCode 6 code in expr.c is left in place, since it is now only unused.

## Failing oracle cases
- values-20.1: `t0.c1 IN (VALUES (1), (0.5 IS true))` returns 12345 instead of no rows.
- values-20.3: `SELECT * FROM ((VALUES(1),(0.5 IS true)))` gives `1 0` instead of `1 1`.
- values-20.8: gives `0 1` instead of `0 0`.
