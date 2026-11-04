# Rationale

55.2.0 still contained the fixed code in `datafusion/sql/src/select.rs` (GROUP BY ALL expansion), so the fix hunks reverse directly.

- Import hunk: restored `Alias` in `use datafusion_expr::expr::{Alias, PlannedReplaceSelectItem, WildcardOptions}`.
- Filter hunk: replaced `find_aggregate_exprs(once(select_expr)).is_empty()` with the old match that only skips a bare `AggregateFunction` or an `Alias` directly wrapping one. Aggregates nested deeper (e.g. a double alias or `count(*)+1`) are no longer skipped, so they end up in the GROUP BY list.

`find_aggregate_exprs` is still used elsewhere in the file, so no unused import results.

## Oracle
`group_by.slt` fails at the case `SELECT COUNT(*) AS c FROM tab3 GROUP BY ALL`: "Physical plan does not support logical expression AggregateFunction(...)". This is the failure reported in #20909, where an aggregate ended up in the grouping expressions.
