# Rationale

In 55.2.0 the physical-planner hunk of the fix (`extract_dml_filters` with target scoping, TableScan.filters, dedup) is already present, so only the `datafusion/sql/src/statement.rs` hunk could be reversed.

## Changed: datafusion/sql/src/statement.rs (UPDATE planning)
Reverses the fix's statement.rs hunk:
- Removed the `if update_from.is_some() { return not_impl_err!("UPDATE ... FROM is not supported"); }` guard, so UPDATE ... FROM is planned again (the pre-fix behaviour, which gave wrong results because qualifier stripping makes `t2.b` resolve to the target's `b`).
- "Multiple tables in UPDATE SET FROM" is again `plan_err!` instead of `not_impl_err!`.

## Oracle failures (update.slt)
Fails 1 of 1 file. Cases failing: `explain update ... from t2` and `update ... from t2` (including the aliased forms) now succeed where an error is expected, and the multi-table case reports "Error during planning" instead of "This feature is not implemented".
