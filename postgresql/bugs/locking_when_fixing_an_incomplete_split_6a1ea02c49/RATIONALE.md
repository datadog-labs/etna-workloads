# Rationale

File: src/backend/access/gin/ginbtree.c, function ginFindLeafPage (two hunks).

Traces to fix.patch hunks in ginFindLeafPage that replaced
`ginFinishSplit(btree, stack, false, NULL)` with `ginFinishOldSplit(btree, stack, NULL, access)`.
Reverted: both calls go straight to ginFinishSplit() again. When the page was only
share-locked (an internal page, `access == GIN_SHARE`), ginFinishSplit() runs without
the lock upgrade to exclusive. That brings back the assertion failure in MarkBufferDirty()
and the possible corruption when two backends finish the same split.

Oracle case expected to fail: src/test/modules/gin||gin_incomplete_splits
