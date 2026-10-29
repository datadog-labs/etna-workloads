# Rationale

Fix hunk (src/window.c, windowFullScan, EXCLUDE clause without ORDER BY) reversed in `tree/src/window.c`:

- `pKeyInfo` is again built unconditionally with `sqlite3KeyInfoFromExprList(pMWin->pOrderBy)`, even when pOrderBy is NULL (the fix guarded it with `if( pMWin->pOrderBy )`).
- For `EXCLUDE TIES`, the `OP_Eq` on the current rowid jumps to `lblNext` again (the fix changed the target to 0, patched via `sqlite3VdbeJumpHere` to fall through into the aggregate step). The current row is therefore skipped instead of included.
- The `OP_Compare`/`OP_Jump` sequence is emitted unconditionally, and the `else { OP_Goto lblNext }` branch for the no-ORDER-BY case is removed. With no ORDER BY (nPeer==0, no peer registers) this compares against an empty key.

This is the code as it was before the fix, restored in the same place.

## Oracle failures
test/window8.test: with this change the run crashes/asserts at window8-5.3.1.1 (EXCLUDE TIES/GROUP/NO OTHERS with no ORDER BY), so 110 of 361 oracle cases fail (window8-5.3.*, 5.4.*, 10.*, 11.*, ...).
