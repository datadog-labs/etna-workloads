# Ticket #3457: hot journal without permissions should give SQLITE_CANTOPEN

## Change (src/pager.c, hot-journal open in pagerSharedLock)
The fix changed the "journal opened read-only" result from SQLITE_BUSY to
SQLITE_CANTOPEN (and removed the generic rc->SQLITE_BUSY remap). In 3.54.1 the
remap is gone and the code already checks `rc==SQLITE_OK && fout&READONLY`;
only the code differs: `SQLITE_CANTOPEN_BKPT`. I reverted that to `SQLITE_BUSY`,
which is the pre-fix value for this hunk.

## Oracle
tkt3457-1.4 (read but no write permission on hot journal) fails: got
"database is locked" instead of "unable to open database file". Other cases
still pass because the open itself fails with CANTOPEN in 3.54.1.
