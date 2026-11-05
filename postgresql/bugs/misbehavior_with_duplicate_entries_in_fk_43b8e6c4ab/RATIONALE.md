# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 43b8e6c4abfb632bbff5b3a26dc39bf3f188afff ("Repair misbehavior with duplicate entries in FK SET column lists."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/catalog/pg_constraint.c, src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_key`
