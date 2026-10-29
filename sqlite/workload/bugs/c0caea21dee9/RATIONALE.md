# Rationale

Bug: delete markers (empty doclists) were never dropped from the FTS index when
a merge produced the oldest segment, except in 'optimize'.

Changes in `ext/fts3/fts3_write.c`:

1. `fts3SegmentMerge()`: removed the `bIgnoreEmpty = (iLevel!=FTS3_SEGCURSOR_PENDING) && (iNewLevel>iMaxLevel);`
   assignment in the non-ALL branch. This reverses the fix hunk that added it, so crisis merges
   keep delete markers (only FTS3_SEGCURSOR_ALL, i.e. optimize, ignores them).
2. `sqlite3Fts3Incrmerge()`: removed the block that sets `FTS3_SEGMENT_IGNORE_EMPTY` on `pFilter->flags`
   (the fix's `if( (iIdx-bUseHint)==0 ) pFilter->flags |= FTS3_SEGMENT_IGNORE_EMPTY`; current code
   uses a `fts3SegmentIsMaxLevel` check). Incremental merges again keep delete markers.

Failing oracle cases (test/fts4growth.test): fts4growth-3.2.2 (incremental merge leaves
a larger segment, delete markers retained) and fts4growth-3.3.2 (crisis merge: got end_block 594, expected 412).
