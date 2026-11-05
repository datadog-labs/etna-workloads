# Rationale

Reverses the fix (moving origin reset from an error-context callback into PG_CATCH).

- `src/backend/replication/logical/worker.c`, `start_apply()`: removed the `replorigin_reset()` call in PG_CATCH (fix.patch worker.c hunk 2). Forward declaration was already unneeded, left as is.
- `worker.c`, `apply_error_callback()`: restored `geterrlevel()` and the `replorigin_reset()` call when elevel >= ERROR (worker.c hunk 3). The callback only runs with an error context at that time and not reliably before the origin is advanced/abort, so the origin progress can still advance after a failed apply, losing the transaction.
- `src/backend/utils/error/elog.c`: restored `geterrlevel()` (elog.c hunk).
- `src/include/utils/elog.h`: restored its declaration (elog.h hunk).

Failing oracle case:
- src/test/subscription|t/100_bugs.pl|remote_lsn has advanced for apply worker raising an exception
