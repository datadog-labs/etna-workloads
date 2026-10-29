# Rationale

Fix hunk reversed: `sqlite3Fts3SegReaderNew()` in `ext/fts3/fts3_write.c`.
The fix added `if( iEndLeaf!=0 ) return FTS_CORRUPT_VTAB;` inside `if( iStartLeaf==0 )`.
I deleted that line. The code around it is unchanged from 2019, so the revert is exact.
A corrupt segdir row with start_block==0 but leaves_end_block!=0 is no longer rejected.
The reader is built with the root-node `nExtra` allocation and an inconsistent leaf range, so the corruption goes undetected and memory leaks.

The other two hunks only change `SQLITE_CORRUPT_VTAB` to `FTS_CORRUPT_VTAB` in `nodeReaderNext`.
That is the same value unless SQLITE_DEBUG is on, so they have no behavioural effect and I left them alone.

Oracle result: `fts3corrupt4-10.3` fails.
`INSERT INTO t1(t1) VALUES('optimize')` no longer returns "database disk image is malformed".
The run also ends with "Unfreed memory: 4080 bytes in 1 allocations", which is the leak the fix addressed.
