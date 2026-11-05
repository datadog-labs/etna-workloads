# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit c83a38758d2a9b4a72ec8f7e218f7546457f265d ("Handle self-referencing FKs correctly in partitioned tables"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||foreign_key`
- `src/test/regress||triggers`
