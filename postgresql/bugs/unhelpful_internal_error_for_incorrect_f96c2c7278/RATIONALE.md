# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit f96c2c72788cab3005c8bc6b4934b4928b34a529 ("Avoid unhelpful internal error for incorrect recursive-WITH queries."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_cte.c

Failing oracle cases:
- `src/test/regress||with`
