# Rationale

Changed `substExpr()` in `tree/src/select.c` only (the "Ensure that the expression now has an implicit collation sequence" block).

Fix hunk reversed: the `substExpr` hunk that replaced
`if( op!=TK_COLUMN && op!=TK_COLLATE ){ pColl = CollSeq(pExpr); AddCollate(pColl) }`
with a comparison against the collation of the leftmost SELECT's result column (`pCList`).
In 3.54.1 the variable is `pNew` rather than `pExpr`. I restored the pre-fix condition and computation: the collation is taken from the substituted expression itself, and is only added when the expression is not a TK_COLUMN/TK_COLLATE. The code no longer consults the leftmost SELECT's column collation (`pSubst->pCList`).

The `pCList` field, `findLeftmostExprlist()` and the two call sites are left in place but are now unused. That avoids unrelated churn. Dropping them is a purely cosmetic part of the fix.

## Oracle failure
`collate5-5.1` fails: expected `1 bbb`, got an empty result. In the push-down of `WHERE b='BbB'` into the compound `SELECT a,b FROM t1 UNION ALL SELECT c,d FROM t2`, the term is pushed into the second component. There `d` is a TK_COLUMN with BINARY collation, so no COLLATE is added and the comparison is no longer NOCASE.
