# Rationale

Hunk: src/backend/replication/logical/relation.c, `logicalrep_rel_open()`.
Traces to the single hunk of fix_impl.patch. I removed the `attnum < 0` guard (`entry->attrmap->attnums[attnum] < 0 ||`) before `bms_is_member(...)` in the replica identity key check loop.
Without the guard, a local column with no remote counterpart has attrmap value -1. That value is passed to `bms_is_member`, which raises "negative bitmapset member not allowed". Logical replication fails when the subscriber table has extra columns.

Failing oracle case:
- src/test/subscription|t/008_diff_schema.pl|check replicated inserts on subscriber
