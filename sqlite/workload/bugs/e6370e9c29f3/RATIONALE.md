# Rationale

## src/btree.c, lockBtree()
Reverses the fix hunk changing `nPage`/`nPageFile` from `int` to `u32` (so a
negative/huge "number-of-pages" header value was handled correctly). Restored
`int nPage; int nPageFile`. (The `nPageHeader` variable no longer exists in 3.54.1;
the `(int*)&nPageFile` cast is unchanged.) With `int`, a header value >= 2^31 becomes
negative and is mishandled.

## src/build.c, sqlite3Reindex()
The fix's `if( !IsVirtual(pTab) )` guard in reindexTable() now lives as
`if( IsVirtual(pTab) ) continue;` in the table loop of sqlite3Reindex() (reindexTable
was merged in). Removed that line, so virtual tables (e.g. rtree with PRIMARY KEY/UNIQUE
in the declared schema) have their pTab->pIndex refilled.

## Failing oracle cases
corruptL-1.1..1.4 and resetdb-200/201 fail (resetdb expects "file is not a database" but gets
"unsupported file format" from the negative page count path; corruptL-1.x fail on the
corrupt database with the int page count).
