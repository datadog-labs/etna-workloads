# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c374f2807c236dd8fb4bee9f4ebfe4af300491f9 ("Fix ALTER COLUMN ... DROP EXPRESSION with subpartitions"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||generated_stored`
