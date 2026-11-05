# Rationale

The `partbound_datum` grammar rule from the fix no longer exists. Partition bounds are now parsed as general `expr_list` in `gram.y`, and TRUE/FALSE are accepted as ordinary expressions. I re-expressed the bug in the transform step. The effect is the same as before the fix: TRUE and FALSE are rejected as partition bound values.

## Changed hunk
- File and function: `src/backend/parser/parse_utilcmd.c`, `transformPartitionBoundValue()`.
- Traces to the `gram.y` hunk of fix.patch, which added `TRUE_P` and `FALSE_P` alternatives to `partbound_datum`.
- The change raises a syntax error when a bound value is a boolean `A_Const`. That undoes the fix's acceptance of the TRUE and FALSE literals. `FOR VALUES IN (true)` fails again. ruleutils prints bounds in that form, so dump and reload breaks.

## Failing oracle cases
- src/test/regress||create_table
