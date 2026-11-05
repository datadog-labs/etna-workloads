# Re-introducing the bug fixed by eb89cb43a0d0 ("pgoutput: Fix memory leak due to RelationSyncEntry.map")

In current code, `RelationSyncEntry.map` (a `TupleConversionMap`) is now `RelationSyncEntry.attrmap`
(an `AttrMap`, built in `init_tuple_slot()`). The fix's TupleDesc-copy hunk in `maybe_send_schema()`
is gone: there are no TupleDesc copies inside an AttrMap any more. The other two implementation
hunks still have counterparts in the current code, and both are reverted here.

All changes are in `src/backend/replication/pgoutput/pgoutput.c`.

## Hunk 1: `get_rel_sync_entry()`, new-entry initialization
Traces to fix.patch hunk `@@ -1011,6 +1028,7 @@ get_rel_sync_entry`, which added
`entry->map = NULL; /* will be set by maybe_send_schema() if needed */`.
I removed the matching `entry->attrmap = NULL;`. A newly created hash entry now has an
uninitialized map pointer. For a relation that is published as itself
(`publish_as_relid == relid`), `init_tuple_slot()` never sets `attrmap`. `pgoutput_change()` then
tests `if (relentry->attrmap)` and passes the garbage pointer to `execute_attr_map_slot()`.

## Hunk 2: `rel_sync_cache_relation_cb()`, invalidation
Traces to fix.patch hunk `@@ -1191,12 +1209,24 @@ rel_sync_cache_relation_cb`, which added code to
free the map and reset `entry->map = NULL` when an entry is invalidated.
I removed the matching `if (entry->attrmap) free_attrmap(entry->attrmap); entry->attrmap = NULL;`.
After invalidation the old map is never freed (the memory leak this commit fixed), and the stale
pointer stays in the entry.

## Failing oracle cases
The publisher's walsender crashes with signal 11 (Segmentation fault) at the first replicated
change, so `t/013_partition.pl` dies before it runs any subtest. All 74 oracle cases fail
(`missing`), including:
- src/test/subscription|t/013_partition.pl|check replica insert after trigger applied on subscriber
- src/test/subscription|t/013_partition.pl|delete from tab1 replicated
- src/test/subscription|t/013_partition.pl|update of tab1 replicated
- src/test/subscription|t/013_partition.pl|truncate of tab2 replicated
- ... and every other case listed in oracle.json (74/74).


<!-- produced on retry with opus -->
