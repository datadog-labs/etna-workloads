# Rationale

## Hunk changed: tree/src/wherecode.c (sqlite3WhereCodeOneLoopStart, OR-term/"pAlt" transitive-constraint loop)

The fix added a guard that skips a candidate `pAlt` term when it is a
`(a,b) IN (SELECT ...)` with more than one result column. In 3.54.1 the same
guard exists (using `ExprUseXSelect` in place of `EP_xIsSelect`). I removed
the whole `if( (pAlt->eOperator & WO_IN) && ExprUseXSelect(...) && nExpr>1 ){ continue; }`
block, restoring the pre-fix code. Without it, the multi-column IN term is
used as a substitute for an equality constraint, producing the spurious
"sub-select returns N columns - expected 1" error.

## Oracle failures
`./check.sh`: rowvalue-17.1 and rowvalue-18.6 fail (the join queries with
`(b1.a, 2) IN (VALUES(1,2))` and `(b3.a, b3.b) IN (SELECT a, b FROM b5)`).
