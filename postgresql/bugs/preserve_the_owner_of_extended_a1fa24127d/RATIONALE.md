# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit a1fa24127d6a24611e5ec8e5b00584b333a3a06c ("Preserve the owner of extended statistics rebuilt by ALTER TABLE."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/statscmds.c, src/backend/commands/tablecmds.c, src/backend/tcop/utility.c, src/include/commands/defrem.h, src/include/nodes/parsenodes.h

Failing oracle cases:
- `src/test/regress||stats_ext`
