# Rationale

Fix #13158 changed `missing_cols` in `LogicalPlanBuilder::sort_with_limit` from a `Vec<Column>` (which collected duplicates) to an `IndexSet<Column>`. This reverts it in `datafusion/expr/src/logical_plan/builder.rs`:

- Removed `use indexmap::IndexSet` (fix hunk 1).
- `add_missing_columns` and `ambiguous_distinct_check` take `&[Column]` again (hunks 2 and 3).
- `sort_with_limit` collects `missing_cols` into a `Vec` with `push`, so a column mentioned twice in ORDER BY (e.g. `ORDER BY column2 % 2, column2`) is listed twice (hunk 4). `add_missing_columns` then builds duplicate projection expressions, and the plan fails with a duplicate-column schema error.

Oracle: `order.slt` case `select column1 from foo order by column2 % 2, column2;` fails with that error.
