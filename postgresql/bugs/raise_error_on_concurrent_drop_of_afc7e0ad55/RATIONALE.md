# Rationale
- File: src/backend/commands/tablecmds.c, function RemoveRelations(). Traces to the single fix_impl.patch hunk. I removed the check that raises "cannot drop partitioned index \"%s\" concurrently" when PERFORM_DELETION_CONCURRENTLY is set and the relation is RELKIND_PARTITIONED_INDEX. In current code the check uses state.actual_relkind. Without it, DROP INDEX CONCURRENTLY on a partitioned index proceeds instead of raising the error.

Failing oracle case: src/test/regress||indexing
