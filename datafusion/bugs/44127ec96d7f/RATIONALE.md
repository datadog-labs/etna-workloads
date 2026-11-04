# Rationale

In 55.2.0 the fixed logic lives in `datafusion/functions-window/src/lead_lag.rs` (lead/lag became a UDWF), not in `physical-plan/src/windows/mod.rs`.

## Changes
- `parse_expr` is the successor of `rewrite_null_expr_and_data_type`'s expression half. It now always returns the original expression, so a NULL (Null-typed) first argument is no longer rewritten into a typed NULL literal matching the default value's type. This is the pre-fix `Arc::clone(&args[0])`.
- `parse_expr_field` is the successor of the return-type half. It now returns the first argument's field (type Null) instead of the default value's field. This is the pre-fix `out_data_type` unchanged.

## Oracle failures
`window.slt` fails on the `LEAD/LAG(NULL, n, <bool>) OVER ()` cases from the fix. Those queries now error with `Cast error: Casting from Boolean to Null not supported`, because the default is cast to a Null type. The correct output is `NULL`/`false`.
