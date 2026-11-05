# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 935277b24172979e8244a5399906c358e4176b49 ("Fix inability to reference CYCLE column from inside its CTE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_cte.c

Failing oracle cases:
- `src/test/regress||with`
