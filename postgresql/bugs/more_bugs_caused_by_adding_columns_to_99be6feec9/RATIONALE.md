# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 99be6feec9717058b9ac9d80f3584e0a9a6e8580 ("Fix more bugs caused by adding columns to the end of a view."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/parser/parse_relation.c, src/backend/rewrite/rewriteHandler.c

Failing oracle cases:
- `src/test/regress||alter_table`
