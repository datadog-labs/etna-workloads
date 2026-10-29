repro.sql: a view selects TRUE alongside a window function (blocking nothing but forcing the flattener's substExpr path). Querying `WHERE ('500' IS v0.c1) IS FALSE` should return the row `1.0|1`.
Clean shell returns the row; buggy shell returns nothing, because `IS v0.c1` is rewritten to `IS TRUE`/`IS FALSE` after substitution of the literal TRUE.
