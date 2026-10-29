# Rationale

Hunk changed: `tree/src/parse.y`, rule `groupby_opt`: `GROUP BY nexprlist(X)` -> `GROUP BY exprlist(X)`.

This reverses the first fix hunk (`exprlist` -> `nexprlist` in `groupby_opt`). In 3.54.1 `exprlist` is
already the optional list (`exprlist ::= .` yields 0) and `nexprlist` the non-empty one, so the
fix's grammar split still exists. Pointing GROUP BY back at `exprlist` allows an empty GROUP BY, as before the fix.
The other fix hunks (the split itself) remain, since other rules use them.

Oracle failures: select3-2.13 (`GROUP BY ORDER BY log`) and select3-2.14 (`GROUP BY;`) no longer
give a syntax error; the queries are accepted.
