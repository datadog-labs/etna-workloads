# Rationale

## src/backend/optimizer/util/inherit.c, expand_single_inheritance_child()
Traces to the fix.patch hunk that adds the "Construct an alias clause for the child" block
(child_colnames loop + `childrte->alias = childrte->eref = makeAlias(...)`) and its
declarations (child_tupdesc, parent_colnames, child_colnames).

I removed that block and the three declarations. The child RTE (a shallow memcpy of the parent's)
then keeps the parent's eref/alias, so child RTEs no longer get column names matching the child
table's own column order. Also, because alias is no longer set, EXPLAIN loses the
parent alias on child scans. When a child's columns are in a different order or has dropped
columns, EXPLAIN prints wrong column aliases.

The other fix hunks (flat memcpy, bms_copy of cols) are already in the current code and not changed.

## Failing oracle cases
All 13 fail: aggregates, alter_table, inherit, partition_aggregate, partition_join,
partition_prune, rowsecurity, select_parallel, tablesample, union, updatable_views, update, with.
