# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d7a2b5bd8718a6207fb364318d7f7cccdf6219c3 ("Clarify a foreign key error message"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||alter_table`
- `src/test/regress||enum`
- `src/test/regress||foreign_key`
- `src/test/regress||without_overlaps`
