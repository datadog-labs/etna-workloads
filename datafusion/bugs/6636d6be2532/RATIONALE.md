# Rationale

Tree already contained the fix in the same file (`enforce_sorting/mod.rs`), so I removed its
effect in `remove_bottleneck_in_subplan_impl`:

- Dropped the `dist_reqs` / `removable` closure and the `&& removable(0)` gate, so a
  `CoalescePartitionsExec` at `children[0]` is removed positionally again (fix hunk: the
  `remove_from_first_child` condition). The `fetch().is_none()` check, which is newer, is kept.
- Dropped the `removable(idx)` gate and `enumerate` when recursing into other children (fix hunk:
  `if node.data && removable(idx)`), so the walk descends into a join whose build child needs
  `SinglePartition`.
- Removed the `is_root` parameter, which is now unused. The public entry point keeps its signature.

## Oracle
`joins.slt` fails on the new `CollectLeft` LEFT JOIN query. `SanityCheckPlan` reports
"does not satisfy distribution requirements: SinglePartition. Child-0 output partitioning:
UnknownPartitioning(4)", which is the error from the fix's description.
