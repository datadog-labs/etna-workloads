# Rationale

All changes are in `OP_OpenEphemeral` in `tree/src/vdbe.c`. They reverse the three hunks of the fix.

1. Reuse branch (the cursor is already open): removed `pCx->seqCount = 0;` and `pCx->cacheStatus = CACHE_STALE;`. This reverses the fix's added lines. A reopened ephemeral table keeps its old sequence counter and a cache status that may still be valid.
2. New-cursor branch: restored `pCx->nullRow = 1;` right after `allocateCursor()`. This reverses the fix's removal of that line.
3. End of the opcode: removed `pCx->nullRow = 1;` after `if( rc ) goto abort_due_to_error;`. This reverses the fix's addition of that line. `nullRow` is now set only for newly allocated cursors, as before the fix.

## Oracle
`./check.sh` reports 1 error out of 31 tests: `subquery2-5.1`. This is the test the fix added, `SELECT (SELECT y FROM t2 WHERE x=y ORDER BY y,z) FROM t1`. The correlated subquery reuses the ephemeral sorter cursor, whose cache is stale and whose row state is wrong, so it returns the wrong result.
