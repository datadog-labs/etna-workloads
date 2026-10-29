# Rationale

## src/analyze.c, decodeIntArray()
Reverses the fix's analyze.c hunk: removes the `if( sz<2 ) sz = 2;` clamp, restoring
`pIndex->szIdxRow = sqlite3LogEst(sqlite3Atoi(z+3));`. With `sz=0` in sqlite_stat1,
szIdxRow (and, via the fakeIdx path in analysisLoader, pTable->szTabRow) becomes 0.
The query planner divides by szTabRow in whereLoopAddBtreeIndex, so this is a
division by zero.

The fix's where.c hunk only added `assert( pSrc->pTab->szTabRow>0 )`. 3.54.1
still has the equivalent assert (`pSrc->pSTab->szTabRow>0`), so it is untouched. It is
what exposes the bug in debug builds.

## Oracle failures
analyzeC-4.4 (`sz=0` then `SELECT 0 FROM t44 WHERE a IN(1,2,3)`) hits the assertion
`pSrc->pSTab->szTabRow>0` in whereLoopAddBtreeIndex and aborts the run. Cases 5.0-5.3
fail only because the run is incomplete after the crash.
