# Rationale

55.2.0 still contained the fix, so the fix was reverted in place.

1. `datafusion/optimizer/src/push_down_filter.rs`: removed the early return
   `if filter.input.fetch()?.is_some() || filter.input.skip()?.is_some()`.
   This reverses the fix's hunk in `PushDownFilter::rewrite`. Filters are again
   pushed below Sort-with-fetch and TableScan-with-fetch, so the limit is
   applied after the filter. The `fetch()`/`skip()` helpers in plan.rs are left
   (unused, harmless).
2. `datafusion/physical-plan/src/sorts/sort.rs`, `SortExec::gather_filters_for_pushdown`:
   restored the pre-fix code. Pre phase always uses `from_children`, and Post
   phase always uses `ChildFilterDescription::from_child`. This is the same
   defect on the physical side (the fix's second hunk), so the TopK
   self-filter handling is unchanged.

Expected oracle failures: limit.slt (`SELECT * FROM (SELECT ... ORDER BY value
LIMIT 3) sub WHERE ...` gives wrong rows and the EXPLAIN plan differs) and
window.slt (the plan with Filter above Sort fetch=5 differs).
