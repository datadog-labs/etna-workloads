# Rationale

Changed file: `tree/datafusion/sql/src/select.rs` (`select_to_plan`).

Fix hunk reversed: in `select.rs`, the fix replaced the use of the (pre-expanded) `select_exprs`
with `let select_exprs = projected_plan.expressions();`, so that later stages (aliases, GROUP BY,
aggregate/window discovery, final projection) see the wildcard-expanded expressions
now that wildcards are carried as `SelectExpr::Wildcard` until `project()` expands them.
Reverting it: `select_exprs` is built from only the `SelectExpr::Expression` entries (the same
`filter_map` the fix uses elsewhere), so wildcard / qualified-wildcard entries are silently dropped from
the expressions used by the rest of the planner.

Oracle: `select.slt` fails. `select *, count(*) over() as ta from t` loses the `*` columns
(only `ta` is produced), and many other `select *` queries return no columns
("query columns mismatch").
