# Rationale

Fix hunk: `fts5SetupTokendataIter()` loop `while( 1 )` -> `while( p->rc==SQLITE_OK )`,
so the loop stops once an error (OOM/corruption) is recorded.

In 3.54.1 the loop already has the fix's condition, and also an equivalent guard
(`if( p->rc ){ fts5IterClose(pNew); break; }` right after the seek-buffer setup,
which catches an error left by `fts5MultiIterAlloc`/`fts5BufferSet`). Reversing only
the loop condition therefore changes nothing. Both are the same defect (loop does not
stop on error), so I reverted both in `ext/fts5/fts5_index.c`:

1. `while( p->rc==SQLITE_OK )` -> `while( 1 )` (direct reversal of the fix hunk).
2. Removed the `if( p->rc ){ ...; break; }` early exit that covers the same case.

With an error set, `fts5MultiIterAlloc` returns NULL and `&pNew->aSeg[0]` is dereferenced
(or the loop keeps iterating on a broken index).

## Oracle
fts5corrupt5-7.1 (the test added by the fix) crashes the testfixture, so the run is
incomplete and 21 of 40 oracle cases (7.1, 8.x ... 14.x) fail.
