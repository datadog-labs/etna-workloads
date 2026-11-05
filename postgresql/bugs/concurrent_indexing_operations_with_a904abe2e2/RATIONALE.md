# Rationale

Both changes undo the fix's rule that temporary relations never use concurrent mode.

1. `src/backend/commands/indexcmds.c`, `DefineIndex()`.
   Traces to the fix.patch hunk that adds `concurrent` and forces it false for temp tables.
   The code now sets `concurrent = stmt->concurrent`, with no check for a temp table.
   `CREATE INDEX CONCURRENTLY` on a temp table therefore goes down the concurrent path again.

2. `src/backend/commands/tablecmds.c`, `RemoveRelations()`.
   Traces to the fix.patch hunk that sets `PERFORM_DELETION_CONCURRENTLY` only for non-temp relations.
   The flag is now set whenever `drop->concurrent` is true, so `DROP INDEX CONCURRENTLY` on a temp index uses the concurrent drop.
   This also makes the `Assert` the fix added in `index_drop()` fail, though I did not touch that Assert.

Failing oracle case: `src/test/regress||create_index`
