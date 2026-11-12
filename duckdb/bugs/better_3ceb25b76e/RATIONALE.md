# Rationale

The code has been refactored since the fix's parent (TryRewriteQualifiedCountStar, IsQualifiedCountStar), so the hunks are re-expressed in `src/planner/binder/expression/bind_star_expression.cpp`.

1. `Binder::TryRewriteQualifiedCountStar`: removed the "if alias empty, SetAlias(expr.ToString())" block. This traces to the fix's `expr.SetAlias(Identifier(expr.ToString()))` in `TransformCountStar`. Without it the rewrite is no longer hidden in the column name. On its own this did not make the oracle fail.
2. `Binder::IsQualifiedCountStar`: removed the `ExpressionClass::WINDOW` case. This traces to the fix's `WindowExpression` branch in `TransformQualifiedCountStar`. Window `count(tbl.*) OVER (...)` is no longer recognised as a qualified count star, so the star is left in place and rejected.

Oracle result:
```
FAIL     test/sql/aggregate/aggregates/test_count_qualified_star.test
         test_count_qualified_star.test:189
         SELECT l.id, count(r.*) OVER () FROM l LEFT JOIN r ON l.id = r.id ORDER BY 1;
         Binder Error: STAR expression is only allowed as the root element of an expression. Use COLUMNS(*) instead.
1 of 1 oracle units fail
```
