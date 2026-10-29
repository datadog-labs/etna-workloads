# Rationale

Fix: in `fts3SegmentMerge()` (FTS3_SEGCURSOR_ALL), only return SQLITE_DONE for
a single segment if that segment is not the in-memory pending-terms reader.

## Changes (all in ext/fts3/fts3_write.c)

1. `fts3SegmentMerge()`: `if( csr.nSegment==1 && 0==fts3SegReaderIsPending(csr.apSegment[0]) )`
   -> `if( csr.nSegment==1 )`. Direct reversal of the one fix hunk. Alone it
   no longer fails, because 3.54.1's `fts3DoOptimize()` flushes pending terms
   first, so the merge never sees a pending reader.
2. `fts3DoOptimize()`: removed the up-front `sqlite3Fts3PendingTermsFlush()`
   and instead call `sqlite3Fts3PendingTermsClear()` after the merge loop
   succeeds. This is the other path that also covers the case (the flush
   hides the defect). It restores the pre-fix shape: optimize merges the
   pending-terms reader together with on-disk segments and then discards the
   hash table, since it has been written out.
   With only pending data (nothing on disk) the merge returns SQLITE_DONE
   without writing anything, and the hash is then cleared, so the data is lost.
   This is the symptom in the commit message.

## Oracle failures (test/fts4opt.test)
- 3.3: segdir expected `0 0`, got empty (data discarded).
- 3.4, 3.5: "database disk image is malformed" (integrity-check / no index data).
- 3.7: optimize after insert expected more than one change, got 0.
