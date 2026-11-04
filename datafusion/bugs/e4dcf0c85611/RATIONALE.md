# Rationale

Fix hunk reversed: in `select_to_plan` (datafusion/sql/src/select.rs), the fix added a
search for aggregates in ORDER BY (`order_by_aggrs`) and merged them into `aggr_exprs`
passed to `aggregate()`. In 55.2.0 the code is merged with the DISTINCT ON aggregates
(`order_by_aggrs.into_iter().chain(on_aggrs)`). I removed the ORDER BY search and
iterate only over `on_aggrs`, restoring the pre-fix `aggr_exprs` (SELECT/HAVING/QUALIFY
aggregates only; DISTINCT ON handling is unrelated and kept).

Effect: `select a from t group by a order by min(b)` no longer places `min(b)` in the
Aggregate, so the sort expression is not available (the original #18683 failure:
missing field / unsupported AggregateFunction in the physical plan).

Oracle: order.slt fails, e.g. `SELECT column2 FROM foo ORDER BY SUM(column1)` now yields
"Physical plan does not support logical expression AggregateFunction" instead of the
expected planning error, and the group-by/order-by-min cases regress likewise.
