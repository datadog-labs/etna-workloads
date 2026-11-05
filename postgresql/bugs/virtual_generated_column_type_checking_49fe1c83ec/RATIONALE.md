# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 49fe1c83ecf3474776ea9d0db47ae5644d29b67b ("Fix virtual generated column type checking for ALTER TABLE"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||generated_virtual`
