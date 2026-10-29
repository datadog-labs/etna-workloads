# Rationale

Fix hunk reversed: restriction (9) in `pushDownWhereTerms()` (src/select.c), which
refused to push an ON/USING term from the left of a RIGHT JOIN into a subquery to
its right. In 3.54.1 that logic is in `#if 0` in select.c and lives on as rule (6)
of `sqlite3ExprIsSingleTableConstraint()` (src/expr.c), called by the push-down code.

Change: removed the rule (6) block (the EP_OuterON|EP_InnerON / JT_LTORJ check) from
`sqlite3ExprIsSingleTableConstraint()` in src/expr.c. This is the same check as the
fix's (9a)-(9c), so push-down again accepts such terms. The function's other caller
(where.c) also loses the check; the doc comment for rule (6) is left in place.

Oracle failures: pushdown-4.1 (expected `- - 3 - 5`, got empty result) and
pushdown-5.0 (expected `- - 3 4 5`, got empty): the ON FALSE filter is wrongly
pushed into the view on the right of the RIGHT JOIN, dropping the RIGHT JOIN row.
