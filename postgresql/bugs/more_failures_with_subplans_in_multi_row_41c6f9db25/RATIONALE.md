# Rationale

Reverted the fix in `src/src/backend/executor/nodeValuesscan.c` and `src/src/include/nodes/execnodes.h`, matching the hunks of fix_impl.patch.

- `ValuesNext` (nodeValuesscan.c): this restores the old per-row logic. It picks `exprlist` while stepping, always builds the expression state per row with `ExecInitExprList(exprlist, &node->ss.ps)`, and saves and restores `ps.subPlan` and the JIT flags around that call. It no longer uses the precomputed `exprstatelists`.
- `ExecInitValuesScan` (nodeValuesscan.c): this drops the `contain_subplans()` scan and the early expression init for sublists that contain SubPlans. It also drops the `optimizer/clauses.h` include.
- `ValuesScanState` (execnodes.h): this removes the `exprstatelists` field.

Together these bring back the bug. SubPlans in multi-row VALUES lists are built transiently per row, so they are not connected to the outer plan tree. EXPLAIN does not see them, and dangling pointers or leaked resources can result.

Failing oracle case: src/test/regress||subselect
