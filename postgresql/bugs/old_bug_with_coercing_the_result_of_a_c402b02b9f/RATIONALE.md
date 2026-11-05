# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c402b02b9fb53aee2a26876de90a8f95f9a9be92 ("Fix old bug with coercing the result of a COLLATE expression."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_coerce.c

Failing oracle cases:
- `src/test/regress||collate`
