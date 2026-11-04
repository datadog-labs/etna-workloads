# Rationale

Change: `datafusion/physical-plan/src/aggregates/grouped_topk_stream.rs`, in `GroupedTopKAggregateStream::intern`. I removed

```rust
if has_nulls && self.is_group_by_only() {
    self.null_group_seen = true;
}
```

Fix hunk reversed: the `intern` hunk that added `null_group_seen = true` for group-by-only aggregation. Before the fix, NULL group keys were skipped (`continue`) and never recorded. Without that hunk, `null_group_seen` is never set, so `emit_columns` never appends the NULL group and the end-of-input check `priority_map.is_empty() && !null_group_seen` behaves as it did before the fix. That is the pre-fix behaviour: NULL keys are dropped for DISTINCT TopK. Later code (the MIN/MAX null-group tracking via `insert_null`) is a separate mechanism and I left it unchanged. The other fix pieces (`done` flag, `emit_columns`) are harmless without the flag, so I kept them.

Oracle failures (`aggregates_topk.slt`, the new DISTINCT/NULL cases):
- `distinct v ... nulls first limit 1/2/3` on varchar and int: NULL is missing from the result.
- `asc nulls last limit 4` and `desc nulls last limit 4`: the trailing NULL is missing.
- `all_nulls ... limit 1`: returns no rows instead of NULL.
