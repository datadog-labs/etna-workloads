# Rationale

File: src/backend/commands/tablecmds.c, function RemoveRelations.

Traces to the fix_impl.patch hunk that adds the `find_all_inheritors(state.heapOid, state.heap_lockmode, NULL)` call for `RELKIND_PARTITIONED_INDEX`. I removed that block, along with its comment. DROP INDEX on a partitioned index no longer locks all the children of the parent table before the drop starts. The child index partitions get locked before their tables, which is the opposite order from regular queries. That brings back the deadlock risk.

I did not revert the rest of the fix, which is refactoring that passes data back from the callback.

Failing oracle case: src/test/isolation||partition-drop-index-locking
