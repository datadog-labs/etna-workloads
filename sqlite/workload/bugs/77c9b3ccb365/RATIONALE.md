# Rationale

The fix's only implementation hunk (src/where.c, wherePathSatisfiesOrderBy) replaced
`assert( pColl1 && (pParse->nErr || pColl2) );` with `assert( pColl1 );`, because
pColl2 can legitimately be NULL (the following `if( pColl2==0 || ...)` handles it).

In version-3.54.1 the same assert sits at src/where.c ~line 5269 (surrounding code was
changed, but the assert is the same). I restored the over-strict assert text exactly.

Oracle failure: orderby5-4.4.0 (the test the fix added) aborts with
`Assertion 'pColl1 && (pParse->nErr || pColl2)' failed` in wherePathSatisfiesOrderBy.
