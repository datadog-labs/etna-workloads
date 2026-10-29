# Rationale

Fix: `isCandidateForInOpt()` must reject a correlated subquery on the RHS of IN
(`pRes->iTable!=pSrc->a[0].iCursor`).

In 3.54.1 the same defence exists in two forms in `src/expr.c`
`isCandidateForInOpt()`, so both were removed (the bug was effectively "fixed twice"):

1. `if( ExprHasProperty(pX, EP_VarSelect) ) return 0;  /* Correlated subq */`
   removed. This is the up-front correlated-subquery rejection, the modern
   equivalent of the fix's added check.
2. `assert( pRes->iTable==pSrc->a[0].iCursor );` in the result-column loop
   removed. This is the fix's iTable test, which is now only an assert.
   Without removing it, debug builds would abort rather than return wrong results.

Result: a correlated subquery such as `x NOT IN (SELECT x FROM t14b)` (where `x`
resolves to the outer table) is treated as a plain table scan of t14b.

Oracle failure: where2-14.1 expected `{}` but got `{2 3 4}`.
