# Rationale

The fix touched `is_wildcard` in `count_wildcard_rule.rs` (changed from `Expr::Wildcard { qualifier: None, .. }` to `Expr::Wildcard { .. }`), and added `QualifiedWildcard` handling in the SQL planner.
In 55.2.0 `CountWildcardRule` no longer exists. The same check now lives in `datafusion/functions-aggregate/src/planner.rs` (`plan_aggregate`'s count()/count(*) → count(1) rewrite).

## Change
`datafusion/functions-aggregate/src/planner.rs`: the match on `raw_expr.args[0]` goes from `Expr::Wildcard { .. }` back to `Expr::Wildcard { qualifier: None, .. }`.
This reverses the `is_wildcard` hunk: a qualified wildcard such as `count(t.*)` is no longer rewritten to `count(1)`.

The SQL-planner hunk (`QualifiedWildcard` arm in `sql/src/expr/function.rs`) is left alone. Removing it would produce an unrelated "Unsupported" error and also break `Invalid qualifier foo`, so the one-line revert is the minimal form of the bug.

## Expected oracle failure
`aggregate.slt`: `SELECT COUNT(aggregate_test_100.*) FROM aggregate_test_100` no longer returns 100 (the wildcard is not rewritten and later fails or gives a wrong result).
