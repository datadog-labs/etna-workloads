# Rationale

Changed: `src/backend/executor/spi.c`, `_SPI_commit()`.

Traces to the fix.patch hunk that wraps `_SPI_commit` in `PG_TRY/PG_CATCH`. The fix catches errors raised during COMMIT (including `HoldPinnedPortals` and `CommitTransactionCommand`). It aborts the failed transaction, starts a new one, resets `internal_xact`, and rethrows the error. I removed that handling and went back to the straight-line commit code.

Why this brings the bug back: an error during commit, such as a deferred constraint failure, leaves the session in an aborted transaction state. `internal_xact` also stays true. The PLs (plpython, pltcl) then can't recover, and their exception handling misbehaves.

Only the `_SPI_commit` part of the fix is reverted. `_SPI_rollback` still has the `PG_TRY` block, and I did not touch `AtEOXact_SPI`, the PL callers or `SPI_start_transaction`.

Failing oracle cases:
- src/pl/plpython||plpython_transaction
- src/pl/tcl||pltcl_transaction
