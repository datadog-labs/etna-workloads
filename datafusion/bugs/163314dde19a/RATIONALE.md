# Rationale

Fix #14192 made EnsureSorting keep a `SortExec`'s `fetch` (LIMIT) when the sort is
removed, replaced by an SPM, or pushed down. In 55.2.0 the code lives in
`datafusion/physical-optimizer/src/ensure_requirements/enforce_sorting/`.
Each edit drops the fetch again:

- `sort_pushdown.rs` `assign_initial_requirements`: `fetch: child.plan.fetch()` -> `None`
  (reverses the `sort_pushdown.rs` hunk in `assign_initial_requirements`).
- `sort_pushdown.rs` `pushdown_sorts_helper`, both sort branches: the sort's own fetch is no
  longer merged (`min_fetch(sort_fetch, parent_fetch)` -> `parent_fetch`). This reverses the
  `requirements.data.fetch.or(sort_fetch)` / `sort_fetch.or_else(..)` hunks; 55.2.0 uses
  `min_fetch` in place of those.
- `mod.rs` `analyze_immediate_sort_removal`: SPM replacing the sort no longer `.with_fetch(sort_exec.fetch())`.
- `mod.rs` `remove_corresponding_sort_from_sub_plan`: SPM no longer `.with_fetch(fetch)`.
- `replace_with_order_preserving_variants.rs` `plan_with_order_preserving_variants`: SPM no longer `.with_fetch(fetch)`
  (the `fetch` parameter is still threaded through, as in the fix's signature change).

## Oracle
`./check.sh`: topk.slt fails (`select * from (select * from topk limit 8) order by x limit 3`
no longer keeps the TopK fetch). The edits also change plans in aggregates_topk.slt
(`SortExec: TopK(fetch=3)` becomes a plain `SortExec`).
