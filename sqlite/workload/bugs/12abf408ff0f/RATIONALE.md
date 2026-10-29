# Rationale

Both changes are in `src/expr.c` and undo the fix's use of `exprCodeVector()` (the helper already exists in 3.54.1, and the IN code still uses it, so it is untouched).

1. `exprCodeBetween()`: the fix replaced
   `if( !sqlite3ExprIsVector(&exprX) ) exprToRegister(&exprX, sqlite3ExprCodeTemp(...))`
   with an unconditional `exprToRegister(..., exprCodeVector(...))`. I restored the old guarded form. The 3.54.1 code uses `pDel` and `sqlite3ExprToRegister` in place of `exprX` and `exprToRegister`. A vector left operand is no longer evaluated once into registers, so it is evaluated once for each comparison.
2. `sqlite3ExprCodeTarget()`, `case TK_CASE`: the fix replaced `sqlite3ExprCodeTemp(pParse, pX, &regFree1)` with `exprCodeVector(...)`. I restored `sqlite3ExprCodeTemp`, so vector operands in CASE are no longer supported.

## Oracle cases that fail
- `e_expr-13.1.6`: `(x(),8) BETWEEN (9,7) AND (9,10)` evaluates `x()` twice instead of once.
- `rowvalue8-1.1` and `rowvalue8-1.2`: `CASE (b,c) WHEN (1,2)...` gives "row value misused".
- `rowvalue8-2.1`: `CASE (SELECT b,c ...)` gives "sub-select returns 2 columns - expected 1".
