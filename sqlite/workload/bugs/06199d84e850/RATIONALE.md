# Rationale

## Change: src/backup.c, sqlite3_backup_step()
Removed the `if( destMode==PAGER_JOURNALMODE_WAL ){ rc = sqlite3BtreeSetVersion(p->pDest, 2); }`
block after the schema reset. This reverses the fix's added hunk in src/backup.c, which
(in 2011 code) added exactly that call. Without it, the file-format version bytes (offsets 18/19)
copied from a rollback-mode source stay 1, so a WAL destination is silently switched to rollback mode.

The fix's btree.c hunk (removing `assert( pBtree->inTrans==TRANS_NONE )`) is only an assert
that is already absent in 3.54.1, so nothing to revert.

## Oracle failures (test/walbak.test)
- walbak-1.6.1: bytes 18..19 of test.db are 0101 instead of 0202.
- walbak-4.2.7: rollback source over WAL dest; after reopening, journal_mode is `delete`, expected `wal`.
