# Rationale

Hunk reversed: `datafusion/sql/src/planner.rs`, `apply_expr_alias`.
The fix projects the plan's original columns (`schema().columns()` -> `Expr::Column`).
I restored the pre-fix code, which builds `col(field.name())` from the field name. That
re-parses the name as an unqualified identifier and normalizes it to lowercase, and it
splits dotted names. The import was restored to `use datafusion_expr::{Expr, col};` as in
the fix's first hunk.

Oracle: `alias.slt` fails. Aliasing a subquery whose columns are case sensitive or contain a
dot, such as `t_(x, y)` over `"A"` and `"B.C"`, now errors with
"No field named a. Did you mean 't."A"'?" or "No field named b.c".
