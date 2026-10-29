# Rationale

## Changed: src/main.c, sqlite3_db_cacheflush()
Reverses the fix hunk in src/main.c that removed
`if( rc!=SQLITE_OK ){ sqlite3RollbackAll(db, SQLITE_ABORT_ROLLBACK); }`
before `sqlite3BtreeLeaveAll()`. I put the same block back, so an IOERR or FULL
error during the flush rolls back the whole transaction again.

The pager.c hunks (errCode handling in sqlite3PagerFlush and
sqlite3PagerExclusiveLock) are already present in 3.54.1 and I left them alone.
The sqlite.h.in doc hunk is not implementation code, so I didn't touch it.

## Oracle result
cffault-1.2 (the first case with an error in the flush body) hits the assertion
`unlockBtreeIfUnused: countValidCursors(pBt,0)==0 || pBt->inTransaction>TRANS_NONE`
in testfixture. The unexpected rollback runs while a SELECT cursor is still open.
The "Transaction rolled back!" checks in 1.1, 2.2 and 2.3 guard against the same
defect.
