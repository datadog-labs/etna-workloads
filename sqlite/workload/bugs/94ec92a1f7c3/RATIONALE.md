# Rationale

Fix (2019-01-14) replaced `assert( iDelta>0 || (nDoclist==0 && iDelta==iDocid) )`
in `sqlite3Fts3SegReaderStep()` (ext/fts3/fts3_write.c) with a runtime
`FTS_CORRUPT_VTAB` return. In 3.54.1 the check had moved into the delta
computation as two explicit corruption checks (`iPrev<=iDocid` for descending
indexes, `nDoclist>0 && iPrev>=iDocid` otherwise). 

Change: removed both `return FTS_CORRUPT_VTAB` checks and restored the
pre-fix `assert( iDelta>0 || (nDoclist==0 && iDelta==iDocid) )` after the
delta computation. Equivalent to the pre-fix code: a corrupt segment with
non-increasing docids now trips the assert (or yields a bad delta in
non-debug builds) instead of reporting corruption.

Oracle failure: fts3corrupt4-8.1 aborts with
`Assertion 'iDelta>0 || (nDoclist==0 && iDelta==iDocid)' failed`
(expected "database disk image is malformed").
