# Rationale

## Hunk changed
`datafusion/physical-plan/src/filter.rs`, `collect_columns_from_predicate_inner`: removed the
`has_direct_column_operand` guard (fix hunk 3). Eq/NotEq pairs where neither side is a `Column`
(e.g. `nvl(c, '0') = '0'`) are again extracted into equivalence classes, so `normalize_expr`
rewrites the literal `'0'` inside unrelated sort/window CASE WHEN expressions.

## Not reverted
The `extend_constants` / `expr_constant_or_literal` hunk no longer exists in 55.2.0
(constant handling was reworked), and it is an additive improvement, not the cause of the error.

## Oracle
`window.slt` (issue_20194 query) fails with a SanityCheckPlan error: BoundedWindowAggExec's
required ordering does not match SortExec's output ordering, whose CASE WHEN keys had `0`
replaced by the NVL expression.
