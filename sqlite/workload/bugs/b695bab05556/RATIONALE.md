# Rationale

## Change: ext/fts3/fts3.c, fts3EvalNearTrim()
Fix hunk: wrapped the assert/memset/nList update in `if( nNew>=0 )`, so a
corrupt record yielding nNew<0 skips the trim. In 3.54.1 the guard had become
`assert_fts3_nc(...)` + `if( nNew>=0 && nNew<=nList )`. I restored the pre-fix
code: unconditional `assert(pList[nNew]=='\0')`, `assert(nNew<=nList && nNew>0)`,
`memset(&pList[nNew],0,nList-nNew)` and `nList = nNew`. This is exactly the
code the fix guarded (the later bounds check on nNew is removed with it).

## Oracle failure
fts3corrupt4-43.2 (`1 NEAR 1` on corrupt segdir) aborts:
`Assertion pPhrase->doclist.pList[nNew]=='\0' failed` in fts3EvalNearTrim.
(Without assertions it would be an out-of-bounds memset with negative offset.)
