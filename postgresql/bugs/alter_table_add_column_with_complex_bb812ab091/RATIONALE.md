# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bb812ab0917e153f11bf449d7cb996815c07e387 ("Fix ALTER TABLE .. ADD COLUMN with complex inheritance trees"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||inherit`
