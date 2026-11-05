# Rationale

## Changed hunk
- `src/backend/replication/slotfuncs.c`, `pg_physical_replication_slot_advance()`: removed the `ReplicationSlotMarkDirty()` call (and its comment) after `restart_lsn` is advanced. This reverses the first hunk of fix_impl.patch. The other hunks of the fix were comment-only, or removed a block in `pg_replication_slot_advance` that current code no longer has.
- Why it brings the bug back: the advanced slot is no longer marked dirty. It is therefore not written at the next checkpoint or at shutdown, and the advanced restart_lsn is lost after a clean restart.

## Failing oracle cases
- src/test/recovery|t/001_stream_rep.pl|physical slot advance persists across restarts
- src/test/recovery|t/001_stream_rep.pl|WAL segment <N> recycled after physical slot advancing
