# Rationale

Fix (2019-03-08): in `fts3ScanInteriorNode()` (ext/fts3/fts3.c) a term with
`nSuffix==0` must be treated as corruption. Without it, a zero-length first
term with nPrefix==0 never allocates `zBuffer`, so the later `memcpy` into
`zBuffer` uses a NULL pointer (assert `zBuffer` in debug builds, segfault
otherwise).

## Changes (ext/fts3/fts3.c only)

1. `fts3ScanInteriorNode`: dropped `|| nSuffix==0` from the corruption check
   `if( nPrefix>zCsr-zNode || nSuffix>zEnd-zCsr )`. This is exactly the
   fix's only implementation hunk, reversed (it applies cleanly to 3.54.1).

2. `fts3SelectLeaf`: removed the later-added `iHeight>FTS3_MAX_BTREE_HEIGHT`
   guard, so the scan is always called. This is NOT part of the fix. It was
   needed because the fix's test (23.0/23.1) feeds a root node whose height
   varint is huge. In 3.54.1 that is rejected by the height guard before
   `fts3ScanInteriorNode` is reached, so reverting hunk 1 alone leaves all
   oracle cases passing. The guard is a separate, later-added defence (the
   recursion is still bounded by the `iNewHeight>=iHeight` check). The pre-fix
   code, which the test crashed, had no such guard. The `FTS3_MAX_BTREE_HEIGHT`
   macro is left defined but unused.

## Oracle failures

`fts3corrupt4-23.1` (`SELECT ... FROM t1 WHERE t1 MATCH 'j'` on the corrupt
database) should return `1 {database disk image is malformed}`. It now aborts
the testfixture with `fts3ScanInteriorNode: Assertion 'zBuffer' failed`. The
run is incomplete, so later cases don't run either.
