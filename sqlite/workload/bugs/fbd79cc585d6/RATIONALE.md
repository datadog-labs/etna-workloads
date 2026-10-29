# Rationale

Both fix hunks were reverted (the code still had both lines, so each is simply removed):

1. `ext/fts5/fts5_index.c`, `sqlite3Fts5IndexReinit()`: removed the `fts5IndexDiscardData(p);` call.
   Reverses the fix's index hunk. Without it, pending in-memory hash data from earlier
   writes in the same transaction survives a 'rebuild' and gets flushed on top of the rebuilt index.
2. `ext/fts5/fts5_storage.c`, `sqlite3Fts5StorageDeleteAll()`: removed `p->bTotalsValid = 0;`.
   Reverses the fix's storage hunk. Cached totals (row count / token counts) stay "valid" after
   the table is emptied, so a rebuild in a transaction with other updates (or two rebuilds) uses stale totals.

Oracle failures: fts5misc-4.2 and fts5misc-4.4 (integrity-check fails after
rebuild inside a transaction with other updates, and after double rebuild).
