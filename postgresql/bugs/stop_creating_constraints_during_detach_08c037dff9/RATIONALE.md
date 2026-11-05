# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit 08c037dff96103f607d30c487d11d3bf43a531ea ("Stop creating constraints during DETACH CONCURRENTLY"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/commands/tablecmds.c

Failing oracle cases:
- `src/test/regress||alter_table`
