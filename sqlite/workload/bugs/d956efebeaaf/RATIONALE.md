# Rationale

Fix: ce0a4a9b (OP_JournalMode) moved BUSY handling out of the WAL branches into a
common tail: `if( rc ){ if BUSY && p5!=0: rc=OK; eNew=eOld; }`.

Version-3.54.1 already has the simplified tail `if( rc ) eNew = eOld;` in src/vdbe.c OP_JournalMode.
I restored the pre-fix code in the same opcode:
- After `sqlite3PagerCloseWal()` failure: `else if( rc==SQLITE_BUSY && pOp->p5==0 ) goto abort_due_to_error;` (reverses hunk 1).
- After `sqlite3BtreeSetVersion()`: `if( rc==SQLITE_BUSY && pOp->p5==0 ) goto abort_due_to_error;` plus
  `if( rc==SQLITE_BUSY ){ eNew = eOld; rc = SQLITE_OK; }` (reverses hunk 2).
- Removed the common tail `if( rc ) eNew = eOld;` (reverses hunk 3). Non-BUSY errors (e.g. IO)
  no longer reset eNew, so the pager journal mode is set to the new mode despite failure,
  and later `PRAGMA journal_mode` returns incorrect values. BUSY with p5==0 aborts
  before the output register/pager mode is updated.

Oracle failures (test/walmode.test): walmode-4.10, 4.17 (x2), 4.18 — after the
"database is locked" failure of `PRAGMA journal_mode=wal`, the reported journal mode is wrong.
