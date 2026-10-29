# Rationale

Fix hunk (src/expr.c, sqlite3ExprCompare): `sqlite3StrICmp` -> `strcmp` when comparing literal tokens.

In 3.54.1 the same comparison is the final `else if` branch in `sqlite3ExprCompare` (src/expr.c ~line 6742), already using `strcmp`. I changed it back to `sqlite3StrICmp`, so `x='a'` and `x='A'` compare as identical. Aggregate-query optimisation then merges the two count() terms.

Oracle: `tkt-fa7bf5ec-1` fails. Expected `1 2`, got `1 1`.
