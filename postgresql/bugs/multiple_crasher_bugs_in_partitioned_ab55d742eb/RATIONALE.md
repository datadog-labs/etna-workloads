# Rationale

## Changed hunk
- File/function: `src/backend/replication/logical/relation.c`, `logicalrep_partition_open()`
- Traces to the `relation.c` hunk in fix.patch that replaces `entry->attrmap = attrmap;` with a `make_attrmap()` + `memcpy()` copy.
- The change goes back to `entry->attrmap = attrmap;`. The partition's map entry then shares the AttrMap with the root's (or the cached) entry. When either entry is freed or rebuilt, the other is left with a dangling pointer or a double free. That is the crash the fix removed.

## Not re-expressed
- The `worker.c` hunks only change log messages and reorder the tuple-routing code. The reverse would not bring back the crash.
- The `pgoutput.c` hunk guarded `execute_attr_map_tuple`. That code now uses slots, so it no longer exists in that form.

## Failing oracle cases
51 of 112 cases fail, mostly in `src/test/subscription|t/013_partition.pl`. Examples:
- update of tab1 replicated
- update of tab2 replicated (and #2, #3)
- update of tab3 replicated
- updates of tab5 replicated correctly
- updating a row that was modified by a different origin
