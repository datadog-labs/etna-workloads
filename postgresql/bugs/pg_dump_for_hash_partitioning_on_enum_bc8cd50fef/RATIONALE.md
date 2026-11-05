# Rationale

Changed file: src/bin/pg_dump/pg_dump.c, two hunks. Both trace to fix_impl.patch hunks in pg_dump.c.

1. `dumpTableData_insert()` — the condition for choosing the root table as the INSERT target.
   Traces to the fix.patch hunk that changed `dopt->load_via_partition_root && tbinfo->ispartition` to also test `forcePartitionRootLoad(tbinfo)`.
   The reverted condition ignores the forced case, so INSERT-format dumps of hash-on-enum partitions load directly into the leaf partitions.
2. `dumpTableData()` — the condition that selects the root table and builds the "-- load via partition root" TOC defn.
   Traces to the fix.patch hunk that added the same `forcePartitionRootLoad()` test.
   The reverted condition means COPY data is no longer routed through the root, and the TOC entry carries no marker.
   Parallel restore can then TRUNCATE and COPY directly into a leaf partition, so the rows can't be re-routed when the enum OIDs differ.

`forcePartitionRootLoad()` and `unsafe_partitions` are left in the tree but unused (so unused-function warnings are possible). Only the callers were reverted.

Failing oracle cases:
- parallel restore
- parallel restore as inserts
