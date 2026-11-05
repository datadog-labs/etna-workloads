# Rationale

The original fix made sure a snapshot was active for a procedure CALL made right after COMMIT/ROLLBACK. In the original code `exec_stmt_call` pushed a snapshot and `SPI_commit` popped all snapshots. In REL_18_6 that logic has moved. SPI backfills the Portal snapshot, and `fmgr_sql` pushes its own snapshot. I removed both sources of a snapshot. Removing only one is not enough, because the other covers for it.

Hunks (both trace to the fix's "set the snapshot for the CALL in non-read-only context" hunks in `exec_stmt_call`):

1. `src/backend/executor/spi.c`, `_SPI_execute_plan`: removed the `EnsurePortalSnapshotExists()` call. This call is the current form of the snapshot that `exec_stmt_call` used to push for the CALL (the `PushActiveSnapshot(GetTransactionSnapshot())` hunk). After ROLLBACK or COMMIT inside a DO block, the CALL no longer gets a Portal snapshot.
2. `src/backend/executor/functions.c`, `fmgr_sql`: a non-read-only SQL function now takes its own snapshot only if one is already active. This reverses the same hunk's guarantee that a snapshot exists. The SQL procedure no longer gets a snapshot of its own after ROLLBACK, so `Assert(ActiveSnapshotSet())` in `postquel_start` fails.

Failing oracle case: `src/pl/plpgsql/src||plpgsql_transaction`. It fails on the `DO ... ROLLBACK; CALL transaction_test9();` case.
