# Rationale

Fix hunk reversed: `src/insert.c` in `sqlite3GenerateConstraintChecks()`. The fix
wrapped `sqlite3GenerateRowDelete()` in the REPLACE branch with
`OP_CursorLock`/`OP_CursorUnlock` on `iDataCur` when `pTrigger && isUpdate`.
I removed those two `if( pTrigger && isUpdate )` blocks. That is exactly the
pre-fix code. Nothing else in 3.54.1 covers this path, so the revert restores the bug.

The other hunks (OP_CursorLock/Unlock opcodes, BTCF_Pinned, the check in
saveCursorPosition, SQLITE_CONSTRAINT_PINNED) are left in place. Without the
emitted opcodes they are dead code, as the pre-fix behaviour requires.

## Oracle failures
- update-20.20: `UPDATE t1 SET a=0` should fail with "constraint failed" but succeeds.
- update-20.30: integrity_check reports "row 1 missing from index i0", so the
  trigger corrupted the table mid-UPDATE.
