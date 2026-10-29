# Rationale

Fix hunk (src/memjournal.c, memjrnlTruncate): the fix wrapped the body in `if( size<p->endpoint.iOffset )` (plus an assert), so truncating to a size >= the current end is a no-op.

Changes in tree/src/memjournal.c:
1. Removed the `assert(...)` and the `if( size<p->endpoint.iOffset ){ ... }` guard, so memjrnlTruncate always runs its body, as before the fix. This is the direct reversal of the fix hunk.
2. Changed the chunk-search loop condition `iOff<size` back to `iOff<=size`. This is the loop as it appeared in the pre-fix code (the "-" lines in fix.patch). The current tree had a later change to `<`. With `<`, removing the guard alone does not reproduce the failure, because the walk then ends on the correct last chunk.
   With `<=`, truncating to an exact chunk-size multiple (a no-op truncate at the endpoint, from a zero-page sub-transaction release) walks past the last chunk. pIter becomes NULL, so endpoint.pChunk is set to 0 with a nonzero offset and later writes crash.

Oracle: memjournal-1.2 fails (assertion `ALWAYS(pIter)` failing in memjrnlTruncate, `Assertion '0' failed`); the run aborts, so 1.3 fails as well. 1.0 and 1.1 pass.
