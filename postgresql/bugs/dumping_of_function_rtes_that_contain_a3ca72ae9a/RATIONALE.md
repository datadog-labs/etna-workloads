# Rationale
File: src/backend/utils/adt/ruleutils.c, function get_from_clause_item (two hunks, RTE_FUNCTION case).
Traces to the two get_from_clause_item hunks of fix_impl.patch: the fix replaced get_rule_expr() with
get_rule_expr_funccall() when deparsing rtfunc->funcexpr. I reverted both call sites to get_rule_expr(),
so non-function-call expressions in FUNCTION RTEs are no longer wrapped in CAST(... AS type), producing
SQL that does not parse back. The other fix hunks (looks_like_function use in index/partkey code) are already
in different form/unrelated in today's code; the helper remains but is now unused by these sites.

Failing oracle case: src/test/regress||create_view
