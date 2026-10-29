# Rationale

## Change: `src/vdbesort.c`, `vdbeMergeEngineStep()`
Reverses the fix hunk in `sqlite3VdbeSorterNext()` that changed
`if( iRes<=0 )` to `if( iRes<0 || (iRes==0 && pIter1<pIter2) )`.
In 3.54.1 that code is `vdbeMergeEngineStep()` (pIter -> pReadr, aIter -> aReadr).
The condition is restored to `iRes<=0`, so on equal keys the left reader always wins
rather than the one from the oldest PMA. The merge is then unstable.

The other equal-key path, `vdbeMergeEngineCompare()` (initial tree build), already uses
`res<=0` with p1 as the older reader, as it did after the fix, so it was left alone.
The comment-only hunks were not touched.

## Oracle
`sort-13.3` (test/sort.test) fails. With `cache_size=5` the sorter spills multiple PMAs,
and ORDER BY a returns rows with equal `a` in a different `b` order than the stable result.
