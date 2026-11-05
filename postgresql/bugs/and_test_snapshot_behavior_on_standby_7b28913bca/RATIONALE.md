# Rationale

Changed hunk: `src/backend/storage/ipc/procarray.c`, `ExpireTreeKnownAssignedTransactionIds()`.
It traces to the single implementation hunk in fix.patch. I removed the `TransamVariables->xactCompletionCount++` line, which was `ShmemVariableCache->xactCompletionCount++` in the original fix.

Without the increment, a standby that replays a commit or abort record does not bump xactCompletionCount. `GetSnapshotData` then reuses its cached snapshot, so the snapshot does not see the newly completed transaction.

Failing oracle cases (all in src/test/recovery t/021_row_visibility.pl): COMMIT, UPDATE, committed update visible, finished prepared visible, insert visible, prepared will_abort, prepared will_commit, uncommitted prepared invisible, uncommitted update invisible.
Only "data not visible" still passes.
