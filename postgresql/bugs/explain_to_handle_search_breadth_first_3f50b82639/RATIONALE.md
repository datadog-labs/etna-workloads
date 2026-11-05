# Rationale

Changed hunk: `src/src/backend/utils/adt/ruleutils.c`, `set_deparse_plan()`.
Traces to the fix.patch hunk adding `else if (IsA(plan, WorkTableScan)) dpns->inner_plan = find_recursive_union(...)`.
I removed that branch. A WorkTableScan then has no INNER referent (inner_plan is NULL), so EXPLAIN VERBOSE cannot resolve Vars that reference the recursive CTE. That is the case for SEARCH BREADTH FIRST queries, which use a row-constructor column. Deparse then fails or gives wrong output.
`find_recursive_union` is left in place but unused. Only the call site was removed, which is the minimal change.

Oracle case expected to fail: `src/test/regress||with`.
