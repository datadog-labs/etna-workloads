# Rationale

File: src/backend/commands/tablecmds.c, function CloneRowTriggersToPartition.

Traces to the fix.patch hunk that relaxed the `tgisinternal` skip (the isPartitionTrigger helper is not needed).
In current code, cloned row triggers are no longer marked internal; they are non-internal with `tgparentid` set. So the old
bug is re-expressed as: when the parent is itself a partition, skip any trigger that is itself a clone (`tgparentid` valid).
Triggers therefore don't propagate to sub-partitions (partitioned partitions' children, or tables attached under them),
as in the original bug.

Failing oracle case: src/test/regress||triggers
