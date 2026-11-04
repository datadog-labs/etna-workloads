# Rationale

The fix was partly still present in 55.2.0 (builder `project_with_validation_and_schema`, planner context field, `select.rs` plumbing). Rather than revert every piece, I removed the one piece that feeds the mechanism.

## Changed: `datafusion/sql/src/set_expr.rs`
Reverses the `set_expr.rs` hunk of the fix. The code that saved the left plan's schema into the planner context before planning the right side is removed, along with the `use std::sync::Arc;` import the fix added. The `set_set_expr_left_schema(None)` reset after the right side is kept; it is harmless. With no schema stored, `select_to_plan` always receives `None`. `project_with_validation` then never aliases right-side expressions to the left side's field names. This is the pre-fix behaviour: right-hand SELECTs go through `validate_unique_names` with their own names.

## Oracle failures (`union.slt`)
- `SELECT name, 1 as table, 1 as row ... UNION ALL SELECT name, 2, 2 ...` fails with "Projections require unique expression names ... Int64(2) at position 1 and position 2".
- The nested UNION/EXCEPT/INTERSECT query with `SELECT 2, 0, 0` fails with the same duplicate-name error for `Int64(0)`.
