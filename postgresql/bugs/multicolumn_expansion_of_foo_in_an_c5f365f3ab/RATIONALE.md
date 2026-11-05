# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c5f365f3ab21a345b7a109bc0411895536e9fa69 ("Prevent multicolumn expansion of "foo.*" in an UPDATE source expression."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_target.c

Failing oracle cases:
- `src/test/regress||update`
