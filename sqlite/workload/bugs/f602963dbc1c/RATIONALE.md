# Rationale

Fix hunk 1 (src/wal.c, sqlite3WalRead: `sqlite3OsRead(..., (nOut>sz ? sz : nOut), ...)`).
In 3.54.1 this logic lives in `sqlite3WalReadFrame()`, where the clamp is
`if( nOut>sz ){ memset(pOut+sz,0,nOut-sz); nOut = sz; }`. I removed that block, so
the WAL read requests nOut bytes even when the WAL page size is smaller than the
caller's buffer, causing a short read (SQLITE_IOERR_SHORT_READ -> "disk I/O error").
This is the same defect: a connection with a stale/larger page size reads a WAL frame.

Fix hunk 2 (src/vacuum.c: BEGIN EXCLUSIVE moved before the page-size check) is
still present in 3.54.1 (BEGIN + sqlite3BtreeBeginTrans before the WAL check). I moved
that block back to after the sqlite3BtreeSetPageSize/SetAutoVacuum calls (the pre-fix
order). On its own this did not make any oracle case fail, but it restores the
original ordering. (The `PRAGMA synchronous=OFF` move is not applicable: that pragma
is no longer executed there.)

Oracle failures: wal8-1.1 (VACUUM gives `1 {disk I/O error}` instead of `0 {}`) and
wal8-3.1 (SELECT after `PRAGMA page_size=4096` errors with disk I/O error).
