# Rationale

## Change: src/wal.c, sqlite3WalClose()
Reverses the wal.c hunk of the fix: the checkpoint-and-delete condition goes back
from `zBuf!=0` to `zBuf!=0 && (db->flags & SQLITE_NoCkptOnClose)==0`. Pre-fix,
sqlite3WalClose() itself consulted the flag (the fix moved that decision into the
pager caller). In 3.54.1 sqlite3PagerClose() already decides this by passing a
NULL buffer, so only the wal.c condition needed re-adding. The other fix hunk
(pager.c, sqlite3PagerClose) is already covered by existing code and is untouched.

The path that breaks is sqlite3PagerCloseWal() (`PRAGMA journal_mode=delete` from
WAL), which passes pTmpSpace and relies on WalClose to checkpoint and delete the
WAL. With NO_CKPT_ON_CLOSE set, the checkpoint is skipped, so test.db-wal is left behind.

## Oracle failure
nockpt-1.15 (`file exists test.db-wal` expected 0) fails. Other cases pass.
