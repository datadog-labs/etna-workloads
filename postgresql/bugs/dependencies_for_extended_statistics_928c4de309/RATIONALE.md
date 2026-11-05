# Rationale

## src/backend/commands/statscmds.c, CreateStatistics()
Traces to the statscmds.c hunk in fix.patch that replaced the single
table-level AUTO dependency with one AUTO dependency per column used in the
stats. I reverted that part: the per-column loop over `attnums[]` is replaced
by a single AUTO dependency on the whole relation (`ObjectAddressSet(parentobject,
RelationRelationId, relid)`).

Effect: the statistics object depends only on the table, not on its columns.
So `ALTER TABLE ... DROP COLUMN` no longer drops extended statistics that
involve that column. The stats object is left with a stale stxkeys entry. Only
DROP TABLE removes it.

Not reverted: the heap.c `RemoveStatisticsExt` hunks. The current code has no
such function, and the dependency-based removal is the mechanism in use today.

## Oracle cases expected to fail
- src/test/regress||stats_ext — confirmed FAIL
