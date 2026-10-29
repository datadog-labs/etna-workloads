# Rationale

## Change: tree/src/select.c, substExpr()

The fix added, right after the substituted expression replaces the column
reference, a conversion of a `TK_TRUEFALSE` expression into `TK_INTEGER` with
`EP_IntValue`. In 3.54.1 the same code lives on `pNew` (after the
`isOuterJoin` EP_CanBeNull step). I removed that `if( pNew->op==TK_TRUEFALSE ){...}`
block, restoring the pre-fix behaviour: a view/sub-select column that is the
literal TRUE/FALSE is substituted as a bare TK_TRUEFALSE node, so `x IS col`
can be treated as `x IS TRUE` / `IS FALSE`.

## Oracle failures

`windowD-1.4` fails: `SELECT * FROM v0 WHERE ('500' IS v0.c1) IS FALSE`
returns no rows instead of `1.0 1`. Other windowD cases still pass.
