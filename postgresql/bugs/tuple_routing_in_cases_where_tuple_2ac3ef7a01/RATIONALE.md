# Rationale

Hunk: src/backend/executor/execPartition.c, ExecFindPartition().
Traces to fix_impl.patch hunk in get_partition_for_tuple() (partition.c) that converts the tuple
into the sub-partitioned parent's rowtype (do_convert_tuple into parent->tupslot) before
extracting the partition key. In today's code this is the `if (dispatch->tupslot)` block that
applies `execute_attr_map_slot`. I disabled it (`if (false && dispatch->tupslot)`), so the
partition key of a sub-partitioned table is extracted from a tuple in the wrong
(parent's) layout when descriptors differ (e.g. dropped columns / differing attribute order),
causing misrouting or wrong results.

Failing oracle case: src/test/regress||insert
