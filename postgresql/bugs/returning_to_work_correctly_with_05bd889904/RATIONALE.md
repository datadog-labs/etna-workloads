# Rationale

Changed: `src/src/backend/executor/execPartition.c`, `ExecInitPartitionInfo()`, in the RETURNING projection block.

The call `map_variable_attnos(returningList, firstVarno, 0, ...)` now passes a hard-coded `1` instead of the real result relation's varno.

Traces to the `fix_impl.patch` hunks in `ExecInitModifyTable`/`map_partition_varattnos`. Those hunks added a `target_varno` parameter (`node->nominalRelation`) so that per-partition RETURNING lists are translated using the real result relation varno, instead of the hard-coded varno 1 that `map_partition_varattnos` used before the fix. Today's code does this mapping in `ExecInitPartitionInfo`, with `firstVarno` in the role of `target_varno`.

Why it brings the bug back: when the result relation's rangetable index is not 1, the Vars in RETURNING are not remapped to the partition's attribute numbers. A partition whose column layout differs from the parent's then returns wrong or garbage RETURNING values for tuple-routed INSERTs.

Failing oracle case: `src/test/regress||insert`.

The other hunks of the original fix (ExecInsert result-relation restore ordering, the signature change) have no direct equivalent in the current code, so I did not touch them.
