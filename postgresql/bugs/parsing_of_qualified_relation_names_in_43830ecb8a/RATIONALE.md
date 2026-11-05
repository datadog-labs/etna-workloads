# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 43830ecb8a9b6a1bc322298a77a5e0d87c2e83d4 ("Fix parsing of qualified relation names in RETURNING."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_relation.c

Failing oracle cases:
- `src/test/regress||returning`
