# Rationale

## Change
`datafusion/physical-optimizer/src/limit_pushdown.rs`, `pushdown_limit_helper`, in the branch where the plan supports limit pushdown, combines input partitions, and `with_fetch(skip_and_fetch)` succeeds.

Reverses the fix hunk that added:

```rust
let mut new_plan = plan_with_fetch;
if global_state.skip > 0 {
    new_plan = add_global_limit(new_plan, global_state.skip, global_state.fetch);
}
```

55.2.0 still contains this code verbatim (it only differs by surrounding refactors), so I removed it and return `plan_with_fetch` directly, as before the fix. When an OFFSET is pending, the fetch is pushed into the partition-combining node (e.g. SortPreservingMergeExec, with fetch = skip+fetch), but the skip is dropped and no GlobalLimitExec is re-added, so the OFFSET is lost.

## Oracle failures
`limit.slt` fails: the EXPLAIN plans for OFFSET+LIMIT over group-by and union lose the top `GlobalLimitExec: skip=..`, and the query results for OFFSET+LIMIT (including the "parent and child subquery" case) return rows that should have been skipped.
