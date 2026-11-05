# Rationale
Changed: src/backend/parser/scan.l, `{operator}` rule action (fix_impl.patch hunk 2 of scan.l).
Removed the `if (nchars == 2)` block that returns EQUALS_GREATER / GREATER_EQUALS / LESS_EQUALS / NOT_EQUALS
after trailing chars are stripped (yyless). Without it, e.g. `a>=-1` or `x<>/*c*/y` lexes the leftover
2-char operator as generic Op instead of the keyword token, so the grammar fails.
(Comment-only hunks, and the psqlscan.l/pgc.l copies, are not behavior-relevant/not tested.)

Failing oracle cases: src/test/regress||create_operator, src/test/regress||polymorphism
