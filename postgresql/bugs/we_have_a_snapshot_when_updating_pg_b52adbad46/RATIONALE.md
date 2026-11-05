# Rationale
The fix pushed an active snapshot around pg_index updates (which may touch TOAST). I removed those pushes/pops.

- src/backend/catalog/index.c, index_drop(): removed Push/PopActiveSnapshot around index_concurrently_set_dead() (concurrent path), and the snapshot push/pop around the pg_index tuple delete (current code pushes unconditionally; the original was conditional on `concurrent`). Traces to the index.c hunks of fix.patch.
- src/backend/commands/indexcmds.c, DefineIndex(): removed snapshot around index_set_state_flags(INDEX_CREATE_SET_VALID). Traces to the first indexcmds.c hunk.
- indexcmds.c, ReindexRelationConcurrently(): removed snapshot around index_concurrently_swap() and index_concurrently_set_dead(). Traces to the last two hunks.

Effect: pg_index updates (possibly detoasting) run with no active snapshot.

Failing oracle case: src/test/regress||indexing
