# Rationale

The fix made the partition-constraint check also run for tuple-routed rows when the leaf partition has a BEFORE ROW INSERT trigger, since the trigger may change the row. I removed that condition in two places.

1. `src/backend/executor/nodeModifyTable.c`, `ExecInsert`. This traces to the `nodeModifyTable.c` hunk of fix_impl.patch (the `check_partition_constr` logic). The partition check now runs only when `ri_RootResultRelInfo == NULL`, so routed tuples skip it even with a BR trigger.
2. `src/backend/commands/copyfrom.c`, `CopyFrom`. This traces to the `copy.c` hunk of fix_impl.patch. The condition `(proute == NULL || has_before_insert_row_trig)` became `proute == NULL`.

Result: a BR trigger can modify a routed row so it violates the partition constraint, and the row is inserted anyway.

Failing oracle case: src/test/regress||insert (see the run result below).
