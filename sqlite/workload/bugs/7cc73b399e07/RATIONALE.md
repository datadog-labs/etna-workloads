# Rationale

## Change: tree/src/select.c, sqlite3WithPush()

The fix wrapped the push of the WITH clause onto `pParse->pWith` in `if( pParse->nErr==0 )`.
In 3.54.1 the same guard is still present (the function was restructured so the
cleanup registration happens first). I removed the `pParse->nErr==0` guard, so the
assert, `pOuter` assignment and `pParse->pWith = pWith` run unconditionally, as before
the fix. The `bFree` cleanup registration is unchanged, matching the pre-fix behaviour
where the clause is still freed with the Parse object.

## Oracle failures

`with2-11.1` fails (it runs before 12.1 and, in this build, hits the bug first):
`sqlite3WithPush: Assertion 'pParse->pWith!=pWith' failed`. After an earlier error, the
same WITH clause is pushed again, creating a cycle (self-referencing `pOuter`) on the
stack. This is the same failure the fix's `with2-12.1` test (dbsqlfuzz) guards against.
