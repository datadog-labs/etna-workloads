# Rationale

## Hunk: ext/fts5/fts5_index.c, fts5LeafRead
Fix changed `pRet->nn<4 || pRet->szLeaf>pRet->nn` to `pRet->szLeaf<4 || ...`.
In 3.54.1 the line already had the fixed form (szLeaf is only read when nn>=4, otherwise it stays 0).
I restored the old check `pRet->nn<4`. A leaf with nn>=4 but a szLeaf field of 0..3 (e.g. the test's
`00000080...` blob, or zeroblob(4)) is then accepted instead of being reported as corrupt,
so later code computes a negative/undersized leaf-size and overwrites a buffer.

## Oracle
fts5corruptA-1.5 fails: testfixture aborts with assertion
`fts5PoslistCallback: nSpace>=n+nChunk` (the buffer overwrite), so the remaining cases (2.x-5.x) never complete.
