# Rationale

55.2.0 still contained the fix's `builder.rs` hunks (in `project_with_validation`, datafusion/expr/src/logical_plan/builder.rs; only the line numbers moved), so reversing them applies directly.

Changes, all reversing the fix's hunks in that function:
- Removed `let mut has_wildcard = false;`.
- Removed `has_wildcard = true;` in the `SelectExpr::Wildcard` and `SelectExpr::QualifiedWildcard` arms.
- Removed the `if has_wildcard && projected_expr.is_empty() && !plan.schema().fields().is_empty() { return plan_err!(...) }` check.

Result: `SELECT * EXCEPT/EXCLUDE(all columns)` plans again as a zero-column projection and returns empty rows instead of a planning error.

Oracle: select.slt fails. The `statement error` cases for zero-column wildcards (bare EXCEPT, LIMIT, GROUP BY, WHERE, both JOINs, window) report "query is expected to fail, but actually succeed".
