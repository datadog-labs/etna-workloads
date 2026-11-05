# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 46e3442c9ec858071d60a1c0fae2e9868aeaa0c8 ("Fix failures in validateForeignKeyConstraint's slow path."), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_key`
