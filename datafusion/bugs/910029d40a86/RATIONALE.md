# Rationale

## Changed: datafusion/optimizer/src/decorrelate.rs, `agg_exprs_evaluation_result_on_empty_batch`
Reverses the fix's first hunk, which removed the
`if matches!(result_expr, Expr::Literal(ScalarValue::Int64(_)))` guard around
`expr_result_map_for_count_bug.insert(...)`. The guard is restored (55.2.0
literals carry a second metadata field, so the pattern is `Literal(Int64(_), _)`).
Only Int64 empty-batch results (plain `count`) are now compensated for the
count bug; other non-NULL empty-input values (e.g. `CASE`/string results over
count) are dropped, so a LEFT JOIN yields NULL instead of the empty-input value.

The fix's other hunks (scalar_subquery_to_join.rs: `evaluates_to_null` skip, type
coercion of the compensation expr) are left in place; they only matter once the
map holds non-Int64 entries.

## Oracle
`check.sh` reports a failing case in subquery.slt (line 2579): the NOT EXISTS /
scalar-subquery query returns count 0 instead of 2, i.e. the count-bug
compensation is missing.
