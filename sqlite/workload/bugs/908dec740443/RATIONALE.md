# Rationale

## Change: src/expr.c, sqlite3ExprAnd()
Fix hunk reversed: the fix made sqlite3ExprAnd() skip the "AND false" -> constant 0
optimization when either operand carries EP_OuterON or EP_InnerON (i.e. comes from a join
ON clause). In 3.54.1 the condition is
`(f&(EP_OuterON|EP_InnerON|EP_IsFalse|EP_HasFunc))==EP_IsFalse`; I removed
EP_OuterON|EP_InnerON from the mask, giving `(f&(EP_IsFalse|EP_HasFunc))==EP_IsFalse`.
The AND with a false operand from an ON clause is therefore collapsed to a plain `0`
again, losing the ON-clause marking (the pre-fix behaviour). EP_HasFunc is a later,
unrelated addition and is left alone.

## Oracle failures
- join-29.1 (the test added by the fix): `SELECT * FROM t1 JOIN v2 ON 0 FULL OUTER JOIN t0 ON true`
  returns the wrong result.
- join-16.100 also fails (a join test that depends on the same ON-clause handling).
