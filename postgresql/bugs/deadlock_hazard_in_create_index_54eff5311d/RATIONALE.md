# Rationale

File/function: src/backend/commands/indexcmds.c, DefineIndex (concurrent path, after validate_index).

Traces to the fix_impl.patch hunk that drops the catalog snapshot (InvalidateCatalogSnapshot) before
WaitForOlderSnapshots in DefineIndex. In current code that effect is achieved by
CommitTransactionCommand()/StartTransactionCommand() after UnregisterSnapshot(snapshot), which ends
the transaction and discards the catalog snapshot. I removed that commit/restart, so a catalog
snapshot (and its advertised xmin) can still be held while waiting for older snapshots. Concurrent
CREATE INDEX CONCURRENTLY sessions then wait on each other and deadlock.

Failing oracle cases:
- src/test/isolation||multiple-cic
