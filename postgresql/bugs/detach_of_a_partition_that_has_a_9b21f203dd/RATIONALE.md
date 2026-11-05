# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 9b21f203dd879a6a7eb3b8629f3d8cae0c1381a5 ("Fix detach of a partition that has a toplevel FK to a partitioned table"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_key`
