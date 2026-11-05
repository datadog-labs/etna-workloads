# Reintroduced bug

Changes (all trace to fix.patch):

1. `src/backend/parser/parse_agg.c`, `check_agglevels_and_constraints` (2 messages) and `transformWindowFuncCall` (1 message): reverted "partition key expressions" to "partition key expression". This traces to the parse_agg.c hunks of fix.patch that pluralised these messages. The regression output (create_table) expects the plural form, so it now differs.
2. `src/backend/parser/parse_expr.c`, `transformSubLink`: removed the `EXPR_KIND_CALL_ARGUMENT` "cannot use subquery in CALL argument" error and listed it among the "okay" kinds. This traces to the parse_expr.c hunk that added the error case and removed `EXPR_KIND_CALL` from the okay list. Subqueries in CALL arguments are accepted by the parser again.

The enum rename (CALL -> CALL_ARGUMENT) is cosmetic and was left in place.

Failing oracle case: src/test/regress||create_table
