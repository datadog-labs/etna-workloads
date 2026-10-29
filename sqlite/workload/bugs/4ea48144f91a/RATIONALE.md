# Rationale

Both changes are in `src/where.c`, and each reverses a hunk of fix.patch.

1. `whereLoopAddBtreeIndex()`: the fix changed the ONEROW test to `if( iCol==XN_ROWID || pProbe->uniqNotNull ...` and deleted `assert( iCol!=XN_ROWID || pProbe->uniqNotNull )`. I restored the assert and the plain `pProbe->uniqNotNull` test.
2. `whereLoopAddBtree()`: the fix deleted `sPk.uniqNotNull = 1;` for the fake rowid index. I restored it. Without it, the assert in change 1 would fail for the IPK pseudo-index itself.

The pre-fix code assumed that `iCol==XN_ROWID` only occurs on the fake IPK index. A real index such as `u1ab(b,c)` also has the implicit rowid as its last column, so an equality on `u1.a` in `u1.a=u2.a AND u1.b=u2.b AND u1.c=u2.c` reaches that branch with a non-uniqNotNull index. The assert fails.

## Oracle
`join2-6.1` fails: `Assertion 'iCol!=XN_ROWID || pProbe->uniqNotNull' failed`, and the testfixture aborts. This is the bug the fix's new test 6.x guards against. All other cases passed before the abort.
