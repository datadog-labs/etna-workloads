# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 21fdc37d219acebd298d2e7b309b111a5174ae4c ("Fix CREATE TABLE LIKE with not-valid check constraint"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/parser/parse_utilcmd.c

Failing oracle cases:
- `src/test/regress||create_table_like`
