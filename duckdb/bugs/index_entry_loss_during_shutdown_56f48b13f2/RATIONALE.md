# Rationale

Hunk: src/storage/checkpoint_manager.cpp
- Removed static `HasBufferedIndexReplays(AttachedDatabase&)` and the early return in
  `SingleFileCheckpointWriter::CreateCheckpoint()` (`if (!context && HasBufferedIndexReplays(db)) return;`).
  This undoes the fix's checkpoint_manager.cpp hunks: a context-free (shutdown) checkpoint again proceeds
  even when an unbound index has buffered WAL operations, so the WAL is dropped and the index entries are lost.

The helper methods `TableIndexList::HasBufferedReplays` / `IndexEntry::HasBufferedReplays` are left in place (now unused, harmless public API).

## Oracle
See etna-check output below.

```
FAIL     test/sql/storage/wal/wal_replay_unbound_index_shutdown_checkpoint.test
         test/sql/storage/wal/wal_replay_unbound_index_shutdown_checkpoint.test:56
         Wrong row count in query! Expected 1 rows, but got 0 rows
         SELECT * FROM db.t WHERE a = 1000;
1 of 1 oracle units fail
```
